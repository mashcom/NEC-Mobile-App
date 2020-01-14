import 'package:flutter/cupertino.dart';
import 'package:nec_inspection_app/table_form_check_collection.dart';
import 'app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NEC Inspection App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
          primarySwatch: Colors.indigo,
          textTheme: AppTheme.textTheme,
          platform: TargetPlatform.iOS),
      home: MyHomePage(title: 'NEC Inspection App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final DocumentReference postRef = Firestore.instance.document('inspections');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(25),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Center(
                  child: Text(
                    "NEC FOR THE ZIMBABWE ENERGY INDUSTRY LABOUR INSPECTORATE INSPECTION FORM",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(
                  height: 50,
                ),
                FormBuilder(
                  key: _fbKey,
                  initialValue: {
                    'date': DateTime.now(),
                    'accept_terms': false,
                  },
                  autovalidate: true,
                  child: Column(
                    children: <Widget>[
                      FormBuilderTextField(
                        attribute: "name_and_address",
                        decoration: InputDecoration(
                            labelText:
                            "Name and address of employer(physical)"),
                        autofocus: true,
                        validators: [
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(10),
                        ],
                      ),
                      FormBuilderTextField(
                        attribute: "telephone",
                        decoration:
                        InputDecoration(labelText: "Telephone Number"),
                        validators: [
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                        ],
                      ),
                      FormBuilderTextField(
                        attribute: "email",
                        decoration: InputDecoration(labelText: "Email"),
                        validators: [
                          FormBuilderValidators.required(),
                          FormBuilderValidators.email(
                              errorText: "Invalid email format"),
                        ],
                      ),
                      FormBuilderTextField(
                        attribute: "inspection_date",
                        decoration:
                        InputDecoration(labelText: "Inspection Date"),
                        validators: [
                          FormBuilderValidators.required(),
                        ],
                      ),
                      FormBuilderTextField(
                        attribute: "industry_classification",
                        decoration: InputDecoration(
                            labelText: "Industry Classification"),
                        validators: [
                          FormBuilderValidators.required(),
                        ],
                      ),
                      FormBuilderTextField(
                        attribute: "cbs_si_no",
                        decoration: InputDecoration(
                            labelText:
                            "Collective Bargaining Agreement: S.I. No"),
                        validators: [
                          FormBuilderValidators.required(),
                        ],
                      ),
                      FormBuilderTextField(
                        attribute: "er_si_no",
                        decoration: InputDecoration(
                            labelText: "Employment Regulations: S.I. No"),
                        validators: [
                          FormBuilderValidators.required(),
                        ],
                      ),
                      FormBuilderTextField(
                        attribute: "plant_level_agreement",
                        decoration: InputDecoration(
                            labelText: "Works Council/Plant level Agreement"),
                        validators: [
                          FormBuilderValidators.required(),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                        child: Text(
                          "Employee Profiles",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        height: 20,
                        child: Text(
                          "Labour Relations (General) (Amendment) Regulations,2003 (No.1)",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        height: 20,
                        child: Text(
                          "2.1. General Conditions of Employment",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                        child: Table(
                          border: TableBorder.all(color: Color.fromRGBO(
                              0, 0, 0, 0.2)),
                          defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                          columnWidths: {
                            0: FractionColumnWidth(.4),
                            1: FractionColumnWidth(.2),
                            2: FractionColumnWidth(.4)
                          },
                          children: [
                            tableHeaderCollection("Conditions of Employment",
                                "Tick if in compliance",
                                "Comments by designated agent/inspector and action taken to rectify"),
                            tableFormCheckCollection("(i) Grading and wages",
                                "grading_wages"),
                            tableFormCheckCollection("(ii) Hours of Work",
                                "hours_of_work"),
                            tableFormCheckCollection("(iii) Short Time Work",
                                "short_time_work"),
                            tableFormCheckCollection(
                                "(iv) Special /Annual/Casual leave",
                                "special_leave"),
                            tableFormCheckCollection("(v) Sick leave",
                                "sick_leave"),
                            tableFormCheckCollection("(vi) Maternity leave",
                                "maternity_leave"),
                            tableFormCheckCollection("(viii) Overtime",
                                "overtime"),
                            tableFormCheckCollection("(ix )Deductions",
                                "deductions"),
                            tableFormCheckCollection(
                                "(x) Incentive productions bonus scheme",
                                "incentive_productions_bonus_scheme"),
                            tableFormCheckCollection("(xi) Industrial holidays",
                                "industrial_holidays"),
                            tableFormCheckCollection("(xii) Gratuities",
                                "gratuities"),
                            tableFormCheckCollection("(xiii) Pension Scheme",
                                "pension_scheme"),
                            tableFormCheckCollection("(xiv) Accommodation",
                                "accommodation"),

                          ],
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        height: 20,
                        child: Text(
                          "2.2 General Conditions of Employment: Occupational Health and Safety",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                        child: Table(
                          border: TableBorder.all(
                              color: Color.fromRGBO(0, 0, 0, 0.2)),
                          defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                          columnWidths: {
                            0: FractionColumnWidth(.4),
                            1: FractionColumnWidth(.2),
                            2: FractionColumnWidth(.4)
                          },
                          children: [
                            tableHeaderCollection("Conditions of Employment",
                                "Provided for/not provided for",
                                "Comments by designated agent/inspector and action taken"),
                            tableFormCheckCollection("(i)Protective Clothing",
                                "protective_clothing"),
                            tableFormCheckCollection(
                                "(ii) NSSA–workman’s compensation",
                                "nssa_workman_compensation"),
                            tableFormCheckCollection(
                                "(iii) Health and Safety committee",
                                "health_and_safetycommittee"),

                          ],
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        height: 20,
                        child: Text(
                          "2.3 General Conditions of Employment: HIV and AIDS",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                        child: Table(
                          border: TableBorder.all(
                              color: Color.fromRGBO(0, 0, 0, 0.2)),
                          defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                          columnWidths: {
                            0: FractionColumnWidth(.4),
                            1: FractionColumnWidth(.2),
                            2: FractionColumnWidth(.4)
                          },
                          children: [
                            tableHeaderCollection("Conditions of Employment",
                                "Provided for/not provided for",
                                "Comments by designated agent/inspector and action taken"),
                            tableFormCheckCollection(
                                "(i) Accessibility of SI 202 OF 1998",
                                "accessibility_of_si_202_of_1998"),
                            tableFormCheckCollection(
                                "(ii) Any HIV and AIDS policy in place",
                                "any_hiv_and_aids_policy_in_place"),
                            tableFormCheckCollection(
                                "(iii)Any HIV and AIDS committee/coordinator",
                                "any_hiv_and_aids_commitee"),
                            tableFormCheckCollection(
                                "(iv) Education and awareness of employees",
                                "hiv_and_aids_education"),
                            tableFormCheckCollection(
                                "(v) HIV and AIDS risk management",
                                "hiv_and_aids_risk_management"),
                            tableFormCheckCollection(
                                "(vi) Any peer educators and councillors",
                                "any_peer_educators_and_councillors"),
                            tableFormCheckCollection("(vii) Medical testing",
                                "medical_testing"),
                            tableFormCheckCollection("(viii)Care and Support",
                                "care_and_support"),
                          ],
                        ),
                      ),
                      FormBuilderSignaturePad(
                        decoration: InputDecoration(labelText: "Signature"),
                        attribute: "signature",
                        height: 100,
                      ),
                    ],
                  ),
                  /*9+-

                   */
                ),
                Row(
                  children: <Widget>[
                    RaisedButton(
                      child: Text("Submit"),
                      onPressed: () {
                        if (_fbKey.currentState.saveAndValidate()) {
                          print(_fbKey.currentState.value);
                        }
                      },
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    RaisedButton(
                      child: Text("Reset"),
                      onPressed: () {
                        _fbKey.currentState.reset();
                      },
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Capture New Form',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
