import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:note_keeper/models/note.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; //singleton DatabaseHelper
  static Database _database; //singleton Database

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  DatabaseHelper._createInstance();
  //when you use Factory keyword for constructor it allows you to return a value
  factory DatabaseHelper(){
    if (_databaseHelper == null){ //to make sure that singletone creates only onec
      _databaseHelper = DatabaseHelper._createInstance();
    }

    return _databaseHelper; 
  }

  Future<Database> get database async{
    if (_database == null){
        _database = await initializeDatabase();
    }
    return _database;
  }
  //تهيئة للداتا بيز وتحديد المسار متاعها
  Future<Database> initializeDatabase() async {
     Directory directory = await getApplicationDocumentsDirectory();
     var path = directory.path + 'notes.db';

     //open and create database at given path
     var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
     return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, $colDate TEXT)');

  }
  // Fetch operation: get all note objects from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;

    var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }
  Future<int> insertNote (Note note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }
  Future<int> updateNote ( Note note) async {
    var db = await this.database;
    var result = await db.update(noteTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }
   Future<int> deleteNote(int id) async {
     Note note;
     var db = await this.database;
     int result = await db.delete(noteTable, where: '$colId = id');
     return result;
   }
   Future<int> getCount() async{
     Database db = await this.database;
     List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) From $noteTable');
     int result = Sqflite.firstIntValue(x);
     return result;
   } 
    Future<List<Note>> getNoteList() async {
      var noteMapList = await getNoteMapList();
      int count = noteMapList.length;
       List<Note> noteList = List<Note>();
       for (int i = 0; i < count; i ++){
         noteList.add(Note.fromMapObject(noteMapList[i]));
       }
       return noteList;
    }
}