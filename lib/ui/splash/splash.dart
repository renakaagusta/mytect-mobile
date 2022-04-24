import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:mytect/constants/assets.dart';
import 'package:mytect/constants/colors.dart';
import 'package:mytect/constants/strings.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.light),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    AppColors.PrimaryColor,
                    AppColors.SecondaryColor
                  ])),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Assets.appLogoWhite,
                        height: 100,
                        width: 80,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height: 20),
                      Text(Strings.appName,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                ))));
  }

  startTimer() {
    var _duration = Duration(milliseconds: 2000);
    return Timer(_duration, navigate);
  }

  navigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userFromPeference = prefs.getString("user");
    if (userFromPeference != null) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/dashboard', (Route<dynamic> route) => false);
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/welcome', (Route<dynamic> route) => false);
    }
  }
}
