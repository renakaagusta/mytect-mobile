import 'package:another_flushbar/flushbar_helper.dart';
import 'package:mytect/constants/assets.dart';
import 'package:mytect/utils/routes/routes.dart';
import 'package:mytect/widgets/app_icon_widget.dart';
import 'package:mytect/widgets/empty_app_bar_widget.dart';
import 'package:mytect/widgets/rounded_button_widget.dart';
import 'package:mytect/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:mytect/constants/assets.dart';
import 'package:mytect/constants/colors.dart';
import 'package:mytect/constants/strings.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Size size;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
          primary: true, appBar: EmptyAppBar(), body: _buildRightSide()),
    );
  }

  Widget _buildRightSide() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 80.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Hi, welcome to MyTect!', style: TextStyle(fontSize: 24.0)),
            SizedBox(
              height: 50.0,
            ),
            Image.asset('assets/images/onboarding.png', height: 200),
            SizedBox(height: 30.0),
            GestureDetector(
              onTap: () async {
                Navigator.of(context).pushNamed('/signin');
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                width: MediaQuery.of(context).size.width - 40,
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      AppColors.PrimaryColor,
                      AppColors.PrimaryColor,
                    ]),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Text(
                  'Sign In',
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                Navigator.of(context).pushNamed('/signup');
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                width: MediaQuery.of(context).size.width - 40,
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.white,
                      Colors.white,
                    ]),
                    border: Border.all(width: 1, color: AppColors.PrimaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Text(
                  'Sign Up',
                  style:
                      TextStyle(color: AppColors.PrimaryColor, fontSize: 16.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text.rich(TextSpan(
                text: "With sign in or sign up you're accept the ",
                children: <TextSpan>[
                  TextSpan(
                      text: 'Terms of service',
                      style: TextStyle(color: AppColors.PrimaryColor)),
                  TextSpan(text: ' and '),
                  TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(color: AppColors.PrimaryColor))
                ]))
          ],
        ),
      ),
    );
  }
}
