import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mytect/constants/assets.dart';
import 'package:mytect/constants/colors.dart';
import 'package:mytect/constants/strings.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocusNode, passwordFocusNode;
  Size size;

  @override
  void initState() {
    super.initState();
  }

  Future getLocalData() async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    getLocalData();
    size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Color(0x00000000),
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 60,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(CupertinoIcons.chevron_back),
              ),
              SizedBox(
                height: 60,
              ),
              Row(
                children: [
                  Image.asset(Assets.appLogo, height: 40.0, width: 25.0),
                  SizedBox(width: 10),
                  Text(Strings.appName,
                      style: TextStyle(
                          color: AppColors.PrimaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold))
                ],
              ),
              SizedBox(height: 10.0),
              Text("Sign In",
                  style: TextStyle(color: Colors.black, fontSize: 24)),
              SizedBox(height: 50.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                ),
                padding: EdgeInsets.zero,
                width: size.width ,
                child: TextField(
                  controller: emailController,
                  focusNode: emailFocusNode,
                  style: TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: "Email",
                    contentPadding:
                        EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: AppColors.PrimaryColor, width: 1.0),
                        borderRadius: BorderRadius.circular(3)),
                    border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white70, width: 1.0),
                        borderRadius: BorderRadius.circular(3)),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                ),
                padding: EdgeInsets.zero,
                width: size.width,
                child: TextField(
                  controller: passwordController,
                  focusNode: passwordFocusNode,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  style: TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: "Password",
                    contentPadding:
                        EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: AppColors.PrimaryColor, width: 1.0),
                        borderRadius: BorderRadius.circular(3)),
                    border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white70, width: 1.0),
                        borderRadius: BorderRadius.circular(3)),
                  ),
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await firestore
                      .collection('users')
                      .where('email', isEqualTo: emailController.text)
                      .where('password', isEqualTo: passwordController.text)
                      .get()
                      .then((snapshot) async {
                    if (snapshot.docs.length != 0) {
                      prefs.setString(
                          'user',
                          jsonEncode({
                            'id': snapshot.docs[0].id,
                            'username': snapshot.docs[0].data()['username'],
                            'email': snapshot.docs[0].data()['email'],
                            'password': snapshot.docs[0].data()['password'],
                            'picture': snapshot.docs[0].data()['picture'] ?? '',
                          }));

                      Navigator.of(context).pushNamed('/dashboard');
                    } else {
                      await firestore
                          .collection('users')
                          .where('username', isEqualTo: emailController.text)
                          .where('password', isEqualTo: passwordController.text)
                          .get()
                          .then((snapshot) {
                        if (snapshot.docs.length != 0) {
                          prefs.setString(
                              'user',
                              jsonEncode({
                                'id': snapshot.docs[0].id,
                                'username': snapshot.docs[0].data()['username'],
                                'email': snapshot.docs[0].data()['email'],
                                'password': snapshot.docs[0].data()['password'],
                                'picture': snapshot.docs[0].data()['picture'] ?? '',
                              }));

                          Navigator.of(context).pushNamed('/dashboard');
                        } else {
                          Alert(
                              context: context,
                              title: '',
                              closeIcon: null,
                              content: Column(
                                children: <Widget>[
                                  Icon(CupertinoIcons.exclamationmark_triangle,
                                      color: AppColors.PrimaryColor,
                                      size: 100.0),
                                  SizedBox(height: 20.0),
                                  Text('Email or password invalid',
                                      style: TextStyle(fontSize: 20.0))
                                ],
                              ),
                              buttons: [
                                DialogButton(
                                  color: AppColors.PrimaryColor,
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                )
                              ]).show();
                        }
                      });
                    }
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
              SizedBox(height: 20),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/signup');
                  },
                  child: Text.rich(TextSpan(
                      text: "Don't have an account? ",
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(color: AppColors.PrimaryColor)),
                      ])))
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
