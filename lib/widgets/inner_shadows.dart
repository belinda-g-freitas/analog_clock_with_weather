import 'package:analog_clock/services/constants.dart';
import 'package:flutter/material.dart';

class InnerShadows extends StatelessWidget {
  const InnerShadows({Key? key, required this.unit, required this.customTheme}) : super(key: key);

  final double unit;
  final ThemeData customTheme;

  @override
  Widget build(BuildContext context) {
    final darkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.all(1.5 * unit),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: customTheme.colorScheme.background,
              gradient: RadialGradient(
                colors: [darkMode ? customTheme.colorScheme.background.withOpacity(0.0) : white.withOpacity(0.0), customTheme.dividerColor],
                center: const AlignmentDirectional(0.1, 0.1),
                focal: const AlignmentDirectional(0.0, 0.0),
                radius: 0.65,
                focalRadius: 0.001,
                stops: const [0.3, 1.0],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: customTheme.colorScheme.background,
              gradient: RadialGradient(
                colors: [
                  darkMode ? customTheme.colorScheme.background.withOpacity(0.0) : white.withOpacity(0.0),
                  darkMode ? white.withOpacity(0.3) : white,
                ],
                center: const AlignmentDirectional(-0.1, -0.1),
                focal: const AlignmentDirectional(0.0, 0.0),
                radius: 0.67,
                focalRadius: 0.001,
                stops: const [0.75, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
