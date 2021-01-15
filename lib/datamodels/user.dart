import 'package:firebase_database/firebase_database.dart';
import 'package:loko_moto/datamodels/user.dart';
class Users{
  String fullName;
  String imageURL;
  String email;
  String phone;
  String id;

  Users({
    this.email,
    this.imageURL,
    this.fullName,
    this.phone,
    this.id,
  });

  Users.fromSnapshot(DataSnapshot snapshot){
    id = snapshot.key;
    phone = snapshot.value['phone'];
    fullName = snapshot.value['fullname'];
    imageURL = snapshot.value['imageURI'];
  }

}