import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserInfo{

  static  String ridername() {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User user = auth.currentUser;
      final uid = user.uid;
      String name ='';
      String phone ='';
      DatabaseReference userRef = FirebaseDatabase.instance.reference().child('users/$uid');

      userRef.once().then((DataSnapshot snapshot){
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key,values) {
          name = values["fullname"];
          print(values["fullname"]);
        });
      });
      // function definition
      return name;
    }
  static  String riderphone() {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User user = auth.currentUser;
      final uid = user.uid;


      String name ='';
      String phone ='';

      DatabaseReference userRef = FirebaseDatabase.instance.reference().child('users/$uid');

      userRef.once().then((DataSnapshot snapshot){
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key,values) {
          phone = values["phone"];
          print(values["phone"]);
        });
      });
      // function definition
      return phone;
    }
}