import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mytect/constants/assets.dart';
import 'package:mytect/constants/colors.dart';
import 'package:mytect/constants/strings.dart';
import 'package:mytect/utils/timeago/timeago.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<dynamic> users = [];
  int wifiIndex = 0;
  int status = 0;
  TextEditingController placeController = TextEditingController();
  FocusNode placeFocusNode;
  dynamic user;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Size size;
  bool loading = true;
  dynamic doc;

  List<String> floor = ["1", "2", "3", "4"];
  List<String> floor1 = [
    "J.Co",
    "Chatime",
    "CFC",
    "Stan Kosong 1",
    "Solaria",
    "Tong Tji",
    "Yoshinoya",
    "Imperial",
    "Optik melawai",
    "ATM",
    "Toilet",
    "Lift",
    "Daun Lada",
    "Kimchi Go",
    "Gokana",
    "Stan Kosong 2",
    "Bank Mega",
    "Baskin Robbin",
    "The Coffe Bean",
    "Chi fry",
    "Kokumi",
    "Kopi kenangan",
    "Puya",
    "Laksana",
    "Showroom mobil",
    "Wendy's",
    "Honeypok",
    "Suteku",
    "Bazio",
    "Cincau Station",
    "Stan kosong 3",
    "Taiwan Street Food",
    "Fruits",
    "Air Mata Kucing",
    "Barang sale"
  ];
  List<String> floor2 = [
    "Koper",
    "Baju pria",
    "Bahan makanan",
    "Kosmetik",
    "CS depan",
    "CS belakang",
    "Acc elektronik",
    "Elekronik",
    "Sepatu",
    "Baju sale",
    "Mainan anak",
    "Baju wanita",
    "Kacamata"
  ];
  List<String> floor3 = [
    "Bahan masak",
    "Pembersih rumah",
    "Alat pembersih",
    "Box",
    "Bahan masak",
    "Rak barang sale",
    "Transliving",
    "Alat tulis",
    "Sabun dan skincare",
    "Peralatan dapur",
    "Sport",
    "Perkakas"
  ];
  List<String> floor4 = [
    "Bioskop",
    "Foodcourt",
    "Arena bermain 1",
    "Arena bermain 2",
    "Arena bermain 3",
    "Arena bermain 4",
    "Foodcourt 1",
    "Foodcourt 2",
    "Musholla & Toilet",
    "Lift"
  ];

  String floorValue;
  String placeValue;

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user = jsonDecode(prefs.getString('user'));
    });
  }

  double calculateDistance(double signalLevelInDb, double freqInMHz) {
    double exp =
        (27.55 - (20 * log(freqInMHz) / ln10) + signalLevelInDb.abs()) / 20.0;
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
    floorValue = floor[0];
    placeValue = floor1[0];
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
            child: Container(
                height: size.height,
                width: size.width,
                child: Stack(children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    child: SingleChildScrollView(
                      child: (user != null)
                          ? Container(
                              width: size.width,
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: firestore
                                      .collection('data')
                                      .where('user',
                                          isEqualTo: user['id'].toString())
                                      .orderBy('time', descending: true)
                                      .limit(1)
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.data == null)
                                      return Container();

                                    if (snapshot.data.docs.length == 0) {
                                      return Center(
                                          child: CircularProgressIndicator(
                                        color: AppColors.PrimaryColor,
                                      ));
                                    }

                                    dynamic data = snapshot.data.docs[0];

                                    if (snapshot.data.docs.isEmpty) {
                                      return Center(
                                          child: Text("Data not found"));
                                    }

                                    return SingleChildScrollView(
                                      child: Container(
                                          child: Column(
                                        children: [
                                          Container(
                                              height: size.height * 0.45,
                                              width: size.width,
                                              padding: EdgeInsets.only(
                                                  top: 40,
                                                  bottom: 20,
                                                  left: 20,
                                                  right: 20),
                                              decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      colors: [
                                                    AppColors.PrimaryColor,
                                                    AppColors.SecondaryColor
                                                  ])),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                              Assets
                                                                  .appLogoWhite,
                                                              height: 40.0,
                                                              width: 25.0),
                                                          SizedBox(width: 15),
                                                          Text(Strings.appName,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 24,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      wifiIndex != 0
                                                          ? GestureDetector(
                                                              child: Container(
                                                                  height: 50,
                                                                  width: 50,
                                                                  child: Icon(
                                                                      CupertinoIcons
                                                                          .chevron_back,
                                                                      color: Colors
                                                                          .white)),
                                                              onTap: () {
                                                                setState(() {
                                                                  wifiIndex =
                                                                      wifiIndex -
                                                                          1;
                                                                });
                                                              })
                                                          : Container(
                                                              height: 50,
                                                              width: 50,
                                                            ),
                                                      if (data
                                                          .data()['wifiList']
                                                          .isNotEmpty)
                                                        Column(
                                                          children: [
                                                            Text(
                                                                data.data()['wifiList']
                                                                            [
                                                                            wifiIndex]
                                                                        [
                                                                        'level'] +
                                                                    " Dbm",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        28)),
                                                          ],
                                                        ),
                                                      wifiIndex <
                                                              data
                                                                      .data()[
                                                                          'wifiList']
                                                                      .length -
                                                                  1
                                                          ? GestureDetector(
                                                              child: Container(
                                                                  height: 50,
                                                                  width: 50,
                                                                  child: Icon(
                                                                      CupertinoIcons
                                                                          .chevron_forward,
                                                                      color: Colors
                                                                          .white)),
                                                              onTap: () {
                                                                setState(() {
                                                                  wifiIndex =
                                                                      wifiIndex +
                                                                          1;
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
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(
                                                              CupertinoIcons
                                                                  .wifi,
                                                              color:
                                                                  Colors.white,
                                                              size: 30),
                                                          SizedBox(width: 15),
                                                          if (data
                                                              .data()[
                                                                  'wifiList']
                                                              .isNotEmpty)
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    data.data()['wifiList']
                                                                            [
                                                                            wifiIndex]
                                                                        [
                                                                        'SDDI'],
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                SizedBox(
                                                                    height: 5),
                                                                Text(
                                                                    data.data()['wifiList']
                                                                            [
                                                                            wifiIndex]
                                                                        [
                                                                        'BSSID'],
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white))
                                                              ],
                                                            )
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                              data.data()[
                                                                      'subLocality'] ??
                                                                  '-',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          SizedBox(height: 5),
                                                          Text(
                                                              data.data()[
                                                                      'locality'] ??
                                                                  '-',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white))
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
                                                      top: 30,
                                                      left: 20,
                                                      right: 20),
                                                  width: size.width - 20,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                top: 15,
                                                                bottom: 18,
                                                              ),
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                          .grey[
                                                                      100],
                                                                ),
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                width:
                                                                    size.width -
                                                                        60,
                                                                child:
                                                                    TextField(
                                                                  controller:
                                                                      placeController,
                                                                  focusNode:
                                                                      placeFocusNode,
                                                                  textCapitalization:
                                                                      TextCapitalization
                                                                          .sentences,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13),
                                                                  decoration:
                                                                      InputDecoration(
                                                                    hintText:
                                                                        "Lokasi",
                                                                    contentPadding: EdgeInsets.only(
                                                                        top: 0,
                                                                        bottom:
                                                                            0,
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                    focusedBorder: OutlineInputBorder(
                                                                        borderSide: const BorderSide(
                                                                            color: AppColors
                                                                                .PrimaryColor,
                                                                            width:
                                                                                1.0),
                                                                        borderRadius:
                                                                            BorderRadius.circular(3)),
                                                                    border: OutlineInputBorder(
                                                                        borderSide: const BorderSide(
                                                                            color: Colors
                                                                                .white70,
                                                                            width:
                                                                                1.0),
                                                                        borderRadius:
                                                                            BorderRadius.circular(3)),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ]),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          EasyLoading.show();
                                                          if (placeController
                                                              .text.isEmpty) {
                                                            EasyLoading
                                                                .dismiss();
                                                            Alert(
                                                                context:
                                                                    context,
                                                                title: '',
                                                                closeIcon: null,
                                                                content: Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Icon(
                                                                        CupertinoIcons
                                                                            .exclamationmark_triangle,
                                                                        color: AppColors
                                                                            .PrimaryColor,
                                                                        size:
                                                                            100.0),
                                                                    SizedBox(
                                                                        height:
                                                                            20.0),
                                                                    Text(
                                                                        "Please input location",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20.0))
                                                                  ],
                                                                ),
                                                                buttons: [
                                                                  DialogButton(
                                                                    color: AppColors
                                                                        .PrimaryColor,
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context,
                                                                              rootNavigator: true)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                      "OK",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                  )
                                                                ]).show();
                                                            return;
                                                          }

                                                          await firestore
                                                              .collection(
                                                                  'dataByLocation')
                                                              .add({
                                                            'place':
                                                                placeController
                                                                    .text,
                                                            'data': data.id,
                                                            'user': user['id'],
                                                            'created': FieldValue
                                                                .serverTimestamp()
                                                          }).then((result) {
                                                            EasyLoading
                                                                .dismiss();
                                                            SweetAlert.show(
                                                                context,
                                                                subtitle:
                                                                    "Data sent successfully",
                                                                style:
                                                                    SweetAlertStyle
                                                                        .success);
                                                          });
                                                        },
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10.0,
                                                                  vertical: 15),
                                                          width:
                                                              size.width * 0.22,
                                                          decoration:
                                                              BoxDecoration(
                                                                  gradient:
                                                                      LinearGradient(
                                                                          colors: [
                                                                        AppColors
                                                                            .PrimaryColor,
                                                                        AppColors
                                                                            .PrimaryColor,
                                                                      ]),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5))),
                                                          child: Text(
                                                            'Input',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Column(children: [
                                                  Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: 18,
                                                          left: 20,
                                                          right: 20,
                                                          top: 20),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                              CupertinoIcons
                                                                  .waveform,
                                                              size: 30,
                                                              color:
                                                                  Colors.grey),
                                                          SizedBox(width: 20),
                                                          if (data
                                                              .data()[
                                                                  'wifiList']
                                                              .isNotEmpty)
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    "Frequency",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                SizedBox(
                                                                    height: 5),
                                                                Text(
                                                                    data.data()['wifiList'][wifiIndex]['Frequency'] !=
                                                                            null
                                                                        ? data.data()['wifiList'][wifiIndex]['Frequency'] +
                                                                            ' MHZ'
                                                                        : '-',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black87)),
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
                                                          Icon(
                                                              CupertinoIcons
                                                                  .add,
                                                              size: 30,
                                                              color:
                                                                  Colors.grey),
                                                          SizedBox(width: 20),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  "Capabilities",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              SizedBox(
                                                                  height: 5),
                                                              Text(
                                                                  data.data()['wifiList'][wifiIndex]
                                                                              [
                                                                              'Capabilities'] !=
                                                                          null
                                                                      ? data.data()['wifiList'][wifiIndex]
                                                                              [
                                                                              'Capabilities'] +
                                                                          ' MHZ'
                                                                      : '-',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black87))
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
                                                          Icon(
                                                              CupertinoIcons
                                                                  .time,
                                                              size: 30,
                                                              color:
                                                                  Colors.grey),
                                                          SizedBox(width: 20),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text("Updated at",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              SizedBox(
                                                                  height: 5),
                                                              Text(
                                                                  data
                                                                      .data()[
                                                                          'updatedAt']
                                                                      .toDate()
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black87))
                                                            ],
                                                          )
                                                        ],
                                                      )),
                                                  SizedBox(height: 20),
                                                ]),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                    );
                                  }))
                          : Container(),
                    ),
                  ),
                ]))));
  }
}
