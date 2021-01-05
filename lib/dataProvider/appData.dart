import 'package:flutter/cupertino.dart';
import 'package:loko_moto/datamodels/address.dart';

class AppData extends ChangeNotifier {
  Address picukAddress;

  void updatePicukAddress(Address pickup){
    picukAddress = pickup;
    notifyListeners();
  }

}