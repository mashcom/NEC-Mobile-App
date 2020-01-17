import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

tableHeaderCollection(String col1, String col2, String col3) {
  return TableRow(children: [
    Padding(
      padding: EdgeInsets.all(10),
      child: Text(col1,style: TextStyle(fontWeight: FontWeight.bold),),
    ),
    Padding(
      padding: EdgeInsets.all(10),
      child: Text(col2,style: TextStyle(fontWeight: FontWeight.bold),),
    ),
    Padding(
      padding: EdgeInsets.all(10),
      child: Text(col3,style: TextStyle(fontWeight: FontWeight.bold),),
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
          leadingInput: true,
          activeColor: Color.fromRGBO(50, 205, 50, 1),
          decoration: InputDecoration(border: InputBorder.none, hintText: '')),

      Padding(
        padding: EdgeInsets.all(10),
        child: FormBuilderTextField(
          attribute: name + "_comment",
          decoration: InputDecoration(labelText: "Comment"),
        ),
      ),
    ],
  );
}

tableFormSectionOneCollection(String title, String name) {
  return TableRow(
    children: [
      Padding(
        padding: EdgeInsets.all(10),
        child: Text(title),
      ),
      Padding(
        padding: EdgeInsets.all(10),
        child: FormBuilderTextField(
          attribute: name + "_male",
          decoration: InputDecoration(labelText: ""),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(10),
        child: FormBuilderTextField(
          attribute: name + "_female",
          decoration: InputDecoration(labelText: ""),
        ),
      ),
    ],
  );
}

formHeadingSection(String title) {
  return Column(
    children: <Widget>[
      Divider(),
      SizedBox(
        height: 20,
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
      SizedBox(
        height: 20,
      ),
    ],
  );
}

