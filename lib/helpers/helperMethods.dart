import 'package:connectivity/connectivity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loko_moto/dataProvider/appData.dart';
import 'package:loko_moto/datamodels/address.dart';
import 'package:loko_moto/globalvariable.dart';
import 'package:loko_moto/helpers/requesthelper.dart';
import 'package:provider/provider.dart';

class HelperMethods{
 static Future<String> findCordinateAddress(Position position, context) async{

   String placeAddress = '';

   var connectivityResult = await Connectivity().checkConnectivity();
   if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi){
     return placeAddress;
   }
   String  url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapkey';
 //  String  url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&key=$mapkey';

   var response = await RequestHelper.getRequest(url);
   if(response != 'failed'){
     placeAddress = response['results'][0]['formatted_address'];
    // placeAddress = response['plus_code']['compound_code'];
     Address pickupAddress = new Address();
     pickupAddress.longitude = position.longitude;
     pickupAddress.latitude = position.latitude;
     pickupAddress.placeName = placeAddress;
     Provider.of <AppData>(context , listen: false).updatePicukAddress(pickupAddress);
   }else{
     print("faild");
   }
   return placeAddress;
 }
}