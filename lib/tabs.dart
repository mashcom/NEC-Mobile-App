import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nec_inspection_app/captured_forms.dart';
import 'package:nec_inspection_app/login.dart';
import 'package:nec_inspection_app/main.dart';
import 'package:path/path.dart';

import 'inspection.dart';

class TabsPage extends StatefulWidget {
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.camera),
                text: "Capture",
              ),
              Tab(
                icon: Icon(Icons.book),
                text: "Saved Inspections",
              ),
              Tab(
                icon: Icon(Icons.settings_applications),
                text: "Settings",
              ),
            ],
          ),
          title: Text('NEC Inspection App'),
          elevation: 10,
        ),
        body: TabBarView(
          children: [
            MyHomePage(title: 'Capture Inspection'),
            CapturedFormsPage(
              title: "Captured Forms",
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: RaisedButton(
                    child: Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.red,
                    onPressed: () {
                      InspectionProvider insp = InspectionProvider();
                      insp.open();
                      insp.logout();
                      Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                              builder: (BuildContext context) => LoginPage()));
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
