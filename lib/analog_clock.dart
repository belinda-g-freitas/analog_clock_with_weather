// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import '../../models/clock_model.dart';
import 'widgets/animated_icon.dart';
import 'widgets/clock_pin.dart';
import 'widgets/clock_ticks.dart';
import 'widgets/hour_hand.dart';
import 'widgets/hour_hand_shadow.dart';
import 'widgets/inner_shadows.dart';
import 'widgets/minute_hand.dart';
import 'widgets/minute_hand_shadow.dart';
import 'widgets/outer_shadows.dart';
import 'widgets/second_hand.dart';
import 'widgets/second_hand_circle.dart';
import 'widgets/second_hand_shadow.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

import 'services/weather_icons.dart';

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);

class Clock extends StatefulWidget {
  const Clock(this.model, {super.key});

  final ClockModel model;

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  var _now = DateTime.now();
  WeatherCondition? _condition;
  Timer? _timer;

  final weatherMap = {
    WeatherCondition.sunny: WeatherIcons.sun,
    WeatherCondition.cloudy: WeatherIcons.cloudSolid,
    WeatherCondition.foggy: WeatherIcons.smogSolid,
    WeatherCondition.rainy: WeatherIcons.cloudRainSolid,
    WeatherCondition.thunderstorm: WeatherIcons.boltSolid,
    WeatherCondition.snowy: WeatherIcons.cloudMeatballSolid,
    WeatherCondition.windy: WeatherIcons.windSolid,
  };

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    // Set the initial values.
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(Clock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() => setState(() => _condition = widget.model.weatherCondition);

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      // Update once per second. Make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(const Duration(seconds: 1) - Duration(milliseconds: _now.millisecond), _updateTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            // Hour hand.
            primaryColor: Colors.grey[800],
            // Minute hand.
            highlightColor: Colors.grey[800],
            // Tick color
            //cursorColor: Colors.grey[900],
            iconTheme: IconThemeData(color: Colors.grey[900]),
            // Shadow color
            canvasColor: Colors.grey[500],
            // Inner shadow color
            dividerColor: Colors.grey[400],
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(secondary: Colors.red[800], error: Colors.grey[800]!.withOpacity(0.1), background: Colors.grey[300]),
          )
        : Theme.of(context).copyWith(
            // Hour hand.
            primaryColor: Colors.grey[400],
            // Minute hand.
            highlightColor: Colors.grey[400],
            // Tick color
            //cursorColor: Colors.grey[900],
            iconTheme: IconThemeData(color: Colors.grey[900]),
            // Shadow color
            canvasColor: Colors.grey[900],
            // Inner shadow color
            dividerColor: Colors.grey[900],
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(secondary: Colors.red[800], background: const Color(0xFF3C4043), error: Colors.grey[400]!.withOpacity(0.1)),
          );

    final time = DateFormat.Hms().format(DateTime.now());
    final icon = weatherMap[_condition];

    return LayoutBuilder(
      builder: (context, constraints) {
        final unit = constraints.biggest.width / 50;

        return Semantics.fromProperties(
          properties: SemanticsProperties(label: 'Analog clock with time $time', value: time),
          child: Container(
            padding: EdgeInsets.all(2 * unit),
            color: customTheme.colorScheme.background,
            child: Stack(
              children: [
                OuterShadows(customTheme: customTheme, unit: unit),
                AnimatedClockIcon(customTheme: customTheme, unit: unit, icon: icon!),
                InnerShadows(customTheme: customTheme, unit: unit),
                ClockTicks(customTheme: customTheme, unit: unit),
                HourHandShadow(customTheme: customTheme, unit: unit, now: _now),
                MinuteHandShadow(customTheme: customTheme, unit: unit, now: _now),
                SecondHandShadow(customTheme: customTheme, unit: unit, now: _now),
                HourHand(customTheme: customTheme, unit: unit, now: _now),
                MinuteHand(customTheme: customTheme, unit: unit, now: _now),
                SecondHand(customTheme: customTheme, now: _now, unit: unit),
                SecondHandCircle(customTheme: customTheme, now: _now, unit: unit),
                // clock center
                ClockPin(customTheme: customTheme, unit: unit),
              ],
            ),
          ),
        );
      },
    );
  }
}
