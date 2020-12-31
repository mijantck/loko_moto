import 'package:flutter/material.dart';
import 'package:loko_moto/screens/mainpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'dart:async';
import 'dart:io' show Platform;

import 'package:loko_moto/services/authservice.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
    name: 'db2',
    options: Platform.isIOS
        ? FirebaseOptions(
      appId: '1:850491199363:ios:f5d92c5f353a85d92eb0b6',
      apiKey: 'AIzaSyDroiqvQRcGrKgYwT5TjKSxyUsPFTV9mN0',
      projectId: 'flutter-firebase-plugins',
      messagingSenderId: '850491199363',
      databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
    )
        : FirebaseOptions(
      appId: '1:850491199363:android:944c5f114c1ee6a42eb0b6',
      apiKey: 'AIzaSyAeBwhCv9Uo1NkgAV0jMtrbxKOK6Jix7fc',
      messagingSenderId: '297855924061',
      projectId: 'flutter-firebase-plugins',
      databaseURL: 'https://lokomoto-c7830-default-rtdb.firebaseio.com',
    ),
  );
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthService().handleAuth(),
    );
  }
}

