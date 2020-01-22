import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'inspection.dart';
import 'view_inspection.dart';

class CapturedFormsPage extends StatefulWidget {
  CapturedFormsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CapturedFormsPageState createState() => _CapturedFormsPageState();
}

class _CapturedFormsPageState extends State<CapturedFormsPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final DocumentReference postRef = Firestore.instance.document('inspections');
  var saved_forms;
  var unprocessed_forms;
  bool is_syncing = false;
  InspectionProvider insp;

  @override
  void initState() {
    super.initState();
    insp = InspectionProvider();
    insp.open();
    saved_forms = insp.getAllInspection();

    print(saved_forms);
  }

  openViewInspection() {
    print("df");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewIspectionRoute()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Inspection>>(
        future: saved_forms,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.book,
                  size: 100,
                  color: Color.fromRGBO(0, 0, 0, 0.2),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("No Inspections Captured"),
                SizedBox(
                  height: 30,
                ),
                RaisedButton(
                  color: Colors.indigo,
                  textColor: Colors.white,
                  child: Text("Capture New Inspection"),
                  onPressed: () => {},
                ),
              ],
            ));
          return is_syncing
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        strokeWidth: 2,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Syncing please wait",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: EdgeInsets.only(top: 20),
                  children: snapshot.data
                      .map((inspection) => GestureDetector(
                            // onTap: openViewInspection(),
                            child: ListTile(
                              title: Text(
                                inspection.company_name
                                    .toString()
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                inspection.date.toString().toUpperCase(),
                                maxLines: 1,
                              ),
                              onTap: () => {},
                              trailing: inspection.done
                                  ? Icon(
                                      Icons.done_all,
                                      color: Colors.lightBlue,
                                    )
                                  : Icon(
                                      Icons.sync_problem,
                                      color: Colors.red,
                                    ),
                            ),
                          ))
                      .toList(),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (is_syncing == false) {
            setState(() {
              is_syncing = true;
            });
            var duration = Duration(seconds: 2);
            Timer(duration, () {
              insp.getUnprossedInspections().then((response) {
                // insp.getAllInspection().then((inspections) {
                setState(() {
                  is_syncing = false;
                });
                // saved_forms = inspections;
                // });
              });
            });
          }
        },
        tooltip: 'Sync',
        child: Icon(Icons.cloud_upload),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
