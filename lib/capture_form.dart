import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:nec_inspection_app/table_form_check_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'app_theme.dart';
import 'inspection.dart';

captureForm(context, _fbKey) {
  Future _showAlert(BuildContext context, String message) async {
    return showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text(message),
          actions: <Widget>[
            new FlatButton(
                onPressed: () => Navigator.pop(context), child: new Text('Ok'))
          ],
        ));
  }

  return Padding(
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
                    attribute: "name",
                    decoration: InputDecoration(labelText: "Employer Name"),
                    autofocus: true,
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                  ),
                  FormBuilderTextField(
                    attribute: "address",
                    decoration: InputDecoration(
                        labelText: "Address of employer(physical)"),
                    autofocus: true,
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(10),
                    ],
                  ),
                  FormBuilderTextField(
                    attribute: "telephone",
                    decoration: InputDecoration(labelText: "Telephone Number"),
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
                  FormBuilderDateTimePicker(
                    attribute: "inspection_date",
                    inputType: InputType.date,
                    format: DateFormat("yyyy-MM-dd"),
                    decoration: InputDecoration(labelText: "Inspection Date"),
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                  ),
                  FormBuilderTextField(
                    attribute: "industry_classification",
                    decoration:
                        InputDecoration(labelText: "Industry Classification"),
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                  ),
                  FormBuilderTextField(
                    attribute: "cbs_si_no",
                    decoration: InputDecoration(
                        labelText: "Collective Bargaining Agreement: S.I. No"),
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
                  Divider(),
                  SizedBox(
                    height: 30,
                    child: Text(
                      "1. Employee Profiles",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    child: Table(
                      border:
                          TableBorder.all(color: Color.fromRGBO(0, 0, 0, 0.2)),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: {
                        0: FractionColumnWidth(.6),
                        1: FractionColumnWidth(.2),
                        2: FractionColumnWidth(.2)
                      },
                      children: [
                        tableHeaderCollection(
                            "Nature of Contract", "Male", "Female"),
                        tableFormSectionOneCollection(
                            "(i) Permanent", "permanent"),
                        tableFormSectionOneCollection(
                            "(ii) Fixed Term Contract (a)Seasonal",
                            "contract_seasonal"),
                        tableFormSectionOneCollection(
                            "(ii) Fixed Term Contract (b)Casual",
                            "contract_casual"),
                        tableFormSectionOneCollection(
                            "(iii) Employees under 15 years", "under_15"),
                      ],
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 30,
                    child: Text(
                      "2. Labour Relations (General) (Amendment) Regulations,2003 (No.1)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  formHeadingSection("2.1. General Conditions of Employment"),
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    child: Table(
                      border:
                          TableBorder.all(color: Color.fromRGBO(0, 0, 0, 0.2)),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: {
                        0: FractionColumnWidth(.4),
                        1: FractionColumnWidth(.2),
                        2: FractionColumnWidth(.4)
                      },
                      children: [
                        tableHeaderCollection(
                            "Conditions of Employment",
                            "Tick if in compliance",
                            "Comments by designated agent/inspector and action taken to rectify"),
                        tableFormCheckCollection(
                            "(i) Grading and wages", "grading_wages"),
                        tableFormCheckCollection(
                            "(ii) Hours of Work", "hours_of_work"),
                        tableFormCheckCollection(
                            "(iii) Short Time Work", "short_time_work"),
                        tableFormCheckCollection(
                            "(iv) Special /Annual/Casual leave",
                            "special_leave"),
                        tableFormCheckCollection(
                            "(v) Sick leave", "sick_leave"),
                        tableFormCheckCollection(
                            "(vi) Maternity leave", "maternity_leave"),
                        tableFormCheckCollection("(viii) Overtime", "overtime"),
                        tableFormCheckCollection(
                            "(ix )Deductions", "deductions"),
                        tableFormCheckCollection(
                            "(x) Incentive productions bonus scheme",
                            "incentive_productions_bonus_scheme"),
                        tableFormCheckCollection(
                            "(xi) Industrial holidays", "industrial_holidays"),
                        tableFormCheckCollection(
                            "(xii) Gratuities", "gratuities"),
                        tableFormCheckCollection(
                            "(xiii) Pension Scheme", "pension_scheme"),
                        tableFormCheckCollection(
                            "(xiv) Accommodation", "accommodation"),
                      ],
                    ),
                  ),
                  formHeadingSection(
                      "2.2 General Conditions of Employment: Occupational Health and Safety"),
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    child: Table(
                      border:
                          TableBorder.all(color: Color.fromRGBO(0, 0, 0, 0.2)),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: {
                        0: FractionColumnWidth(.4),
                        1: FractionColumnWidth(.2),
                        2: FractionColumnWidth(.4)
                      },
                      children: [
                        tableHeaderCollection(
                            "Conditions of Employment",
                            "Provided for/not provided for",
                            "Comments by designated agent/inspector and action taken"),
                        tableFormCheckCollection(
                            "(i)Protective Clothing", "protective_clothing"),
                        tableFormCheckCollection(
                            "(ii) NSSA–workman’s compensation",
                            "nssa_workman_compensation"),
                        tableFormCheckCollection(
                            "(iii) Health and Safety committee",
                            "health_and_safetycommittee"),
                      ],
                    ),
                  ),
                  formHeadingSection(
                      "2.3 General Conditions of Employment: HIV and AIDS"),
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    child: Table(
                      border:
                          TableBorder.all(color: Color.fromRGBO(0, 0, 0, 0.2)),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: {
                        0: FractionColumnWidth(.4),
                        1: FractionColumnWidth(.2),
                        2: FractionColumnWidth(.4)
                      },
                      children: [
                        tableHeaderCollection(
                            "Conditions of Employment",
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
                        tableFormCheckCollection(
                            "(vii) Medical testing", "medical_testing"),
                        tableFormCheckCollection(
                            "(viii)Care and Support", "care_and_support"),
                      ],
                    ),
                  ),
                  formHeadingSection(
                      "3. Operational Institutions/Instruments under the Labour Act"),
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    child: Table(
                      border:
                          TableBorder.all(color: Color.fromRGBO(0, 0, 0, 0.2)),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: {
                        0: FractionColumnWidth(.4),
                        1: FractionColumnWidth(.2),
                        2: FractionColumnWidth(.4)
                      },
                      children: [
                        tableHeaderCollection(
                            "Institution/Instrument",
                            "Tick if Existent",
                            "Comments by designated agent/inspector and action taken"),
                        tableFormCheckCollection(
                            "(i)Workers committee", "workers_committee"),
                        tableFormCheckCollection(
                            "(ii)Works council", "works_council"),
                        tableFormCheckCollection(
                            "(iii)Trade Unions (a)Registered (b)Unregistered:",
                            "trade_unions"),
                        tableFormCheckCollection(
                            "(iv)Employers organisations (a)Registered (b)Unregistered",
                            "employers_organisations"),
                        tableFormCheckCollection(
                            "(v)Employment Council", "employment_council"),
                        tableFormCheckCollection(
                            "(vi)Employment Code of Conduct: (a)Works Council (b)NEC",
                            "employment_code_of_conduct"),
                      ],
                    ),
                  ),
                  formHeadingSection(
                      "4. Evidence of any offence/contravention"),
                  FormBuilderTextField(
                    attribute: "evidence_of_offence",
                    decoration: InputDecoration(
                        labelText:
                            "Books or documents/records seized as evidence of offence:"),
                  ),
                  FormBuilderTextField(
                    attribute: "general_observations",
                    decoration:
                        InputDecoration(labelText: " General observations:"),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  formHeadingSection("Signed"),
                  FormBuilderSignaturePad(
                    decoration: InputDecoration(
                        labelText: "Designated Agent/Inspector Signature"),
                    attribute: "agent_signature",
                    height: 100,
                  ),
                  FormBuilderSignaturePad(
                    decoration: InputDecoration(
                        labelText: "Employers /Representative Signature"),
                    attribute: "employer_signature",
                    height: 100,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.indigo,
                  onPressed: () {
                    if (_fbKey.currentState.saveAndValidate()) {
                      Firestore.instance
                          .collection('inspections')
                          .add(_fbKey.currentState.value)
                          .then((DocumentReference ds) {
                        _showAlert(context, "Form has been successfully saved");
                        /*inspectionProvider.open("inspections.db");
                            Inspection insp = Inspection();
                            insp.content=_fbKey.currentState.value.toString();
                            inspectionProvider.insert(insp);*/
                      }).catchError((Object error) {
                        print(error);
                      });

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
  );
}
