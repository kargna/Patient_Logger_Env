import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:patient_logger/models/medicine_model.dart';

class MedicineHelper {

  static final MedicineHelper instance = MedicineHelper._instance();
  static Database _medicineDB;

  MedicineHelper._instance();

  String medicineTable = 'medicine_table';
  String idCol = 'id';
  String nameCol = 'name';
  String totalDosesCol = 'total_doses';
  String doseCounterCol = 'dose_counter';
  String daysCol = 'days';
  String timeCol = 'time';


  Future<Database> get db async {
    if (_medicineDB == null) {
      _medicineDB = await _initMedicineDB();
    } return _medicineDB;
  }

  Future<Database> _initMedicineDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'medicine.db';
    final medicineDB = await openDatabase(path, version: 1, onCreate: _createMedicineDB);
    return medicineDB;
  }

  void _createMedicineDB(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $medicineTable($idCol INTEGER PRIMARY KEY AUTOINCREMENT, $nameCol TEXT, $totalDosesCol INTEGER, $doseCounterCol INTEGER, $daysCol TEXT, $timeCol TEXT)',
    );
  }

  Future<List<Map<String, dynamic>>> getMedicineMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(medicineTable);
    return result;
  }

  Future<List<MedicineModel>> getMedicineList() async {
    final List<Map<String, dynamic>> medicineMapList = await getMedicineMapList();

    final List<MedicineModel> medicineList = [];
    medicineMapList.forEach((medicineMap) {
      medicineList.add(MedicineModel.fromMap(medicineMap));
    });

    // medicineList.sort((a, b) => b.date.compareTo(a.date));
    return medicineList;
  }

  Future<int> insertMedicine(MedicineModel medicine) async {
    Database db = await this.db;
    final int result = await db.insert(medicineTable, medicine.toMap());
    return result;
  }

  Future<int> updateMedicine(MedicineModel medicine) async {
    Database db = await this.db;
    final int result = await db.update(
      medicineTable,
      medicine.toMap(),
      where: '$idCol = ?',
      whereArgs: [medicine.id],
    ); return result;
  }

  Future<int> deleteMedicine(int id) async {
    Database db =  await this.db;
    final int result = await db.delete(
      medicineTable,
      where: '$idCol = ?',
      whereArgs: [id],
    ); return result;
  }

}