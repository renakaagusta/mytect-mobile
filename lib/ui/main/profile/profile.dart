import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:mytect/constants/colors.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController captionController = TextEditingController();
  dynamic user;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  SharedPreferences prefs;
  Size size;
  
  Future<void> getData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      user = jsonDecode(
          prefs.getString("user") != null ? prefs.getString("user") : '{}');
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            child: Column(children: [
              if (user != null)
                Container(
                  padding:
                      EdgeInsets.only(top: 60, bottom: 40, left: 20, right: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      AppColors.PrimaryColor,
                      AppColors.SecondaryColor
                    ]),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: user['picture'] != null ? CachedNetworkImage(
                                imageUrl:
                                    user['picture'],
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  )),
                                ),
                              ): CachedNetworkImage(
                                imageUrl:
                                    'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png',
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  )),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user['username']!=null ? user['username'] : '',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              SizedBox(height: 10),
                              
                              Text(user['email'] != null ? user['email'] : '',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white)),
                            ],
                          ),
                        ],
                      ),
                      Icon(CupertinoIcons.pencil, color: Colors.white, size: 30)
                    ],
                  ),
                ),
              Container(
                  decoration: BoxDecoration(color: Colors.white),
                  padding: EdgeInsets.only(
                      left: 25, right: 25, top: 10.0, bottom: 20),
                  child: user != null
                      ? user['username'] != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(top: 20.0),
                                    color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        
                                        
                                        Text(
                                          'Aplikasi',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 20.0),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .pushNamed('/profile/privacy');
                                          },
                                          child: Row(
                                            children: [
                                              Container(
                                                child: Icon(
                                                    CupertinoIcons.shield,
                                                    size: 30),
                                              ),
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                              Text('Kebijakan dan Privasi',
                                                  style:
                                                      TextStyle(fontSize: 18.0))
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 20.0),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .pushNamed('/profile/version');
                                          },
                                          child: Row(
                                            children: [
                                              Container(
                                                child: Icon(
                                                    CupertinoIcons.info_circle,
                                                    size: 30),
                                              ),
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                              Text('Versi',
                                                  style:
                                                      TextStyle(fontSize: 18.0))
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 30.0),
                                        Text(
                                          'Navigasi',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 20.0),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                Navigator.of(context)
                                                    .pushNamedAndRemoveUntil(
                                                        '/signin',
                                                        (Route<dynamic>
                                                                route) =>
                                                            false);
                                                await GoogleSignIn().signOut();
                                                prefs.clear();
                                              },
                                              child: Container(
                                                child: Icon(
                                                    CupertinoIcons.arrow_left),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20.0,
                                            ),
                                            Text('Sign out',
                                                style:
                                                    TextStyle(fontSize: 18.0))
                                          ],
                                        ),
                                      ],
                                    )),
                              ],
                            )
                          : Container()
                      : Center(
                          child: CircularProgressIndicator(
                            color: AppColors.PrimaryColor,
                          ),
                        )),
            ]),
          ),
        ),
      ],
    );
  }
}
