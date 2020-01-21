import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:nec_inspection_app/main.dart';
import 'app_theme.dart';
import 'inspection.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NEC Inspection App',
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          textTheme: AppTheme.textTheme,
          platform: TargetPlatform.iOS),
      home: LoginPage(title: 'NEC Inspection App'),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => MyHomePage(title: 'Home'),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  bool is_authenticating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(),
        child: Center(
          child: SizedBox(
            width: 400,
            child: Padding(
              padding: EdgeInsets.only(top: 200),
              child: FormBuilder(
                key: _fbKey,
                initialValue: {
                  'date_collected': DateTime.now(),
                },
                autovalidate: true,
                child: Column(
                  children: <Widget>[
                    FlutterLogo(
                      size: 100,
                    ),
                    Text(
                      "NEC Inspection App",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Divider(
                      height: 50,
                    ),
                    FormBuilderTextField(
                      attribute: "email",
                      decoration: InputDecoration(labelText: "Email"),
                      autofocus: true,
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email(),
                      ],
                    ),
                    FormBuilderTextField(
                      attribute: "password",
                      decoration: InputDecoration(labelText: "Password"),
                      validators: [
                        FormBuilderValidators.required(),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    is_authenticating
                        ? CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            strokeWidth: 2,
                          )
                        : RaisedButton(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Sign In",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            color: Colors.indigo,
                            onPressed: () async {
                              if (_fbKey.currentState.saveAndValidate()) {
                                InspectionProvider insp = InspectionProvider();
                                insp.open();

                                var email = _fbKey.currentState.value["email"];
                                var password =
                                    _fbKey.currentState.value["password"];

                                setState(() {
                                  is_authenticating = true;
                                });

                                // Future<bool> is_valid_credentials = insp.login(email, password);
                                insp.login(email, password).then((resp) {
                                  setState(() {
                                    is_authenticating = false;
                                  });

                                  if (resp == true) {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (BuildContext context) =>
                                                MyHomePage()));
                                  } else {
                                    print("login failed");
                                  }
                                });
                              }

                              //insp.getSession();
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
