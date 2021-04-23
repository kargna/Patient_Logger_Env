import 'package:flutter/material.dart';
import 'dart:async';
import 'package:patient_logger/helpers/medicine_db.dart';
import 'package:patient_logger/models/medicine_model.dart';
import 'package:patient_logger/screens/medicine_entry.dart';

class Medicine extends StatefulWidget {

  @override
  _MedicineState createState() => _MedicineState();
}

class _MedicineState extends State<Medicine> {

  Future<List<MedicineModel>> _medicineList;

  @override
  void initState() {
    super.initState();
    _updateMedicineList();
  }

  _updateMedicineList() {
    setState(() {
      _medicineList = MedicineHelper.instance.getMedicineList();
    });
  }

  Widget _buildMedicine(MedicineModel medicine) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.grey[200],
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("${medicine.name}", style: TextStyle(fontSize: 25.0),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Progress:"),
                      SizedBox(
                        child: LinearProgressIndicator(
                          value: medicine.doseCounter.toDouble() / medicine.totalDoses,
                        ),
                        width: 200.0,
                      ),
                      ElevatedButton(
                        child: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            medicine.doseCounter++;
                          });
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Reminder:"),
                      Text("${medicine.days} @ ${medicine.time.toString().substring(10, 15)}"),
                    ],
                  ),
                  SizedBox(height: 15.0)
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
        title: Text("MEDICINE"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MedicineEntry(
                updateMedicineList: _updateMedicineList,
              ),
            ),
          );
        },
      ),
      body: FutureBuilder(
        future: _medicineList,
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
              return _buildMedicine(snapshot.data[index]);
            },
          );
        },
      ),
    );
  }
}
