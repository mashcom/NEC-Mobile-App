import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

tableHeaderCollection(String col1, String col2, String col3) {
  return TableRow(children: [
    Padding(
      padding: EdgeInsets.all(10),
      child: Text(col1),
    ),
    Padding(
      padding: EdgeInsets.all(10),
      child: Text(col2),
    ),
    Padding(
      padding: EdgeInsets.all(10),
      child: Text(col3),
    ),
  ]);
}

tableFormCheckCollection(String title, String name) {
  return TableRow(
    children: [
      Padding(
        padding: EdgeInsets.all(10),
        child: Text(title),
      ),
      FormBuilderCheckbox(
        attribute: name,
        label: Text(""),
        initialValue: false,
      ),
      FormBuilderTextField(
        attribute: name + "_comment",
        decoration: InputDecoration(labelText: "Comment"),
      ),
    ],
  );
}
