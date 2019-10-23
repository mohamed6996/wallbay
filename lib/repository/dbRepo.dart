import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DbRepo {
  Database db;

  init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'photos.db');

    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) {
      db.execute("""
            CREATE TABLE favorites 
            (
             id TEXT PRIMARY KEY,
             width INTEGER,
             height INTEGER,
             liked_by_user INTEGER,
             regularPhotoUrl TEXT,
             color TEXT,
             fullPhotoUrl TEXT,
             downloadPhotoUrl TEXT,
             userId TEXT,
             username TEXT,
             name TEXT,
             mediumProfilePhotoUrl TEXT,
             bio TEXT
            )
            
            """);
    });
  }

  fetchPhoto(int id) async{
   final maps = await db.query(
      'favorites',
      columns: null,
      where: 'id = ?',
      whereArgs: [id],

    );

   if(maps.length >0){

   }
   return null;
  }
}
