import 'package:flutter/material.dart';
import 'package:mytect/ui/main/dashboard.dart';
import 'package:mytect/ui/main/data/data.dart';
import 'package:mytect/ui/main/poeple/poeple_location.dart';
import 'package:mytect/ui/main/profile/privacy/privacy.dart';
import 'package:mytect/ui/main/profile/profile_edit.dart';
import 'package:mytect/ui/main/profile/version/version.dart';
import 'package:mytect/ui/signin/signin.dart';
import 'package:mytect/ui/signup/signup.dart';
import 'package:mytect/ui/splash/splash.dart';
import 'package:mytect/ui/welcome/welcome.dart';

class Routes {
  Routes._();
  static const String splash = '/splash';
  static const String signin = '/signin';
  static const String main = '/dashboard';
  static const String welcome = '/welcome';
  static const String signup = '/signup';
  static const String poepleLocation = '/poeple/location';
  static const String user = '/user';
  static const String data = '/data';
  static const String settingProfile = '/profile/setting';
  static const String editSettingProfile = '/profile/setting/edit';
  static const String privacyProfile = '/profile/privacy';
  static const String helpProfile = '/profile/help';
  static const String versionProfile = '/profile/version';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    welcome: (BuildContext context) => WelcomeScreen(),
    signin: (BuildContext context) => SignInScreen(),
    signup: (BuildContext context) => SignUpScreen(),
    main: (BuildContext context) => MainPage(),
    poepleLocation: (BuildContext context) => PeopleLocationScreen(),
    data: (BuildContext context) => DataScreen(),
    editSettingProfile: (BuildContext context) => ProfileEditScreen(),
    privacyProfile: (BuildContext context) => PrivacyScreen(),
    versionProfile: (BuildContext context) => VersionScreen(),
  };
}
