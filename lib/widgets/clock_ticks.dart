import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math_64.dart' show radians;

class ClockTicks extends StatelessWidget {
  const ClockTicks({Key? key, required this.unit, required this.customTheme}) : super(key: key);

  final double unit;
  final ThemeData customTheme;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // hours ticks
        for (var i = 0; i < 12; i++)
          Center(
            child: Transform.rotate(
              angle: radians(0 + 360 / 12 * i),
              child: Transform.translate(
                offset: Offset(0, i % 3 == 0 ? -10 * unit : -10.2 * unit),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), color: Theme.of(context).iconTheme.color),
                  height: i % 3 == 0 ? 2.4 * unit : 1.5 * unit,
                  width: i % 3 == 0 ? .35 * unit : .2 * unit,
                ),
              ),
            ),
          ),
        // values text
        for (int i = 1; i <= 12; i++)
          Center(
            child: Transform.rotate(
              angle: radians(0 + 360 / 12 * i),
              child: Transform.translate(
                offset: Offset(0, -12.5 * unit),
                child: Text('$i', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500, fontFamily: 'Ubuntu')),
              ),
            ),
          ),
        // in between minutes ticks
        for (int i = 0; i < 60; i++)
          Center(
            child: Transform.rotate(
              angle: radians(0 + 360 / 60 * i),
              child: Transform.translate(
                offset: Offset(0, i % 5 != 0 ? -10 * unit : 0),
                child: Container(
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).iconTheme.color),
                  // height: i % 5 != 0 ? .1 * unit : 0,
                  width: i % 5 != 0 ? 0.17 * unit : 0,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
