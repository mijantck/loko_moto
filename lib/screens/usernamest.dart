import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../services/authservice.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'mainpage.dart';


class UserNamePage extends StatefulWidget {
  @override
  _UserNamePageState createState() => _UserNamePageState();

}

class _UserNamePageState extends State<UserNamePage> {
  TextEditingController _name = TextEditingController();
  String um,uid,una,username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(left: 25.0, right: 25.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter Name ',
                        border: OutlineInputBorder(),
                      ),
                      controller: _name,
                      onChanged: (val) {
                        setState(() {
                          this.username = val;
                        }
                        );
                      },
                    )),

               Container(
                 margin: EdgeInsets.all(10),
                 width: 200.0,
                 height: 45,
                 child:OutlineButton(
                   child: Text('SUBMIT',style :TextStyle(color: Colors.blue)),
                   onPressed: () {

                     if(_name.text.length < 1){

                       Fluttertoast.showToast(
                           msg: "Enter your name",
                           toastLength: Toast.LENGTH_SHORT,
                           gravity: ToastGravity.CENTER,
                           timeInSecForIosWeb: 1,
                           backgroundColor: Colors.red,
                           textColor: Colors.white,
                           fontSize: 16.0
                       );
                       return;
                     }

                     final FirebaseAuth auth = FirebaseAuth.instance;
                     final User user = auth.currentUser;
                     final uid = user.uid;
                     final uphone = user.phoneNumber.toString();


                     DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('users/${uid}');
                     Map userMap = {
                       'fullname': username,
                       'phone': uphone,
                       'imageURI': 'https://i.ibb.co/vvkJF5X/simpline.png',
                     };
                     dbRef.set(userMap);

                     Navigator.pushAndRemoveUntil(
                         context,
                         MaterialPageRoute(builder: (context) => MainPage()),
                             (route) => false);
                     // AuthService().signOut();
                   },
                 ),
               )

              ],
            )


        )
    );
  }
}

void usernameChecker(){

  final FirebaseAuth auth = FirebaseAuth.instance;
  final User user = auth.currentUser;
  String uid = user.uid;
  DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('users/${uid}');
  dbRef.once().then((DataSnapshot snapshot) {
    if(snapshot.value != null){
      return MainPage();
    }else{
      return UserNamePage();
    }
  });
}

