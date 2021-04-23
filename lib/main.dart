import 'package:flutter/material.dart';
import 'package:patient_logger/screens/home.dart';
import 'package:patient_logger/screens/graphs.dart';
import 'package:patient_logger/screens/diary.dart';
import 'package:patient_logger/screens/diary_entry.dart';
import 'package:patient_logger/screens/medicine.dart';
import 'package:patient_logger/screens/medicine_entry.dart';
import 'package:patient_logger/screens/symptoms.dart';
import 'package:patient_logger/screens/symptom_entry.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  routes: {
    '/': (context) => Home(),
    '/home': (context) => Home(),
    '/graphs': (context) => Graph(),
    '/diary': (context) => Diary(),
    '/diary_entry': (context) => DiaryEntry(),
    '/medicine': (context) => Medicine(),
    '/medicine_entry': (context) => MedicineEntry(),
    '/symptoms': (context) => Symptoms(),
    '/symptom_entry': (context) => SymptomEntry(),
  },
));