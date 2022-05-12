import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:get_mac/get_mac.dart';
import 'package:location/location.dart';
import 'package:mytect/constants/colors.dart';
import 'package:mytect/ui/main/history/history.dart';
import 'package:mytect/ui/main/home/home.dart';
import 'package:mytect/ui/main/poeple/poeple.dart';
import 'package:mytect/ui/main/prediction/simulation.dart';
import 'package:mytect/ui/main/profile/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_hunter/wifi_hunter.dart';
import 'package:wifi_hunter/wifi_hunter_result.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  int _currentIndex = 0;
  final List<Widget> _children = [];
  final List<Widget> pages = [HomeScreen(), SimulationScreen(), PeopleScreen(), HistoryScreen(), ProfileScreen()];
  WiFiHunterResult wiFiHunterResult = WiFiHunterResult();

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userFromPeference = prefs.getString("user");
    dynamic user = jsonDecode(userFromPeference);

    Location location = Location();
    LocationData locationData;
    String macAddress;

    locationData = await location.getLocation();

    try {
      macAddress = await GetMac.macAddress;
    } on PlatformException {
      macAddress = 'Failed to get Device MAC Address.';
    }

    wiFiHunterResult = await WiFiHunter.huntWiFiNetworks;

    List<dynamic> wifiList = [];

    wiFiHunterResult.results.forEach((wifi) {
      wifiList.add({
        'level': wifi.level.toString(),
        'SDDI': wifi.SSID,
        'BSSID': wifi.BSSID,
        'Capabilities': wifi.capabilities,
        'Frequency': wifi.frequency.toString(),
        'Channel Width': wifi.channelWidth.toString(),
        'Timestamp': wifi.timestamp.toString()
      });
    });

    final coordinates = new Coordinates(locationData.latitude, locationData.longitude);
     List<Address> addressFromGeocoder =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
        
    await firestore.collection('data').add({
      'user': user['id'],
      'latitude': locationData.latitude,
      'longitude': locationData.longitude,
      'altitude': locationData.altitude,
        'adminArea': addressFromGeocoder.first.adminArea,
        'subLocality': addressFromGeocoder.first.subLocality,
        'locality': addressFromGeocoder.first.locality,
        'subAdminArea': addressFromGeocoder.first.subAdminArea,
      'macAddress': macAddress,
      'wifiList': wifiList,
      'time': FieldValue.serverTimestamp(),
      'updatedAt': DateTime.now()
    });
  }

  @override
  void initState() {
    super.initState();
    
    Timer.periodic(Duration(seconds: 40), (timer) {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
          child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = 0;
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.only(top: 5.0),
                        height: 50.0,
                        child: Column(children: [
                          Icon(CupertinoIcons.home,
                              color: (_currentIndex == 0)
                                  ? AppColors.PrimaryColor
                                  : Colors.black54),
                          Text('Home',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: (_currentIndex == 0)
                                      ? AppColors.PrimaryColor
                                      : Colors.black54))
                        ])))),
            Expanded(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = 1;
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.only(top: 5.0),
                        height: 50.0,
                        child: Column(children: [
                          Icon(CupertinoIcons.check_mark,
                              color: (_currentIndex == 1)
                                  ? AppColors.PrimaryColor
                                  : Colors.black54),
                          Text('Simulation',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: (_currentIndex == 1)
                                      ? AppColors.PrimaryColor
                                      : Colors.black54))
                        ])))),
            Expanded(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = 2;
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.only(top: 5.0),
                        height: 50.0,
                        child: Column(children: [
                          Icon(CupertinoIcons.person_2,
                              color: (_currentIndex == 2)
                                  ? AppColors.PrimaryColor
                                  : Colors.black54),
                          Text('People',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: (_currentIndex == 2)
                                      ? AppColors.PrimaryColor
                                      : Colors.black54))
                        ])))),
            Expanded(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = 3;
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.only(top: 5.0),
                        height: 50.0,
                        child: Column(children: [
                          Icon(CupertinoIcons.list_bullet,
                              color: (_currentIndex ==3)
                                  ? AppColors.PrimaryColor
                                  : Colors.black54),
                          Text('History',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: (_currentIndex == 3)
                                      ? AppColors.PrimaryColor
                                      : Colors.black54))
                        ])))),
            Expanded(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = 4;
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.only(top: 5.0),
                        height: 50.0,
                        child: Column(children: [
                          Icon(CupertinoIcons.person,
                              color: (_currentIndex == 4)
                                  ? AppColors.PrimaryColor
                                  : Colors.black54),
                          Text('Profile',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: (_currentIndex == 4)
                                      ? AppColors.PrimaryColor
                                      : Colors.black54))
                        ])))),
          ],
        ),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Container(
            height: double.infinity,
            width: double.infinity,
            //decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/background.jpg'),fit: BoxFit.fill)),
            child: pages[_currentIndex]),
      ),
    );
  }
}
