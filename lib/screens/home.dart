import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PATIENT LOGGER"),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Text(
            "SAN FRANCISCO, CA: 48°F",
            textAlign: TextAlign.center,
            ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_chart),
        onPressed: () {
          Navigator.pushNamed(context, '/graphs');
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: Icon(Icons.book),
              label: Text("DIARY"),
              onPressed: () {
                Navigator.pushNamed(context, '/diary');
              },
            ),
            TextButton.icon(
              icon: Icon(Icons.medical_services),
              label: Text("MEDICINE"),
              onPressed: () {
                Navigator.pushNamed(context, '/medicine');
              },
            ),
            TextButton.icon(
              icon: Icon(Icons.healing),
              label: Text("SYMPTOMS"),
              onPressed: () {
                Navigator.pushNamed(context, '/symptoms');
              },
            ),
          ],
        ),
      ),
    );
  }
}