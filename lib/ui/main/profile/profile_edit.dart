import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytect/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileEditScreen extends StatefulWidget {
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  TextEditingController captionController = TextEditingController();
  dynamic user;
  dynamic userResult;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  SharedPreferences prefs;
  Size size;

  final picker = ImagePicker();

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> getData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      user = jsonDecode(
          prefs.getString("user") != null ? prefs.getString("user") : '{}');
      usernameController.text = user['username'];
      emailController.text = user['email'];
      passwordController.text = user['password'];
    });
  }

  Future<String> uploadImage(File image, String type, String id) async {
    firebase_storage.UploadTask task;

    task = firebase_storage.FirebaseStorage.instance
        .ref('images/$type/$id/${path.basename(image.path)}')
        .putFile(image);

    task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
      print('Task state: ${snapshot.state}');
      print(
          'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
    }, onError: (e) {
      print(task.snapshot);

      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    });

    try {
      var dowurl = await (await task).ref.getDownloadURL();
      return dowurl.toString();
    } on firebase_core.FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    }
  }

  void changeImageProfile(File file) async {
    EasyLoading.show();
    String imageUrl = await uploadImage(file, 'profile', user['id']);

    firestore
        .collection('users')
        .doc(user['id'])
        .update({'picture': imageUrl}).then((result) {
      dynamic newUser = user;
      newUser['picture'] = imageUrl;
      prefs.setString('user', jsonEncode(newUser));
      EasyLoading.dismiss();
      setState(() {
        user = newUser;
      });
    });
  }

  Future getImagefromGallery() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);
    setState(() {
      if (pickedFile != null) {
        changeImageProfile(File(pickedFile.path));
      } else {
        print('No image selected.');
      }
    });
  }

  void saveProfile() async {
    EasyLoading.show();

    user = {
      'id': user['id'],
      'username': usernameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'picture': user['picture']
    };

    firestore.collection('users').doc(user['id']).update({
      'username': usernameController.text,
      'email': emailController.text,
      'password': passwordController.text
    }).then((result) {
      dynamic newUser = user;
      prefs.setString('user', jsonEncode(newUser));
      EasyLoading.dismiss();
      setState(() {
        user = newUser;
      });
    });

    Navigator.of(context).pop();
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
    return Material(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              child: Column(children: [
                if (user != null)
                  Container(
                    padding: EdgeInsets.only(
                        top: 60, bottom: 40, left: 20, right: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        AppColors.PrimaryColor,
                        AppColors.SecondaryColor
                      ]),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 120,
                              width: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: user['picture'] != null
                                    ? CachedNetworkImage(
                                        imageUrl: user['picture'],
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          )),
                                        ),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl:
                                            'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png',
                                        imageBuilder:
                                            (context, imageProvider) =>
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
                            new Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () => getImagefromGallery(),
                                  child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(40)),
                                      child: Icon(CupertinoIcons.camera)),
                                ))
                          ],
                        )
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
                                          Text('Username'),
                                          TextFormField(
                                            controller: usernameController,
                                          ),
                                          SizedBox(
                                            height: 40,
                                          ),
                                          Text('Email'),
                                          TextFormField(
                                            controller: emailController,
                                          ),
                                          SizedBox(
                                            height: 40,
                                          ),
                                          Text('Password'),
                                          TextFormField(
                                            controller: passwordController,
                                          ),
                                          SizedBox(
                                            height: 40,
                                          ),
                                          GestureDetector(
                                            onTap: () => saveProfile(),
                                            child: Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.0,
                                                  vertical: 10.0),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  40,
                                              margin: EdgeInsets.only(top: 20),
                                              decoration: BoxDecoration(
                                                  gradient:
                                                      LinearGradient(colors: [
                                                    AppColors.PrimaryColor,
                                                    AppColors.PrimaryColor,
                                                  ]),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5))),
                                              child: Text(
                                                'Save',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.0),
                                              ),
                                            ),
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
      ),
    );
  }
}
