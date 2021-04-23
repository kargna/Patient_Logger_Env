import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:patient_logger/models/diary_model.dart';

class DiaryHelper {

  static final DiaryHelper instance = DiaryHelper._instance();
  static Database _diaryDB;

  DiaryHelper._instance();

  String diaryTable = 'diary_table';
  String idCol = 'id';
  String dateCol = 'date';
  String entryCol = 'entry';

  Future<Database> get db async {
    if (_diaryDB == null) {
      _diaryDB = await _initDiaryDB();
    } return _diaryDB;
  }

  Future<Database> _initDiaryDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'diary.db';
    final diaryDB = await openDatabase(path, version: 1, onCreate: _createDiaryDB);
    return diaryDB;
  }

  void _createDiaryDB(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $diaryTable($idCol INTEGER PRIMARY KEY AUTOINCREMENT, $dateCol TEXT, $entryCol TEXT)',
    );
  }

  Future<List<Map<String, dynamic>>> getDiaryMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(diaryTable);
    return result;
  }

  Future<List<DiaryModel>> getDiaryList() async {
    final List<Map<String, dynamic>> diaryMapList = await getDiaryMapList();

    final List<DiaryModel> diaryList = [];
    diaryMapList.forEach((diaryMap) {
      diaryList.add(DiaryModel.fromMap(diaryMap));
    });

    diaryList.sort((a, b) => b.date.compareTo(a.date));
    return diaryList;
  }

  Future<int> insertDiary(DiaryModel diary) async {
    Database db = await this.db;
    final int result = await db.insert(diaryTable, diary.toMap());
    return result;
  }

  Future<int> updateDiary(DiaryModel diary) async {
    Database db = await this.db;
    final int result = await db.update(
      diaryTable,
      diary.toMap(),
      where: '$idCol = ?',
      whereArgs: [diary.id],
    ); return result;
  }
  
  Future<int> deleteDiary(int id) async {
    Database db =  await this.db;
    final int result = await db.delete(
      diaryTable,
      where: '$idCol = ?',
      whereArgs: [id],
    ); return result;
  }

}