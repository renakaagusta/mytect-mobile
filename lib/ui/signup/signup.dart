import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mytect/constants/assets.dart';
import 'package:mytect/constants/colors.dart';
import 'package:mytect/constants/strings.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode usernameFocusNode,
      emailFocusNode,
      passwordConfirmFocusNode,
      passwordFocusNode;
  Size size;

  @override
  void initState() {
    FirebaseAuth auth = FirebaseAuth.instance;
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
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(color: Colors.white),
            child: SingleChildScrollView(
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
                  Text("Sign Up",
                      style: TextStyle(color: Colors.black, fontSize: 24)),
                  SizedBox(height: 50.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                    ),
                    padding: EdgeInsets.zero,
                    width: size.width * 0.78,
                    child: TextField(
                      controller: usernameController,
                      focusNode: usernameFocusNode,
                      style: TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: "Username",
                        contentPadding: EdgeInsets.only(
                            top: 0, bottom: 0, left: 10, right: 10),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppColors.PrimaryColor, width: 1.0),
                            borderRadius: BorderRadius.circular(3)),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white70, width: 1.0),
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
                    width: size.width * 0.78,
                    child: TextField(
                      controller: emailController,
                      focusNode: emailFocusNode,
                      style: TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: "Email",
                        contentPadding: EdgeInsets.only(
                            top: 0, bottom: 0, left: 10, right: 10),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppColors.PrimaryColor, width: 1.0),
                            borderRadius: BorderRadius.circular(3)),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white70, width: 1.0),
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
                    width: size.width * 0.78,
                    child: TextField(
                      controller: passwordController,
                      focusNode: passwordFocusNode,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                      style: TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: "Password",
                        contentPadding: EdgeInsets.only(
                            top: 0, bottom: 0, left: 10, right: 10),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppColors.PrimaryColor, width: 1.0),
                            borderRadius: BorderRadius.circular(3)),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white70, width: 1.0),
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
                    width: size.width * 0.78,
                    child: TextField(
                      controller: passwordConfirmController,
                      focusNode: passwordConfirmFocusNode,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                      style: TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        contentPadding: EdgeInsets.only(
                            top: 0, bottom: 0, left: 10, right: 10),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppColors.PrimaryColor, width: 1.0),
                            borderRadius: BorderRadius.circular(3)),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white70, width: 1.0),
                            borderRadius: BorderRadius.circular(3)),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () async {
                      if (usernameController.text.isEmpty ||
                          emailController.text.isEmpty ||
                          passwordController.text.isEmpty ||
                          passwordConfirmController.text.isEmpty) {
                        Alert(
                            context: context,
                            title: '',
                            closeIcon: null,
                            content: Column(
                              children: <Widget>[
                                Icon(CupertinoIcons.exclamationmark_triangle,
                                    color: AppColors.PrimaryColor, size: 100.0),
                                SizedBox(height: 20.0),
                                Text("Fill all the field",
                                    style: TextStyle(
                                        fontSize: 20.0))
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
                        return;
                      }

                      if (passwordController.text !=
                          passwordConfirmController.text) {
                        Alert(
                            context: context,
                            title: '',
                            closeIcon: null,
                            content: Column(
                              children: <Widget>[
                                Icon(CupertinoIcons.exclamationmark_triangle,
                                    color: AppColors.PrimaryColor, size: 100.0),
                                SizedBox(height: 20.0),
                                Text("Password doesn't match",
                                    style: TextStyle(
                                        fontSize: 20.0))
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
                        return;
                      }

                      if (passwordController.text !=
                          passwordConfirmController.text) {
                        Alert(
                            context: context,
                            title: '',
                            closeIcon: null,
                            content: Column(
                              children: <Widget>[
                                Icon(CupertinoIcons.exclamationmark_triangle,
                                    color: AppColors.PrimaryColor, size: 100.0),
                                SizedBox(height: 20.0),
                                Text("Email format isn't correct",
                                    style: TextStyle(
                                        fontSize: 20.0))
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
                        return;
                      }

                      await firestore.collection('users').add({
                        'username': usernameController.text,
                        'email': emailController.text,
                        'password': passwordController.text
                      }).then((result) {
                        Navigator.of(context).pushNamed('/signin');
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      width: MediaQuery.of(context).size.width - 40,
                      margin: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            AppColors.PrimaryColor,
                            AppColors.PrimaryColor,
                          ]),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/signin');
                      },
                      child: Text.rich(TextSpan(
                          text: "Already have an account? ",
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Sign In',
                                style:
                                    TextStyle(color: AppColors.PrimaryColor)),
                          ]))),
                  Container(height: 50)
                ],
              ),
            )),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
