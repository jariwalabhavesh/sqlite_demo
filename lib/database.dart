import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_demo/person.dart';

class DatabaseHelper {
  late Database db;
  Future<void> initDB() async {
    String path = await getDatabasesPath();
    // Open the database and store the reference.
    db = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(path, 'personDB.db'),
      // When the database is first created, create a table to store persons.
      onCreate: (database, version) async {
        // Run the CREATE TABLE statement on the database.
        await database.execute(
          """
            CREATE TABLE persons (
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              name TEXT NOT NULL,
              city TEXT NOT NULL
            )
          """,
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<List<Person>> retrieveUsers() async {
    // Query the table for all The Persons.
    final List<Map<String, Object?>> queryResult = await db.query('persons');
    return queryResult.map((e) => Person.fromMap(e)).toList();
  }

  Future<int> insertUser(Person person) async {
    // Insert the person into the correct table.
    // It will return record primary key id
    // on successful record insertion
    int result = await db.insert('persons', person.toMap());
    return result;
  }

  Future<int> deleteUser(int id) async {
    // Remove the Person from the database.
    int result = await db.delete(
      'persons',
      // Use a `where` clause to delete a specific person.
      where: "id = ?",
      // Pass the Person's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
    return result;
  }

  /// Update the user record at [personId] in sql database.
  Future<int> updateUser(Person person, int personId) async {
    // Update the given Person.
    int result = await db.update(
      'persons', person.toMap(),
      // Ensure that the Person has a matching id.
      where: "id=?",
      // Pass the person's id as a whereArg to prevent SQL injection.
      whereArgs: [personId],
    );
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
