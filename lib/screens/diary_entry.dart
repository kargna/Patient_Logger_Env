import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:patient_logger/helpers/diary_db.dart';
import 'package:patient_logger/models/diary_model.dart';

class DiaryEntry extends StatefulWidget {

  final Function updateDiaryList;
  final DiaryModel diary;
  DiaryEntry({this.updateDiaryList, this.diary});

  @override
  _DiaryEntryState createState() => _DiaryEntryState();
}

class _DiaryEntryState extends State<DiaryEntry> {

  final _formKey = GlobalKey<FormState>();
  DateTime _date = DateTime.now();
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');
  String _entry = "";

  @override
  void initState() {
    super.initState();

    if (widget.diary != null) {
      _date = widget.diary.date;
      _entry = widget.diary.entry;
    }
  }

  _delete() {
    DiaryHelper.instance.deleteDiary(widget.diary.id);
    widget.updateDiaryList();
  }

  _submit() {

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print("$_entry, ${_dateFormatter.format(_date)}");
    }

    DiaryModel diary = DiaryModel(_date, _entry);
    if (widget.diary == null) {
      DiaryHelper.instance.insertDiary(diary);
    }

    widget.updateDiaryList();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DIARY ENTRY"),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: TextFormField(
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: 'How Do You Feel Today?',
                    ),
                    validator: (input) => input.trim().isEmpty ? "Please Enter an Entry" : null,
                    onSaved: (input) => _entry = input,
                    initialValue: _entry,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 25.0),
                  height: 60.0,
                  width: 180.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.blue
                  ),
                  child: TextButton(
                    onPressed: _submit,
                    child: Text(
                      "Add to Diary",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
