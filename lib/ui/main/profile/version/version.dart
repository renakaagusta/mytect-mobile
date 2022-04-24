import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mytect/constants/assets.dart';
import 'package:mytect/constants/colors.dart';
import 'package:mytect/constants/strings.dart';

class VersionScreen extends StatefulWidget {
  @override
  _VersionScreenState createState() => _VersionScreenState();
}

class _VersionScreenState extends State<VersionScreen> {
  
  @override
  void initState() {
    super.initState();
    
  }
  
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        primary: true,
        backgroundColor: Colors.white,
        body: FlutterEasyLoading(
          child: _buildRightSide(),
        ));
  }

  Widget _buildRightSide() {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.only(top: 50),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Stack(children: [
                    Align(
                      alignment: Alignment.center,
                      child:
                          Image.asset('assets/icons/logo-app.png', height: 100),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                          margin: EdgeInsets.only(top: 130),
                          child: Text(
                            Strings.appName,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          )),
                    )
                  ]),
                  Container(
                    padding: EdgeInsets.only(top: 40, left: 30.0, right: 30.0),
                    child: Column(
                      children: [
                        Text(
                          'Versi Aplikasi',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Text(
                          '1.00',
                          style: TextStyle(fontSize: 20, color: Colors.black45),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Change log',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          '-',
                          style: TextStyle(fontSize: 20, color: Colors.black45),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
