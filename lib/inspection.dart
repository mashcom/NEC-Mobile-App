import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:convert/convert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final String tableInspection = 'inspection';
final String columnId = '_id';
final String columnContent = 'title';
final String columnCompanyName = 'company_name';
final String columnDone = 'done';
final String databaseName = 'nec_inspection_zw.db';

class Inspection {
  int id;
  String company_name;
  String content;
  bool done;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnContent: content,
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
/*
    if(await Directory(dirname(path)).exists()){
      //await deleteDatabase(path);
    }else{
      await Directory(dirname(path)).create(recursive:true);
    }*/
    return path;
  }

  Future open() async {
    final path = await getDatabasePath(databaseName);
    db = await openDatabase(path, version: 2,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableInspection ( 
  $columnId integer primary key autoincrement, 
  $columnCompanyName text not null,
  $columnContent text not null,
  $columnDone integer not null)
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
      String inspection_data, String companyName) async {
    var dbClient = await db_con;

    print("COMPANY NAME IS $companyName");
    int id1 = await dbClient.rawInsert(
        'INSERT INTO $tableInspection($columnCompanyName,$columnContent,$columnDone) VALUES(?,?,?)',
        [companyName, inspection_data, 0]);
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

  Future<Inspection> getUnprossedInspections() async {
    print("Processing Forms");
    var dbClient = await db_con;
    var result = await dbClient
        .rawQuery('SELECT * FROM $tableInspection WHERE $columnDone=0');
    //print(result);

    result.forEach((v) => {
          //print(json.decode(v['content']))
          syncToCloud(v["_id"],v[columnContent])
        });
    
  }

  syncToCloud(id,content) async {
    print("Syncing to cloud");
    Map <String,dynamic> c = {"content":content};
    try {
      Firestore.instance
          .collection('inspections')
          .add(c)
          .then((DocumentReference ds) {
        print("Processed");
        markAsDone(id);
      }).catchError((Object error) {
        print(error);
      });
    }
    catch(error){
      print(error);
    }
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
