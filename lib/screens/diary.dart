import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:patient_logger/helpers/diary_db.dart';
import 'package:patient_logger/models/diary_model.dart';
import 'package:patient_logger/screens/diary_entry.dart';

class Diary extends StatefulWidget {
  @override
  _DiaryState createState() => _DiaryState();
}

class _DiaryState extends State<Diary> {

  Future<List<DiaryModel>> _diaryList;
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _updateDiaryList();
  }

  _updateDiaryList() {
    setState(() {
      _diaryList = DiaryHelper.instance.getDiaryList();
    });
  }

  Widget _buildDiary(DiaryModel diary) {
    return Container(
      margin: EdgeInsets.all(15.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        )
      ),
      child: ListTile(
        leading: Icon(Icons.bookmark),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("${_dateFormatter.format(diary.date)}"),
        ),
        subtitle: Text("${diary.entry}"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DIARY"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DiaryEntry(
                updateDiaryList: _updateDiaryList,
              ),
            ),
          );
        },
      ),
      body: FutureBuilder(
        future: _diaryList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text(
                "Tap Plus Button to Add an Entry",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 20.0,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildDiary(snapshot.data[index]);
            },
          );
        },
      ),
    );
  }
}
