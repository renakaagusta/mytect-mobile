import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mytect/constants/assets.dart';
import 'package:mytect/constants/colors.dart';
import 'package:mytect/constants/ssid.dart';
import 'package:mytect/helpers/dio.dart';
import 'package:mytect/services/ssid_services.dart';
import 'package:mytect/utils/timeago/timeago.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SimulationScreen extends StatefulWidget {
  @override
  _SimulationScreenState createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen>
    with TickerProviderStateMixin {
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

  TextEditingController ssid1Conttroller = TextEditingController();
  TextEditingController ssid2Conttroller = TextEditingController();
  TextEditingController ssid3Conttroller = TextEditingController();
  TextEditingController ssid4Conttroller = TextEditingController();
  TextEditingController ssid5Conttroller = TextEditingController();
  TextEditingController ssid6Conttroller = TextEditingController();

  final scrollController = ScrollController();

  List<int> response = [];

  final ssidList = {
    '0': '68:cc:6e:a3:a5:63',
    '1': '68:cc:6e:a3:ae:e0',
    '2': '68:cc:6e:a3:af:42',
    '3': 'a8:bd:27:ff:9e:60',
    '4': '68:cc:6e:a3:aa:c0',
    '5': '68:cc:6e:a3:a8:02',
  };

  final ssidAssetList = {
    '0': Assets.ssid0,
    '1': Assets.ssid1,
    '2': Assets.ssid2,
    '3': Assets.ssid3,
    '4': Assets.ssid4,
    '5': Assets.ssid5,
  };

  int step = 0;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user = jsonDecode(prefs.getString('user'));
    });
  }

  @override
  void initState() {
    super.initState();
    getData();

    /*
    ssid1Conttroller.text = '0';
    ssid2Conttroller.text = '0';
    ssid3Conttroller.text = '0';
    ssid4Conttroller.text = '0';
    ssid5Conttroller.text = '0';
    ssid6Conttroller.text = '0'; */

    ssid1Conttroller.text = '-80';
    ssid2Conttroller.text = '-70';
    ssid3Conttroller.text = '-60';
    ssid4Conttroller.text = '-77';
    ssid5Conttroller.text = '-60';
    ssid6Conttroller.text = '-30';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
            child: (step == 0)
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Simulasi',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22)),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                            'Tekan tombol start untuk mulai melakukan simulasi',
                            style: TextStyle(fontSize: 16)),
                        SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              step = 1;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 15),
                            width: MediaQuery.of(context).size.width * 0.22,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  AppColors.PrimaryColor,
                                  AppColors.PrimaryColor,
                                ]),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Text(
                              'Start',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              step = 3;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 15),
                            width: MediaQuery.of(context).size.width * 0.22,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  AppColors.PrimaryColor,
                                  AppColors.PrimaryColor,
                                ]),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Text(
                              'History',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                        )
                      ],
                    ))
                : (step == 1)
                    ? StreamBuilder<QuerySnapshot>(
                        stream: firestore
                            .collection('data')
                            .where('user', isEqualTo: user['id'].toString())
                            .orderBy('time', descending: true)
                            .limit(1)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.data == null) return Container();

                          dynamic data = snapshot.data.docs[0];
                          List<dynamic> wifiList = data.data()['wifiList'];
                          if (data.data()['wifiList'] != null) {
                            wifiList.forEachIndexed((index, wifi) {
                              ssidList.entries.forEachIndexed((index, ssid) {
                                if (wifi['BSSID'] == ssid.value) {
                                  switch (ssid.key) {
                                    case '0':
                                      ssid1Conttroller.text = wifi['level'];
                                      break;
                                    case '1':
                                      ssid2Conttroller.text = wifi['level'];
                                      break;
                                    case '2':
                                      ssid3Conttroller.text = wifi['level'];
                                      break;
                                    case '3':
                                      ssid4Conttroller.text = wifi['level'];
                                      break;
                                    case '4':
                                      ssid5Conttroller.text = wifi['level'];
                                      break;
                                    case '5':
                                      ssid6Conttroller.text = wifi['level'];
                                      break;
                                  }
                                }
                              });
                            });
                          }

                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text('Input SSID',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22)),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Text('SSID 0',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                SizedBox(
                                  height: 5,
                                ),
                                TextField(
                                  cursorColor: AppColors.PrimaryColor,
                                  controller: ssid1Conttroller,
                                  decoration: InputDecoration(
                                    hintText: 'SSID 0',
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.PrimaryColor),
                                    ),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text('SSID 1',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                SizedBox(
                                  height: 5,
                                ),
                                TextField(
                                  autofocus: true,
                                  cursorColor: AppColors.PrimaryColor,
                                  controller: ssid2Conttroller,
                                  decoration: InputDecoration(
                                    hintText: 'SSID 1',
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.PrimaryColor),
                                    ),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text('SSID 2',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                SizedBox(
                                  height: 5,
                                ),
                                TextField(
                                  autofocus: true,
                                  cursorColor: AppColors.PrimaryColor,
                                  controller: ssid3Conttroller,
                                  decoration: InputDecoration(
                                    hintText: 'SSID 2',
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.PrimaryColor),
                                    ),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text('SSID 3',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                SizedBox(
                                  height: 5,
                                ),
                                TextField(
                                  autofocus: true,
                                  cursorColor: AppColors.PrimaryColor,
                                  controller: ssid4Conttroller,
                                  decoration: InputDecoration(
                                    hintText: 'SSID 3',
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.PrimaryColor),
                                    ),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text('SSID 4',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                SizedBox(
                                  height: 5,
                                ),
                                TextField(
                                  autofocus: true,
                                  cursorColor: AppColors.PrimaryColor,
                                  controller: ssid5Conttroller,
                                  decoration: InputDecoration(
                                    hintText: 'SSID 4',
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.PrimaryColor),
                                    ),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text('SSID 5',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                SizedBox(
                                  height: 5,
                                ),
                                TextField(
                                  autofocus: true,
                                  cursorColor: AppColors.PrimaryColor,
                                  controller: ssid6Conttroller,
                                  decoration: InputDecoration(
                                    hintText: 'SSID 5',
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.PrimaryColor),
                                    ),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () async {
                                      EasyLoading.show();
                                      Dio dio = AppDio.getDio();
                                      final ssidService =
                                          SSIDService(AppDio.getDio());

                                      final body = {
                                        'level_ssid0': int.tryParse(
                                                    ssid1Conttroller.text) !=
                                                null
                                            ? int.parse(ssid1Conttroller.text)
                                            : 0,
                                        'level_ssid1': int.tryParse(
                                                    ssid2Conttroller.text) !=
                                                null
                                            ? int.parse(ssid2Conttroller.text)
                                            : 0,
                                        'level_ssid2': int.tryParse(
                                                    ssid3Conttroller.text) !=
                                                null
                                            ? int.parse(ssid3Conttroller.text)
                                            : 0,
                                        'level_ssid3': int.tryParse(
                                                    ssid4Conttroller.text) !=
                                                null
                                            ? int.parse(ssid4Conttroller.text)
                                            : 0,
                                        'level_ssid4': int.tryParse(
                                                    ssid5Conttroller.text) !=
                                                null
                                            ? int.parse(ssid5Conttroller.text)
                                            : 0,
                                        'level_ssid5': int.tryParse(
                                                    ssid6Conttroller.text) !=
                                                null
                                            ? int.parse(ssid6Conttroller.text)
                                            : 0,
                                      };

                                      Map<String, dynamic> result = jsonDecode(
                                          await ssidService.submitData(body));

                                      List<int> ssidPredicted = [];

                                      result.entries
                                          .forEachIndexed((index, ssid) {
                                        if (ssid.value as int == 0) {
                                          ssidPredicted.add(index);
                                        }
                                      });

                                      setState(() {
                                        response = ssidPredicted;
                                        step = 2;
                                      });

                                      List<String> locationPredicted = [];
                                      response
                                          .forEachIndexed(((index, element) {
                                        locationPredicted.add(ssidPlaceName[
                                            response[index].toString()]);
                                      }));

                                      await firestore
                                          .collection('predictionResult')
                                          .add({
                                        'place': locationPredicted,
                                        'user': user['id'],
                                        'created': FieldValue.serverTimestamp()
                                      }).then((result) {
                                        EasyLoading.dismiss();
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 15),
                                      width: MediaQuery.of(context).size.width *
                                          0.22,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                            AppColors.PrimaryColor,
                                            AppColors.PrimaryColor,
                                          ]),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Text(
                                        'Submit',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 100,
                                )
                              ],
                            ),
                          );
                        })
                    : (step == 2)
                        ? Container(
                            height: MediaQuery.of(context).size.height,
                            child: ListView.builder(
                                itemCount: response.length + 2,
                                itemBuilder: (context, index) {
                                  return index == 0
                                      ? Container(
                                          child: Column(
                                            children: [
                                              Text('Hasil Klusterisasi: ',
                                                  style:
                                                      TextStyle(fontSize: 20, color: Colors.white)),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  'Berdasarkan kuat sinyal terbesar dari cluster dengan ssid terdekat yaitu ssid ${response[0]}',
                                                  style:
                                                      TextStyle(fontSize: 20, color: Colors.white)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                          margin: EdgeInsets.only(bottom: 50),
                                        )
                                      : index == 1
                                          ? Column(children: [
                                              Container(
                                                child: Column(
                                                  children: [
                                                    Text('Hasil Klusterisasi: ',
                                                        style: TextStyle(
                                                            fontSize: 20, fontWeight: FontWeight.bold)),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                        'Berdasarkan kuat sinyal terbesar dari cluster dengan ssid terdekat yaitu ssid ${response[0]}',
                                                        style: TextStyle(
                                                            fontSize: 20)),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                                margin:
                                                    EdgeInsets.only(bottom: 50),
                                              ),
                                              Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 30),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              Colors.black26)),
                                                  child: Column(
                                                    children: [
                                                     Image.asset(ssidAssetList[
                                                          response[index - 1]
                                                              .toString()]),
                                                      SizedBox(height: 10),
                                                      Text(
                                                          ssidPlaceName[
                                                              response[
                                                                      index - 1]
                                                                  .toString()],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20)),
                                                      SizedBox(height: 10),
                                                    ],
                                                  ))
                                            ])
                                          : (response.length > index - 1) ? Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 30),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black26)),
                                              child: Column(
                                                children: [
                                                  Image.asset(ssidAssetList[
                                                      response[index - 1]
                                                          .toString()]),
                                                  SizedBox(height: 10),
                                                  Text(
                                                      ssidPlaceName[
                                                          response[index - 1]
                                                              .toString()],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20)),
                                                  SizedBox(height: 10),
                                                ],
                                              )):Container();
                                }))
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: user != null
                                ? StreamBuilder<QuerySnapshot>(
                                    stream: firestore
                                        .collection('predictionResult')
                                        .where('user', isEqualTo: user['id'])
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (!snapshot.hasData) {
                                        return Center(
                                            child: CircularProgressIndicator(
                                          color: AppColors.PrimaryColor,
                                        ));
                                      }

                                      List<dynamic> docs = snapshot.data.docs;

                                      if(docs.isEmpty) {
                                        return Center(child:Text('Data not found'));
                                      }

                                      return snapshot.data.docs.isNotEmpty
                                          ? ListView.builder(
                                              controller: scrollController,
                                              itemCount: docs.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return GestureDetector(
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey[200],
                                                                width: 1)),
                                                        margin: EdgeInsets.only(
                                                            bottom: 10),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 15,
                                                                right: 15,
                                                                top: 15,
                                                                bottom: 15),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width -
                                                                      80,
                                                                  child: Text(
                                                                      docs[index]
                                                                          .data()[
                                                                              'place']
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              16)),
                                                                ),
                                                                SizedBox(
                                                                    height: 5),
                                                                Text(
                                                                    TimeAgo.timeAgoSinceDate(docs[index]
                                                                            [
                                                                            'created']
                                                                        .toDate()
                                                                        .toString()),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .grey))
                                                              ],
                                                            )
                                                          ],
                                                        )),
                                                    onTap: () {
                                                      /*Navigator.of(context)
                                                          .pushNamed('/data',
                                                              arguments: {
                                                            'dataId':
                                                                docs[index].id,
                                                          });*/
                                                    });
                                              })
                                          : Container(
                                              width: size.width - 40,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                      CupertinoIcons
                                                          .info_circle,
                                                      size: 40),
                                                  SizedBox(height: 30),
                                                  Text('History not found')
                                                ],
                                              ),
                                            );
                                    })
                                : Center(
                                    child: CircularProgressIndicator(
                                    color: AppColors.PrimaryColor,
                                  )))));
  }
}
