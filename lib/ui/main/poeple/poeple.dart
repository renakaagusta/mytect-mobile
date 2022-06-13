import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytect/constants/assets.dart';
import 'package:mytect/constants/colors.dart';
import 'package:mytect/ui/main/poeple/poeple_location.dart';
import 'package:mytect/utils/timeago/timeago.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PeopleScreen extends StatefulWidget {
  @override
  _PeopleScreenState createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen>
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
            child: StreamBuilder<QuerySnapshot>(
                stream: firestore.collection('users').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: AppColors.PrimaryColor,
                    ));
                  }

                  List<dynamic> users = snapshot.data.docs;

                  return StreamBuilder<QuerySnapshot>(
                      stream:
                          firestore.collection('predictionResult').orderBy('created', descending: true).snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                              child: CircularProgressIndicator(
                            color: AppColors.PrimaryColor,
                          ));
                        }

                        List<dynamic> docs = snapshot.data.docs;

                        return snapshot.data.docs.isNotEmpty
                            ? Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                  controller: scrollController,
                                  itemCount: docs.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    dynamic foundUser;
                                    
                                    users.forEach((user){
                                      if(user.id.toString() == docs[index].data()['user']) foundUser = user;
                                    });
                                    return GestureDetector(
                                      onTap:()=>Navigator.of(context).pushNamed('/poeple/location', arguments: PeopleLocationArguments(foundUser, docs[index].data()),),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.grey[200],
                                                    width: 1)),
                                            margin: EdgeInsets.only(bottom: 10),
                                            padding: EdgeInsets.only(
                                                left: 15,
                                                right: 15,
                                                top: 15,
                                                bottom: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              80,
                                                      child: Text(
                                                          docs[index]
                                                              .data()['place']
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              fontSize: 16)),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(foundUser['username'],),
                                                    SizedBox(height: 5),
                                                    Text(
                                                        TimeAgo.timeAgoSinceDate(
                                                            docs[index]['created']
                                                                .toDate()
                                                                .toString()),
                                                        style: TextStyle(
                                                            color: Colors.grey))
                                                  ],
                                                )
                                              ],
                                            )),
                                       );
                                  }),
                            )
                            : Container(
                                width: size.width - 40,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(CupertinoIcons.info_circle, size: 40),
                                    SizedBox(height: 30),
                                    Text('People history not found')
                                  ],
                                ),
                              );
                      });
                })));
  }
}
