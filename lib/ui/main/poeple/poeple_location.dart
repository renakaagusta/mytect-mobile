import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytect/constants/assets.dart';
import 'package:mytect/constants/ssid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PoepleLocationArguments {
  final dynamic user;
  final dynamic predictionResult;

  PoepleLocationArguments(this.user, this.predictionResult);
}

class PoepleLocationScreen extends StatefulWidget {
  @override
  _PoepleLocationScreenState createState() => _PoepleLocationScreenState();
}

class _PoepleLocationScreenState extends State<PoepleLocationScreen>
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

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as PoepleLocationArguments;
    final predictionResult = arguments.predictionResult;
    final user = arguments.user;
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: SingleChildScrollView(
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                      itemCount: predictionResult['place'].length + 1,
                      itemBuilder: (context, index) {
                        int placeIndex = 0;
                        if (index > 0) {
                          ssidPlaceName.entries
                              .forEachIndexed((ssidIndex, ssidName) {
                            if (ssidName.value ==
                                predictionResult['place'][index - 1]) {
                              placeIndex = ssidIndex;
                            }
                          });
                        }
                        return index == 0
                            ? Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Pengguna',
                                        style: TextStyle(fontSize: 20)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(user['username'],
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      height: 20,
                                    ),Text('Lokasi',
                                        style: TextStyle(fontSize: 20)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ))
                            : Container(
                                margin: EdgeInsets.only(bottom: 30),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black26)),
                                child: Column(
                                  children: [
                                    Image.asset(
                                        ssidAssetList[placeIndex.toString()]),
                                    SizedBox(height: 10),
                                    Text(predictionResult['place'][index - 1],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                    SizedBox(height: 10),
                                  ],
                                ));
                      })))),
    );
  }
}
