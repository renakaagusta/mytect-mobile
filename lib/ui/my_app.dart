import 'package:mytect/constants/app_theme.dart';
import 'package:mytect/constants/strings.dart';
import 'package:mytect/utils/routes/routes.dart';
import 'package:mytect/ui/splash/splash.dart';
import 'package:flutter/material.dart';
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.appName,
      routes: Routes.routes,
      home: SplashScreen(),
    );}}