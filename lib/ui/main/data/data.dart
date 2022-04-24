import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:mytect/utils/map/icon_map.dart';
import 'package:intl/intl.dart';
import 'package:mytect/utils/date.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:mytect/constants/assets.dart';
import 'package:mytect/constants/colors.dart';
import 'package:mytect/constants/strings.dart';

class DataScreen extends StatefulWidget {
  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> with TickerProviderStateMixin {
  List<dynamic> _posts = [];
  List<dynamic> posts = [];
  List<dynamic> filteredPosts = [];
  List<dynamic> users = [];
  List<dynamic> likes = [];
  int wifiIndex = 0;
  int status = 0;
  TextEditingController placeController = TextEditingController();
  FocusNode placeFocusNode;
  dynamic user;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Size size;
  bool loading = true;
  dynamic doc;
  dynamic dataByLocation;
  dynamic data;

  Future<dynamic> getUserData(String id) async {
    return firestore.collection('users').doc(id).get();
  }

  Future<dynamic> getLikesData(String id) async {
    return firestore.collection('posts').doc(id).collection('likes').get();
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    setState(() {
      user = jsonDecode(prefs.getString('user'));

      firestore
          .collection('dataByLocation')
          .doc(arguments['dataId'])
          .get()
          .then((document) {
        setState(() {
          dataByLocation = document;
          firestore
              .collection('data')
              .doc(dataByLocation.data()['data'])
              .get()
              .then((document) {
            setState(() {
              data = document;
            });
          });
        });
      });
    });
  }

  double calculateDistance(double signalLevelInDb, double freqInMHz) {
    double exp =
        (27.55 - (20 * log(freqInMHz) / ln10) + signalLevelInDb.abs()) / 20.0;
    print(exp.toString() +
        " " +
        signalLevelInDb.toString() +
        " " +
        freqInMHz.toString());
    return pow(10.0, exp);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(children: [
              Positioned(
                left: 0,
                right: 0,
                child: SingleChildScrollView(
                  child: (data != null)
                      ? Container(
                          child: Column(
                          children: [
                            Container(
                                height: size.height * 0.45,
                                width: size.width,
                                padding: EdgeInsets.only(
                                    top: 40, bottom: 20, left: 20, right: 20),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                  AppColors.PrimaryColor,
                                  AppColors.SecondaryColor
                                ])),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                            child: Container(
                                                height: 50,
                                                width: 50,
                                                child: Icon(
                                                    CupertinoIcons.back,
                                                    color: Colors.white, size: 40)),
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            }),
                                        Text(dataByLocation.data()['place'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold)),
                                        dataByLocation.data()['floor']!=null? Text('Lantai '+dataByLocation.data()['floor'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,)):
                                        Container(height: 50, width: 50)
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        wifiIndex != 0
                                            ? GestureDetector(
                                                child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    child: Icon(
                                                        CupertinoIcons
                                                            .chevron_back,
                                                        color: Colors.white)),
                                                onTap: () {
                                                  setState(() {
                                                    wifiIndex = wifiIndex - 1;
                                                  });
                                                })
                                            : Container(
                                                height: 50,
                                                width: 50,
                                              ),
                                        Column(
                                          children: [
                                            Text(
                                                data.data()['wifiList']
                                                        [wifiIndex]['level'] +
                                                    " Dbm",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 28)),
                                          ],
                                        ),
                                        wifiIndex <
                                                data.data()['wifiList'].length -
                                                    1
                                            ? GestureDetector(
                                                child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    child: Icon(
                                                        CupertinoIcons
                                                            .chevron_forward,
                                                        color: Colors.white)),
                                                onTap: () {
                                                  setState(() {
                                                    wifiIndex = wifiIndex + 1;
                                                  });
                                                })
                                            : Container(
                                                height: 50,
                                                width: 50,
                                              ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(CupertinoIcons.wifi,
                                                color: Colors.white, size: 30),
                                            SizedBox(width: 15),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    data.data()['wifiList']
                                                        [wifiIndex]['SDDI'],
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                SizedBox(height: 5),
                                                Text(
                                                    data.data()['wifiList']
                                                        [wifiIndex]['BSSID'],
                                                    style: TextStyle(
                                                        color: Colors.white))
                                              ],
                                            )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(data.data()['subLocality'],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(height: 5),
                                            Text(data.data()['locality'],
                                                style: TextStyle(
                                                    color: Colors.white))
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                )),
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                      padding: EdgeInsets.only(
                                          top: 20,
                                          bottom: 18,
                                          left: 20,
                                          right: 20),
                                      child: Row(
                                        children: [
                                          Icon(CupertinoIcons.waveform,
                                              size: 30, color: Colors.grey),
                                          SizedBox(width: 20),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Frequency",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(height: 5),
                                              Text(
                                                  data.data()['wifiList']
                                                                  [wifiIndex]
                                                              ['Frequency'] !=
                                                          null
                                                      ? data.data()['wifiList']
                                                                  [wifiIndex]
                                                              ['Frequency'] +
                                                          ' MHZ'
                                                      : '-',
                                                  style: TextStyle(
                                                      color: Colors.black87)),
                                            ],
                                          )
                                        ],
                                      )),
                                  Container(
                                      padding: EdgeInsets.only(
                                          top: 15,
                                          bottom: 18,
                                          left: 20,
                                          right: 20),
                                      child: Row(
                                        children: [
                                          Icon(CupertinoIcons.location_solid,
                                              size: 30, color: Colors.grey),
                                          SizedBox(width: 20),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Distance",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(height: 5),
                                              Text(
                                                  calculateDistance(
                                                              int.parse(data.data()[
                                                                              'wifiList']
                                                                          [wifiIndex]
                                                                      ['level'])
                                                                  .abs()
                                                                  .toDouble(),
                                                              int.parse(data.data()[
                                                                              'wifiList']
                                                                          [wifiIndex]
                                                                      [
                                                                      'Frequency'])
                                                                  .toDouble())
                                                          .toString()
                                                          .substring(0, 4) +
                                                      " m",
                                                  style: TextStyle(
                                                      color: Colors.black87))
                                            ],
                                          )
                                        ],
                                      )),
                                  Container(
                                      padding: EdgeInsets.only(
                                          top: 15,
                                          bottom: 18,
                                          left: 20,
                                          right: 20),
                                      child: Row(
                                        children: [
                                          Icon(CupertinoIcons.lock,
                                              size: 30, color: Colors.grey),
                                          SizedBox(width: 20),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Capabilities",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(height: 5),
                                              Text(
                                                  data.data()['wifiList']
                                                          [wifiIndex]
                                                      ['Capabilities'],
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 12))
                                            ],
                                          )
                                        ],
                                      )),
                                  Container(
                                      padding: EdgeInsets.only(
                                          top: 15,
                                          bottom: 18,
                                          left: 20,
                                          right: 20),
                                      child: Row(
                                        children: [
                                          Icon(CupertinoIcons.time,
                                              size: 30, color: Colors.grey),
                                          SizedBox(width: 20),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Updated at",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(height: 5),
                                              Text(
                                                  DateTime.fromMillisecondsSinceEpoch(
                                                          data
                                                                  .data()[
                                                                      'updatedAt']
                                                                  .seconds *
                                                              1000)
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black87))
                                            ],
                                          )
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ))
                      : Container(),
                ),
              ),
            ])));
  }
}
