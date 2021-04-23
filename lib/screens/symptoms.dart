import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:patient_logger/helpers/symptom_db.dart';
import 'package:patient_logger/models/symptom_model.dart';
import 'package:patient_logger/screens/symptom_entry.dart';

class Symptoms extends StatefulWidget {
  @override
  _SymptomsState createState() => _SymptomsState();
}

class _SymptomsState extends State<Symptoms> {

  Future<List<SymptomModel>> _symptomList;

  @override
  void initState() {
    super.initState();
    _updateSymptomList();
  }

  _updateSymptomList() {
    setState(() {
      _symptomList = SymptomHelper.instance.getSymptomList();
    });
  }

  Widget _buildSymptom(SymptomModel symptom) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.grey[200],
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("${symptom.name}", style: TextStyle(fontSize: 25.0),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Severity: ", style: TextStyle(fontSize: 18.0),),
                        SizedBox(
                          child: LinearProgressIndicator(
                            value: symptom.severity / 5,
                          ),
                          width: 200.0,
                        ),
                        Text("${symptom.severity.toInt()} / 5", style: TextStyle(fontSize: 18.0),),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Notes:", style: TextStyle(fontSize: 18.0),),
                        Container(
                          child: Text("${symptom.notes}"),
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SYMPTOMS"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SymptomEntry(
                updateSymptomList: _updateSymptomList,
              ),
            ),
          );
        },
      ),
      body: FutureBuilder(
        future: _symptomList,
        builder: (context, snapshot){
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
              return _buildSymptom(snapshot.data[index]);
            },
          );
        },
      ),
    );
  }
}
