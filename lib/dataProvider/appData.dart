import 'package:flutter/cupertino.dart';
import 'package:loko_moto/datamodels/address.dart';

class AppData extends ChangeNotifier {
  Address picukAddress;
  Address destinationkAddress;

  void updatePicukAddress(Address pickup){
    picukAddress = pickup;
    notifyListeners();
  }
  void updateDestinationAddress(Address destination){
    destinationkAddress = destination;
    notifyListeners();
  }

}