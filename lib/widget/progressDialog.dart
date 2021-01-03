import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';




class ProgressDialog extends StatelessWidget {

  final String stutas;
  ProgressDialog({this.stutas});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)),
        backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(16.0),
        width:  double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4)
        ),
        child: Padding(
          padding: EdgeInsets.all(17.0),
          child: Row(
            children: <Widget> [
              SizedBox(width: 5.0),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color> (Colors.blue),),
              SizedBox(width: 3.0),
              Text(stutas,style: TextStyle(fontSize: 20),)
            ],
          ),

        ),
      ),
    );
  }
}
