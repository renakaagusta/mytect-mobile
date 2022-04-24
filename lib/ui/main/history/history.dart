import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mytect/utils/timeago/timeago.dart';
import 'package:mytect/constants/assets.dart';
import 'package:mytect/constants/colors.dart';
import 'package:mytect/constants/strings.dart';

class HistoryScreen extends StatefulWidget {
  final String username;

  const HistoryScreen({
    Key key,
    this.username,
  }) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  TextEditingController chatController = new TextEditingController();
  var childList = <Widget>[];
  dynamic user;
  dynamic userOther;
  dynamic chatroomList;
  List<dynamic> users = [];
  Size size;
  SharedPreferences prefs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool updated = false;

  Future<dynamic> getUserData(String id) async {
    return firestore.collection('users').doc(id).get();
  }

  Future<dynamic> getUserListData(List<dynamic> chatroomList) async {
    List<dynamic> userListQuery = await Future.wait(chatroomList.map(
        (chatroom) async => await getUserData(chatroom['members']
            .where((member) => member != user['id'])
            .toList()[0])));
    setState(() {
      users = userListQuery;
    });
  }

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) getData();
    final scrollController = ScrollController();
    size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.only(left: 30, right: 20, top: 20, bottom: 20),
            child: Stack(
              fit: StackFit.loose,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Flexible(
                        fit: FlexFit.tight,
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('History',
                                      style: TextStyle(fontSize: 24)),
                                  SizedBox(height: 30),
                                  Container(
                                    height: 1,
                                    width: 200,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 30),
                                  Expanded(
                                      child: (user != null)
                                          ? StreamBuilder<QuerySnapshot>(
                                              stream: firestore
                                                  .collection('dataByLocation')
                                                  .where('user',
                                                      isEqualTo: user['id'])
                                                  .orderBy('created', descending: true)
                                                  .snapshots(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                    color:
                                                        AppColors.PrimaryColor,
                                                  ));
                                                }

                                                List<dynamic> docs =
                                                    snapshot.data.docs;

                                                return snapshot
                                                        .data.docs.isNotEmpty
                                                    ? ListView.builder(
                                                        controller:
                                                            scrollController,
                                                        itemCount: docs.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return GestureDetector(
                                                              child: Container(
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      border: Border.all(
                                                                          color: Colors.grey[
                                                                              200],
                                                                          width:
                                                                              1)),
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              10),
                                                                  padding: EdgeInsets.only(
                                                                      left: 15,
                                                                      right: 15,
                                                                      top: 15,
                                                                      bottom:
                                                                          15),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                              docs[index].data()['place'],
                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                                                          if(docs[index].data()['floor']!=null)Text(
                                                                              'Lantai ' + docs[index].data()['floor'],
                                                                              style: TextStyle(fontSize: 14)),
                                                                          SizedBox(
                                                                              height: 5),
                                                                          Text(
                                                                              TimeAgo.timeAgoSinceDate(docs[index]['created'].toDate().toString()),
                                                                              style: TextStyle(color: Colors.grey))
                                                                        ],
                                                                      )
                                                                    ],
                                                                  )),
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pushNamed(
                                                                        '/data',
                                                                        arguments: {
                                                                      'dataId':
                                                                          docs[index]
                                                                              .id,
                                                                    });
                                                              });
                                                        })
                                                    : Container(
                                                        width: size.width - 40,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                                CupertinoIcons
                                                                    .info_circle,
                                                                size: 40),
                                                            SizedBox(
                                                                height: 30),
                                                            Text(
                                                                'History not found')
                                                          ],
                                                        ),
                                                      );
                                              })
                                          : Center(
                                              child: CircularProgressIndicator(
                                              color: AppColors.PrimaryColor,
                                            )))
                                ]))),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
