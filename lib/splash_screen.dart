import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nec_inspection_app/inspection.dart';
import 'package:nec_inspection_app/login.dart';
import 'package:nec_inspection_app/tabs.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = Duration(seconds: 3);
    return Timer(duration, () {
      InspectionProvider insp = InspectionProvider();
      insp.open();
      insp.getSession().then((response) {
        if (response != "") {
          Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                  builder: (BuildContext context) => TabsPage()));
        } else {
          Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                  builder: (BuildContext context) => LoginPage()));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SizedBox(
        height: 400,
        child: Column(
          children: <Widget>[
            FlutterLogo(
              size: 100,
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "NEC Inspection App",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 50,
            ),
            CircularProgressIndicator(
              backgroundColor: Colors.white,
              strokeWidth: 2,
            ),
          ],
        ),
      )),
    );
  }
}
