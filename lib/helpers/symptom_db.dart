import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:patient_logger/models/symptom_model.dart';

class SymptomHelper {

  static final SymptomHelper instance = SymptomHelper._instance();
  static Database _symptomDB;

  SymptomHelper._instance();

  String symptomTable = 'symptom_table';
  String idCol = 'id';
  String nameCol = 'name';
  String severityCol = 'severity';
  String notesCol = 'notes';

  Future<Database> get db async {
    if (_symptomDB == null) {
      _symptomDB = await _initSymptomDB();
    } return _symptomDB;
  }

  Future<Database> _initSymptomDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'symptom.db';
    final symptomDB = await openDatabase(path, version: 1, onCreate: _createSymptomDB);
    return symptomDB;
  }

  void _createSymptomDB(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $symptomTable($idCol INTEGER PRIMARY KEY AUTOINCREMENT, $nameCol TEXT, $severityCol DOUBLE, $notesCol TEXT)',
    );
  }

  Future<List<Map<String, dynamic>>> getSymptomMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(symptomTable);
    return result;
  }

  Future<List<SymptomModel>> getSymptomList() async {
    final List<Map<String, dynamic>> symptomMapList = await getSymptomMapList();

    final List<SymptomModel> symptomList = [];
    symptomMapList.forEach((symptomMap) {
      symptomList.add(SymptomModel.fromMap(symptomMap));
    });

    // symptomList.sort((a, b) => b.date.compareTo(a.date));
    return symptomList;
  }

  Future<int> insertSymptom(SymptomModel symptom) async {
    Database db = await this.db;
    final int result = await db.insert(symptomTable, symptom.toMap());
    return result;
  }

  Future<int> updateSymptom(SymptomModel symptom) async {
    Database db = await this.db;
    final int result = await db.update(
      symptomTable,
      symptom.toMap(),
      where: '$idCol = ?',
      whereArgs: [symptom.id],
    ); return result;
  }

  Future<int> deleteSymptom(int id) async {
    Database db =  await this.db;
    final int result = await db.delete(
      symptomTable,
      where: '$idCol = ?',
      whereArgs: [id],
    ); return result;
  }

}