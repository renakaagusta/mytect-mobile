import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytect/constants/assets.dart';
import 'package:mytect/constants/colors.dart';
import 'package:mytect/constants/ssid.dart';
import 'package:mytect/helpers/dio.dart';
import 'package:mytect/services/ssid_services.dart';
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

    /*ssid1Conttroller.text = '-80';
    ssid2Conttroller.text = '-70';
    ssid3Conttroller.text = '-60';
    ssid4Conttroller.text = '-77';
    ssid5Conttroller.text = '-60';
    ssid6Conttroller.text = '-30';*/

    ssid1Conttroller.text = '0';
    ssid2Conttroller.text = '0';
    ssid3Conttroller.text = '0';
    ssid4Conttroller.text = '0';
    ssid5Conttroller.text = '0';
    ssid6Conttroller.text = '0';
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
                        Text('Tekan tombol mulai untuk melakukan simulasi',
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
                              'Input',
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

                          return Container(
                              height: MediaQuery.of(context).size.height,
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
                                  Text('SSID 1',
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
                                    controller: ssid2Conttroller,
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
                                    controller: ssid3Conttroller,
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
                                    controller: ssid4Conttroller,
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
                                    controller: ssid5Conttroller,
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
                                    height: 30,
                                  ),
                                  Text('SSID 6',
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
                                      hintText: 'SSID 6',
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

                                        Map<String, dynamic> result =
                                            jsonDecode(await ssidService
                                                .submitData(body));

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
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 15),
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                  )
                                ],
                              ));
                        })
                    : Container(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                            itemCount: response.length + 2,
                            itemBuilder: (context, index) {
                              return index == 0
                                  ? Container(
                                      child: Column(
                                        children: [
                                          Text('Hasil Klusterisasi',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20)),
                                          SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ),
                                      margin: EdgeInsets.only(bottom: 50),
                                    )
                                  : index == response.length + 1
                                      ? Container()
                                      : Container(
                                          margin: EdgeInsets.only(bottom: 30),
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
                                          ));
                            }))));
  }
}