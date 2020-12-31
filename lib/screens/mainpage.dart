import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main page"),),
      body: Center(
        child: MaterialButton(
          onPressed: (){

            DatabaseReference dbref = FirebaseDatabase.instance.reference().child("test");
            dbref.set("hghjghjgh");

          },
          height: 50,
          minWidth: 350,
          color: Colors.blue,
          child: Text("Test Button"),
        ),
      ),
    );
  }
}
