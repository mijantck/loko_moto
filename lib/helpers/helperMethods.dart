import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loko_moto/dataProvider/appData.dart';
import 'package:loko_moto/datamodels/address.dart';
import 'package:loko_moto/datamodels/directiondetails.dart';
import 'package:loko_moto/globalvariable.dart';
import 'package:loko_moto/helpers/requesthelper.dart';
import 'package:provider/provider.dart';
import 'package:loko_moto/datamodels/user.dart';

class HelperMethods{

  static void getCurrentUserInfo() async{

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    String userid = user.uid;

    DatabaseReference userRef = FirebaseDatabase.instance.reference().child('users/$userid');
    userRef.once().then((DataSnapshot snapshot){

      if(snapshot.value != null){
        currentUserInfos = Users.fromSnapshot(snapshot);
        print('my name is ${currentUserInfos.fullName}');
      }

    });
  }

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

 static Future<DirectionDetails> getDirectionDetails(LatLng startPosition, LatLng endPosition) async {

   String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$mapkey';

   var response = await RequestHelper.getRequest(url);

   if(response == 'failed'){
     return null;
   }

   DirectionDetails directionDetails = DirectionDetails();

   directionDetails.durationText = response['routes'][0]['legs'][0]['duration']['text'];
   directionDetails.durationValue = response['routes'][0]['legs'][0]['duration']['value'];

   directionDetails.distanceText = response['routes'][0]['legs'][0]['distance']['text'];
   directionDetails.distanceValue = response['routes'][0]['legs'][0]['distance']['value'];

   directionDetails.encodedPoints = response['routes'][0]['overview_polyline']['points'];

   return directionDetails;
 }

 static int estimateFares (DirectionDetails details){
   // per km = $0.3,
   // per minute = $0.2,
   // base fare = $3,

   double baseFare = 3;
   double distanceFare = (details.distanceValue/1000) * 0.3;
   double timeFare = (details.durationValue / 60) * 0.2;

   double totalFare = baseFare + distanceFare + timeFare;

   return totalFare.truncate();
 }

}