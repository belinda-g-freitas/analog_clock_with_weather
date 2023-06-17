import 'package:flutter/material.dart';
import 'package:analog_clock/services/constants.dart';

class OuterShadows extends StatelessWidget {
  const OuterShadows({Key? key, required this.customTheme, required this.unit}) : super(key: key);

  final ThemeData customTheme;
  final double unit;

  @override
  Widget build(BuildContext context) {
    final darkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: customTheme.colorScheme.background,
        boxShadow: [
          BoxShadow(color: darkMode ? white.withOpacity(0.2) : white, offset: Offset(-unit / 2, -unit / 2), blurRadius: 1.5 * unit),
          BoxShadow(color: customTheme.dividerColor, offset: Offset(unit / 2, unit / 2), blurRadius: 1.5 * unit),
        ],
      ),
    );
  }
}
