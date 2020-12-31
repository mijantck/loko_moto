import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loko_moto/widget/country_picker.dart';


import 'otp.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _controller = TextEditingController();
  var _dialCode = '';

  void _callBackFunction(String name, String dialCode, String flag) {
    _dialCode = dialCode;
  }

  //Alert dialogue to show error and response
  void showErrorDialog(BuildContext context, String message) {
    // set up the AlertDialog
    final CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const Text('Error'),
      content: Text('\n$message'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Yes'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Auth'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            Container(
              margin: EdgeInsets.only(top: 60),
              child: Center(
                child: Text(
                  'Phone Authentication',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                ),
              ),
            ),


            Container(
              margin: EdgeInsets.only(top: 40, right: 10, left: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  prefix: Padding(
                    padding: EdgeInsets.all(4),
                    child:CountryPicker(
                      callBackFunction: _callBackFunction,
                      headerText: 'Select Country',
                      headerBackgroundColor: Theme.of(context).primaryColor,
                      headerTextColor: Colors.white,
                    ),
                  ),
                ),
                maxLength: 10,
                keyboardType: TextInputType.number,
                controller: _controller,
              ),

            )
          ]),
          Container(
            margin: EdgeInsets.all(10),
            width: double.infinity,
            child:
            FlatButton(
              color: Colors.blue,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OTPScreen(_dialCode+''+_controller.text)));
              },
              child: Text(
                'Next',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}