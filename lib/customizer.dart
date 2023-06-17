// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:analog_clock/services/constants.dart';
import 'package:analog_clock/models/clock_model.dart';
import 'package:window_manager/window_manager.dart';
import 'package:get/get.dart';

/// Returns a clock [Widget] with [ClockModel].
///
/// Example:
///   final myClockBuilder = (ClockModel model) => AnalogClock(model);
///
/// Contestants: Do not edit this.
typedef ClockBuilder = Widget Function(ClockModel model);

/// Wrapper for clock widget to allow for customizations.
///
/// Puts the clock in landscape orientation with an aspect ratio of 5:3.
/// Provides a drawer where users can customize the data that is sent to the
/// clock. To show/hide the drawer, double-tap the clock.
///
/// To use the [ClockCustomizer], pass your clock into it, using a ClockBuilder.
///
/// ```
///   final myClockBuilder = (ClockModel model) => AnalogClock(model);
///   return ClockCustomizer(myClockBuilder);
/// ```
/// Contestants: Do not edit this.
class ClockCustomizer extends StatefulWidget {
  const ClockCustomizer(this._clock, {super.key});

  /// The clock widget with [ClockModel], to update and display.
  final ClockBuilder _clock;

  @override
  State<ClockCustomizer> createState() => _ClockCustomizerState();
}

class _ClockCustomizerState extends State<ClockCustomizer> with WindowListener {
  final _model = ClockModel();
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _model.addListener(_handleModelChange);
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    _model.removeListener(_handleModelChange);
    windowManager.removeListener(this);
    _model.dispose();
    super.dispose();
  }

  void _handleModelChange() => setState(() {});

  Widget _enumMenu<T>(String label, T value, List<T> items, ValueChanged<T?> onChanged) {
    return InputDecorator(
      decoration: InputDecoration(labelText: label),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: value,
          isDense: true,
          onChanged: onChanged,
          items: items.map((T item) => DropdownMenuItem<T>(value: item, child: Text(enumToString(item)))).toList(),
        ),
      ),
    );
  }

  Widget _textField(String currentValue, String label, ValueChanged<String> onChanged) {
    return TextField(decoration: InputDecoration(hintText: currentValue, helperText: label), onChanged: onChanged);
  }

  @override
  Widget build(BuildContext context) {
    final clock = Align(alignment: Alignment.topCenter, child: AspectRatio(aspectRatio: 4 / 3, child: widget._clock(_model)));

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: transparent,
          actions: [
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(Icons.settings_outlined, color: Theme.of(context).iconTheme.color),
                  tooltip: 'Configure clock',
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                );
              },
            )
          ],
        ),
        endDrawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _textField(_model.location, 'Location', (String location) => setState(() => _model.location = location)),
                  _textField(
                      '${_model.temperature}', 'Temperature', (String temperature) => setState(() => _model.temperature = double.parse(temperature))),
                  // change theme
                  _enumMenu(
                    'Theme',
                    _themeMode,
                    ThemeMode.values,
                    (ThemeMode? mode) {
                      setState(() => _themeMode = mode!);
                      Get.changeThemeMode(mode ?? ThemeMode.system);
                    },
                  ),
                  Row(children: [
                    const Expanded(child: Text('24-hour format')),
                    Switch.adaptive(value: _model.is24HourFormat, onChanged: (value) => setState(() => _model.is24HourFormat = value))
                  ]),
                  // _switch('24-hour format', _model.is24HourFormat, (bool value) => setState(() => _model.is24HourFormat = value)),
                  _enumMenu('Weather', _model.weatherCondition, WeatherCondition.values,
                      (WeatherCondition? condition) => setState(() => _model.weatherCondition = condition!)),
                  _enumMenu('Units', _model.unit, TemperatureUnit.values, (TemperatureUnit? unit) => setState(() => _model.unit = unit!)),
                ],
              ),
            ),
          ),
        ),
        body: clock,
      ),
    );
  }
}
