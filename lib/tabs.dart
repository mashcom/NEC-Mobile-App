import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              ListView(
                children: <Widget>[
                  ListTile(
                    title: Text("Auto Validate Input"),
                    subtitle: Text("Validate input while user is typing input"),
                    trailing: Form(
                      child: Checkbox(
                        value: false,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text("Auto Validate Input"),
                    subtitle: Text("Validate input while user is typing input"),
                    trailing: Form(
                      child: Checkbox(
                        value: false,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  }
}
