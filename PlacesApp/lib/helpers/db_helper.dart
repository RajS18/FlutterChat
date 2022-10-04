import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {// the method is being provided as static because we need to 
  //make the DB operating / methods as static(class instantiated). 
    final dbPath = await sql.getDatabasesPath();
    //Get the default databases location.On Android, it is typically data/data/<package_name>/databases
    //On iOS, it is the Documents directory
    return sql.openDatabase(path.join(dbPath, 'places.db'),//This will openDB for specified path if it is present else,
    //we need to create it.
        onCreate: (db, version) {//create database as "db" for specified path and specified version
         //then mention what should be done onCreate.
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, loc_lat REAL, loc_lng REAL, address TEXT)');
    }, version: 1);
    //Open the database at a given path [version] (optional) specifies the schema version of the database being 
    //opened. This is used to decide whether to call [onCreate], [onUpgrade], and [onDowngrade]
    //Keep in mind about what is to be used in Table name argument
    
  }

  static Future<void> insert(String table, Map<String, Object> data) async {//insert query
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,// update if existing record is found (on conflict).
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {//select "all" query. 
    final db = await DBHelper.database();
    return db.query(table);
  }

  
}
