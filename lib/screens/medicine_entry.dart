import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:patient_logger/helpers/medicine_db.dart';
import 'package:patient_logger/models/medicine_model.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:weekday_selector_formfield/weekday_selector_formfield.dart';

// MISSING: REMINDER FUNCTION (FREQUENCY OF INGESTION)

class MedicineEntry extends StatefulWidget {

  final Function updateMedicineList;
  final MedicineModel medicine;
  MedicineEntry({this.updateMedicineList, this.medicine});

  @override
  _MedicineEntryState createState() => _MedicineEntryState();
}

class _MedicineEntryState extends State<MedicineEntry> {

  final _formKey = GlobalKey<FormState>();
  final values = List.filled(7, false);

  String _name = "";
  int _totalDoses = 1;
  int _doseCounter = 0;
  String _days;
  TimeOfDay _time = TimeOfDay.now();

  Future<Null> selectTime(BuildContext context) async {
    _time = await showTimePicker(
        context: context,
        initialTime: _time,
    );
  }

  @override
  void initState() {
    super.initState();

    if (widget.medicine != null) {
      _name = widget.medicine.name;
      _totalDoses = widget.medicine.totalDoses;
      _doseCounter = widget.medicine.doseCounter;
      _days = widget.medicine.days;
      _time = widget.medicine.time as TimeOfDay; // need to switch to "X:XX XM" form
    }
  }

  delete() {
    MedicineHelper.instance.deleteMedicine(widget.medicine.id);
    widget.updateMedicineList();
  }

  _submit() {

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print("$_name, $_totalDoses, $_doseCounter, $_days, $_time");
    }

    MedicineModel medicine = MedicineModel(_name, _totalDoses, _doseCounter, _days, _time.toString());
    if (widget.medicine == null) {
      MedicineHelper.instance.insertMedicine(medicine);
    }

    widget.updateMedicineList();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MEDICATION ENTRY"),
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
                      labelText: 'Medication Name',
                    ),
                    validator: (input) => input.trim().isEmpty ? "Please Enter a Name" : null,
                    onSaved: (input) => _name = input,
                    initialValue: _name,
                  ),
                ),
                Text(
                  "Enter Total Number of Doses",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
                NumberPicker(
                  value: _totalDoses.toInt(),
                  minValue: 1,
                  maxValue: 100,
                  onChanged: (value) => setState(() => _totalDoses = value),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black26),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Select Days of Week",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                WeekDaySelectorFormField(
                  validator: (input) => input.isEmpty ? "Please Select Days of Week" : null,
                  displayDays: [days.sunday, days.monday, days.tuesday, days.wednesday, days.thursday, days.friday, days.saturday],
                  initialValue: [],
                  borderRadius: 20,
                  selectedFillColor: Colors.lightBlueAccent,
                  borderSide: BorderSide(color: Colors.blue[900], width: 2),
                  onChange: (days) {
                    String sum = "";
                    String letter;
                    for (var day in days) {
                      if (day.toString() == "days.thursday") {
                        letter = day.toString().substring(8, 9).toUpperCase();
                      } else {
                        letter = day.toString().substring(5, 6).toUpperCase();
                      }
                      sum += letter;
                    }
                    _days = sum;

                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Tap Clock Icon to Set Time",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.alarm_add),
                  onPressed: () {
                    selectTime(context);
                  }
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
                      "Add to Medications",
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