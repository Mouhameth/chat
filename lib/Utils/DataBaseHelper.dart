import 'dart:io';
import 'package:chat/models/Contact.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  Database _database;

  Future<Database> get database async {
    if (_database == null) {
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      String dbpath = join(documentDirectory.path, "chat.db");
      return openDatabase(dbpath, version: 1,
          onCreate: (Database db, int version) async {
        db.execute("CREATE TABLE User (email TEXT,optionVu TEXT,userName TEXT)");
      });
    }
    return _database;
  }

  Future<int> insertUser(Contact contact) async {
    var client = await database;
    return client.insert("User", contact.ContactToMap());
  }
  
  Future<List<Contact>> getUser() async {
    var client = await database;
    final List<Map<String, dynamic>> maps = await client.query('User');
    List<Contact> list = List();
    maps.forEach((element) {
      Contact contact = Contact.fromMap(element);
      list.add(contact);
    });
    return list;
  }
   Future<int> delete(String email) async {
     var client = await database;
    return await client.delete("User", where: 'email = ?', whereArgs: [email]);
  }

  Future<int> update(Contact contact) async {
    var client = await database;
    return await client.update("User", contact.ContactToMap(),
        where: 'email = ?', whereArgs: [contact.email]);
  }
  
}