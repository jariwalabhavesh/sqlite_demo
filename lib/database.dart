import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_demo/person.dart';

class DatabaseHelper {
  late Database db;
  Future<void> initDB() async {
    String path = await getDatabasesPath();
    db = await openDatabase(
      join(path, 'person.db'),
      onCreate: (database, version) async {
        await database.execute(
          """
            CREATE TABLE users (
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              name TEXT NOT NULL,
              city TEXT NOT NULL
            )
          """,
        );
      },
      version: 1,
    );
  }

  Future<List<Person>> retrieveUsers() async {
    final List<Map<String, Object?>> queryResult = await db.query('users');
    return queryResult.map((e) => Person.fromMap(e)).toList();
  }

  Future<int> insertUser(Person person) async {
    int result = await db.insert('users', person.toMap());
    return result;
  }

  Future<int> deleteUser(int id) async {
    print('delete id : $id');
    int result = await db.delete(
      'users',
      where: "id = ?",
      whereArgs: [id],
    );
    return result;
  }

  /// Update the user record at [personId] in sql database.
  Future<int> updateUser(Person person, int personId) async {
    print('Updating User: ${person.toMap()}');
    int result = await db
        .update('users', person.toMap(), where: "id=?", whereArgs: [personId]);
    return result;
  }

  void deleteDb() async {
    String path = await getDatabasesPath();
    String finalDbPath = join(
      path,
    );
    deleteDatabase(finalDbPath);
  }
}
