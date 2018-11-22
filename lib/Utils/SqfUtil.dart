import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';


Future<String> createNewDatabase(String dbName) async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();

  print(documentsDirectory);

  String path = join(documentsDirectory.path, dbName);

  if (await new Directory(dirname(path)).exists()) {
    await deleteDatabase(path);
  } else {
    try {
      await new Directory(dirname(path)).create(recursive: true);
    } catch (e) {
      print(e);
    }
  }

  return path;
  
}
//String sql_createTable;
//_create() async{
//  dbPath =  await createNewDatabase(dbName);
//  Database db = await openDatabase(dbPath);
//
//  await db.execute(sql_createTable);
//  await db.close();
//  setState((){
//    _result =''
//  })
//}