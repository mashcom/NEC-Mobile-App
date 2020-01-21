import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

final String tableInspection = 'inspection';
final String tableUserAuth = 'user_auth';
final String columnId = '_id';
final String columnDate = 'date_collected';
final String columnContent = 'title';
final String columnCompanyName = 'company_name';
final String columnDone = 'done';
final String databaseName = 'nec_inspection_bonded.db';

final String username = "test@test.com";
final String password = "password";

class Inspection {
  int id;
  String company_name;
  String date;
  var content;
  bool done;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnContent: content,
      columnDate: date,
      columnCompanyName: company_name,
      columnDone: done == true ? 1 : 0
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Inspection();

  Inspection.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    content = map[columnContent];
    date = map[columnDate];
    company_name = map[columnCompanyName];
    done = map[columnDone] == 1;
  }
}

class InspectionProvider {
  Database db;

  Future<Database> get db_con async {
    if (db != null) return db;
    db = await open();
    return db;
  }

  Future<String> getDatabasePath(String databaseName) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, databaseName);

    return path;
  }

  Future open() async {
    final path = await getDatabasePath(databaseName);
    db = await openDatabase(path, version: 3,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableInspection ( 
  $columnId integer primary key autoincrement, 
   $columnDate text not null,
  $columnCompanyName text not null,
  $columnContent text not null,
  $columnDone integer not null)
''');

      await db.execute('''
create table $tableUserAuth ( 
  $columnId integer primary key autoincrement, 
  username text not null,
  access_token text not null
  )
''');
    });
    print(db);
    return db;
  }

  Future<Inspection> insert(Inspection inspection) async {
    inspection.id = await db.insert(tableInspection, inspection.toMap());
    return inspection;
  }

  Future<Inspection> simpleInsert(
      String inspection_data, String companyName, String date) async {
    var dbClient = await db_con;

    print("COMPANY NAME IS $companyName");
    int id1 = await dbClient.rawInsert(
        'INSERT INTO $tableInspection($columnDate,$columnCompanyName,$columnContent,$columnDone) VALUES(?,?,?,?)',
        [date, companyName, inspection_data, 0]);
    print('inserted1: $id1');
  }

  Future<List<Inspection>> getAllInspection() async {
    var dbClient = await db_con;
    List<Map> maps = await dbClient.query(tableInspection,
        columns: [columnId, columnDone, columnContent, columnCompanyName]);
    if (maps.length > 0) {
      List<Inspection> list = maps.map((item) {
        return Inspection.fromMap(item);
      }).toList();
      return list;
    }
    return null;
  }

  Future<Inspection> getInspection(int id) async {
    List<Map> maps = await db.query(tableInspection,
        columns: [columnId, columnDone, columnContent],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Inspection.fromMap(maps.first);
    }
    return null;
  }

  Future<bool> login(String usernameInput, String passwordInput) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, String> fields = {
      'grant_type': 'password',
      'client_id': '2',
      'client_secret': 'efO6UmSteMMZ0qPU3Hqn4whRf4BauFbp0Ndgxi0s',
      'username': usernameInput,
      'password': passwordInput,
    };

    var url = 'http://192.168.56.1/nec_web/public/oauth/token';
    final response =
        await http.post(url, headers: headers, body: json.encode(fields));

    print("token");
    Map<String, dynamic> auth_response = jsonDecode(response.body);
    String access_token = auth_response["access_token"];
    if (access_token != null) {
      print("Success");
      saveAccessToken(username, access_token);
      return Future.value(true);
    } else {
     return Future.value(false);
    }
  }

  Future<String> getSession() async {
    print("Session MGT");
    var dbClient = await db_con;
    var result =
        await dbClient.rawQuery('SELECT * count FROM $tableUserAuth LIMIT 1');
    //get token
    print("Getting SESSION");
    var access_token = "";
    // return null;
    result.forEach((v) => {
          //print(json.decode(v['content']))
          access_token = v['access_token']
        });
    return access_token;
  }

  saveAccessToken(String username, String access_token) async {
    var dbClient = await db_con;

    await dbClient.rawDelete('DELETE FROM $tableUserAuth');

    int id1 = await dbClient.rawInsert(
        'INSERT INTO $tableUserAuth(username,access_token) VALUES(?,?)',
        [username, access_token]);
    print('inserted1: $id1');
  }

  getUnprossedInspections() async {
    print("Processing Forms");
    var dbClient = await db_con;
    var result = await dbClient
        .rawQuery('SELECT * FROM $tableInspection WHERE $columnDone=0');

    //get token
    print("Getting token");

    print("starting syncing");
    // return null;
    result.forEach((v) => {
          //print(json.decode(v['content']))
          syncToCloud(v["_id"], v[columnContent], "")
        });
    /*CapturedFormsPage h = CapturedFormsPage();
    h.createState().saved_forms = getAllInspection();*/
  }

  syncToCloud(id, content, api_token) async {
    print("Syncing to cloud");

    Map<String, dynamic> c = {"content": content};
    //try {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $api_token"
    };

    Map<String, String> fields = {
      'form_content': content.toString(),
    };
    var url = 'http://192.168.56.1/nec_web/public/api/inspection';
    final response =
        await http.post(url, headers: headers, body: json.encode(fields));

    Map<String, dynamic> auth_response = jsonDecode(response.body);
    var status = auth_response["status"];
    //print(access_token);
    //print(response.body);
    if (status == true) {
      markAsDone(id);
    }

    /*} catch (error) {
                            print(error);
                          }*/
    /*try {
      Firestore.instance
          .collection('inspections')
          .add(c)
          .then((DocumentReference ds) {
        print("Processed");
        //markAsDone(id);
      }).catchError((Object error) {
        print(error);
      });
    } catch (error) {
      print(error);
    }*/
  }

  Future<int> markAsDone(id) async {
    var dbClient = await db_con;
    return await dbClient.rawUpdate('UPDATE $tableInspection SET done=?', [1]);
  }

  Future<int> delete(int id) async {
    return await db
        .delete(tableInspection, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Inspection inspection) async {
    return await db.update(tableInspection, inspection.toMap(),
        where: '$columnId = ?', whereArgs: [inspection.id]);
  }

  Future close() async => db.close();
}
