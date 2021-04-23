import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:patient_logger/helpers/symptom_db.dart';
import 'package:patient_logger/models/symptom_model.dart';

class SymptomEntry extends StatefulWidget {

  final Function updateSymptomList;
  final SymptomModel symptom;
  SymptomEntry({this.updateSymptomList, this.symptom});

  @override
  _SymptomEntryState createState() => _SymptomEntryState();
}

class _SymptomEntryState extends State<SymptomEntry> {

  final _formKey = GlobalKey<FormState>();
  String _name = "";
  double _severity = 3.0;
  String _notes = "";

  @override
  void initState() {
    super.initState();

    if (widget.symptom != null) {
      _name = widget.symptom.name;
      _severity = widget.symptom.severity;
      _notes = widget.symptom.notes;
    }
  }

  _delete() {
    SymptomHelper.instance.deleteSymptom(widget.symptom.id);
    widget.updateSymptomList();
  }

  _submit() {

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print("$_name, $_severity, $_notes");
    }

    SymptomModel diary = SymptomModel(_name, _severity, _notes);
    if (widget.symptom == null) {
      SymptomHelper.instance.insertSymptom(diary);
    }

    widget.updateSymptomList();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SYMPTOM ENTRY"),
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
                      labelText: 'Symptom Name',
                    ),
                    validator: (input) => input.trim().isEmpty ? "Please Enter a Name" : null,
                    onSaved: (input) => _name = input,
                    initialValue: _name,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Text(
                        "Severity:",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Icon(Icons.thumb_up),
                    Slider(
                      value: _severity,
                      min: 1.0,
                      max: 5.0,
                      divisions: 4,
                      label: "$_severity",
                      onChanged: (val) {
                        setState(() {
                          _severity = val;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.thumb_down),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: TextFormField(
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: 'Notes',
                    ),
                    onSaved: (input) => _notes = input,
                    initialValue: _notes,
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
                      "Add to Symptoms",
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
