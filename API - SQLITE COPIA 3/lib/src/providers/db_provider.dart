import 'dart:io';
import 'package:api_to_sqlite/src/models/employee_model.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database?> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  // Create the database and the Employee table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'bbddCiclistes_manager3.db');

    return await openDatabase(path, version: 4, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE TopCiclistes('
          'id INTEGER PRIMARY KEY,'
          'nom TEXT,'
          'equip TEXT,'
          'punts TEXT,'
          'imatge TEXT'
          ')');
    });
  }

  //Obtenir tots els ciclistes
  Future<List<TopUci?>> getAllEmployees() async {
    final db = await database;
    final res = await db?.rawQuery("SELECT * FROM TopCiclistes");

    List<TopUci> list =
        res!.isNotEmpty ? res.map((c) => TopUci.fromJson(c)).toList() : [];

    return list;
  }

  // Insertar ciclistes a la BBDD
  createEmployee(TopUci newEmployee) async {
    await deleteAllEmployees();
    final db = await database;
    final res = await db?.insert('TopCiclistes', newEmployee.toJson());

    return res;
  }

  // Insertar un nou ciclista
  newInsertEmployee(TopUci newEmployee) async {
    // await deleteAllEmployees();
    final db = await database;
    final res = await db?.insert('TopCiclistes', newEmployee.toJson());

    return res;
  }

//Eliminar un ciclista
  newDeleteEmployee(int deleteEmployeeId) async {
    final db = await database;
    final res = db?.delete('TopCiclistes',
        where: "id = ?", whereArgs: [deleteEmployeeId]);

    getAllEmployees();

    return res;
  }

  // Eliminar tots els ciclistes
  Future<int?> deleteAllEmployees() async {
    final db = await database;
    final res = await db?.rawDelete('DELETE FROM TopCiclistes');

    return res;
  }
}
