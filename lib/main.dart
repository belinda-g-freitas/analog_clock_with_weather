import 'dart:io';
import 'package:flutter/material.dart';
import 'package:analog_clock/analog_clock.dart';
import 'package:analog_clock/customizer.dart';
import 'package:analog_clock/services/constants.dart';
import 'package:analog_clock/models/clock_model.dart';
import 'package:window_manager/window_manager.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (GetPlatform.isDesktop) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      minimumSize: Size(394.0, 294.0),
      size: Size(394.0, 294.0),
      maximumSize: Size.square(1000),
      center: true,
      // fullScreen: false,
      backgroundColor: transparent,
      // skipTaskbar: true,
      title: 'Multi widgets',
      titleBarStyle: TitleBarStyle.normal,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setMinimizable(false);
      // await windowManager.setResizable(false);
      await windowManager.setIcon('assets/icons/clock.svg');
      if (Platform.isMacOS) await windowManager.setVisibleOnAllWorkspaces(true);
    });
  }
  
  runApp(const AnalogClock());
}

class AnalogClock extends StatelessWidget {
  const AnalogClock({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      enableLog: false,
      title: appName,
      color: Colors.blueGrey[700],
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark() ,
      home: ClockCustomizer((ClockModel model) => Clock(model)),
    );
  }
}
