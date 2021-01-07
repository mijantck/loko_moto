import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loko_moto/dataProvider/appData.dart';
import 'package:loko_moto/datamodels/directiondetails.dart';
import 'package:loko_moto/helpers/helperMethods.dart';
import 'package:loko_moto/screens/searchpage.dart';
import 'package:loko_moto/style/styles.dart';
import 'package:loko_moto/widget/BrandDivider.dart';
import 'package:loko_moto/widget/TaxiButton.dart';
import 'package:loko_moto/widget/progressDialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:brand_colors/brand_colors.dart';
import 'dart:io';
import 'package:loko_moto/datamodels/user.dart';
import 'package:provider/provider.dart';
import '../globalvariable.dart';





class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {

  var scaffoldKey = GlobalKey<ScaffoldState>();


  double searchSheetHight =(Platform.isIOS) ? 300 : 275;
  double rideDetailsSheetHeight = 0;
  double requestingSheetHeight = 0; // (Platform.isAndroid) ? 195 : 220


  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  double mapBottomPadding = 0;

  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = {};
  Set<Marker> _Markers = {};
  Set<Circle> _Circles = {};

  var geoLocatior = Geolocator();
  Position currentPosition;
  DirectionDetails tripDirectionDetails;

  bool drawerCanOpen = true;

  DatabaseReference rideRef;


  void setUpLoaction() async {
    Position position = await geoLocatior.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;

    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = new CameraPosition(target: pos, zoom: 14);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));

    print('${position.latitude} mm ${position.longitude}');
    String address = await HelperMethods.findCordinateAddress(position,context);

   // print(address);
  }


  void showDetailSheet () async {
    await getDirection();

    setState(() {
      searchSheetHight = 0;
      mapBottomPadding = (Platform.isAndroid) ? 240 : 230;
      rideDetailsSheetHeight = (Platform.isAndroid) ? 235 : 260;
      drawerCanOpen = false;
    });
  }
  void showRequestingSheet(){
    setState(() {
      rideDetailsSheetHeight = 0;
      requestingSheetHeight = (Platform.isAndroid) ? 195 : 220;
      mapBottomPadding = (Platform.isAndroid) ? 200 : 190;
      drawerCanOpen = true;
    });
    createRideRequest();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('mijan');
    HelperMethods.getCurrentUserInfo();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      body: Stack(

        children: <Widget> [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapBottomPadding),
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: GooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            polylines: _polylines,
            markers: _Markers,
            circles: _Circles,
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);
              mapController = controller;

              setState(() {
                mapBottomPadding = (Platform.isAndroid) ? 280 : 270;
              });
               setUpLoaction();
            }
            ),

          //menuCheet
          Positioned(
              top: 44,
              left: 20,


              child: GestureDetector(
                onTap: (){
                  if(drawerCanOpen){
                    scaffoldKey.currentState.openDrawer();
                  }
                  else{
                    resetApp();
                  }
                },
                child:  Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5.0,
                            spreadRadius: 0.5,
                            offset: Offset(
                              0.7,
                              0.7,
                            )
                        )
                      ]
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Icon((drawerCanOpen) ? Icons.menu : Icons.arrow_back, color: Colors.black87,),

                  ),
                ) ,
              )
          ),
        //searchCheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
               vsync: this,
               duration: new Duration(milliseconds: 150),
               curve: Curves.easeIn,
              child:  Container(
                  height: searchSheetHight,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15),),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 15.0,
                            spreadRadius: 0.5,
                            offset: Offset(
                                0.7,
                                0.7
                            )
                        )
                      ]
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24,vertical: 18),
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget> [
                        SizedBox(height: 5,),

                        Text('Nice to see you',style: TextStyle(fontSize: 10),),

                        Text('Where are you going',style: TextStyle(fontSize: 18,),),

                        SizedBox(height: 10,),

                        GestureDetector(
                          onTap: () async {

                            var response = await  Navigator.push(context, MaterialPageRoute(
                                builder: (context)=> SearchPage()
                            ));

                            if(response == 'getDirection'){

                             showDetailSheet();
                            }

                          },
                          child:Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5.0,
                                      spreadRadius: 0.5,
                                      offset: Offset(
                                          0.7,
                                          0.7
                                      )
                                  )
                                  ]
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child:  Row(
                                  children: <Widget> [
                                    Icon(Icons.search,color: Colors.blueAccent,),
                                    Text('Search Destination',),

                                  ],
                                ),
                              )
                          ),
                        ),


                        SizedBox(height: 10,),

                        Row(
                          children: [
                            Icon(OMIcons.home,color: Colors.black26,),
                            SizedBox(width: 12,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Add Home'),
                                SizedBox(height: 3,),
                                Text('Your residential address',style: TextStyle(fontSize: 11, color: BrandColors.appleBlack),)
                              ],
                            )
                          ],
                        ),

                        SizedBox(height: 5,),
                        BrandDivider(),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(OMIcons.workOutline,color: Colors.black26,),
                            SizedBox(width: 12,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Add Work'),
                                SizedBox(height: 3,),
                                Text('Your Office address',style: TextStyle(fontSize: 11, color: BrandColors.appleBlack),)
                              ],
                            )
                          ],
                        )

                      ],
                    ),

                  )
              ),
    ),
          ),
          /// RideDetails Sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              vsync: this,
              duration: new Duration(milliseconds: 150),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15.0, // soften the shadow
                      spreadRadius: 0.5, //extend the shadow
                      offset: Offset(
                        0.7, // Move to right 10  horizontally
                        0.7, // Move to bottom 10 Vertically
                      ),
                    )
                  ],

                ),
                height: rideDetailsSheetHeight,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Column(
                    children: <Widget>[

                      Container(
                        width: double.infinity,
                        color: Colors.black12,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: <Widget>[
                              Image.asset('assets/images/taxi.png', height: 70, width: 70,),
                              SizedBox(width: 16,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Taxi', style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),),
                                  Text((tripDirectionDetails != null) ? tripDirectionDetails.distanceText : '', style: TextStyle(fontSize: 16, color: Colors.lightBlueAccent),)

                                ],
                              ),
                              Expanded(child: Container()),
                              Text((tripDirectionDetails != null) ? '\$${HelperMethods.estimateFares(tripDirectionDetails)}' : '', style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),),

                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 22,),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: <Widget>[

                            Icon(FontAwesomeIcons.moneyBillAlt, size: 18, color: Colors.lightBlueAccent,),
                            SizedBox(width: 16,),
                            Text('Cash'),
                            SizedBox(width: 5,),
                            Icon(Icons.keyboard_arrow_down, color: Colors.amberAccent, size: 16,),
                          ],
                        ),
                      ),

                      SizedBox(height: 22,),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: TaxiButton(
                          title: 'REQUEST CAB',
                          color: Colors.greenAccent,
                          onPressed: (){
                            showRequestingSheet();
                          },
                        ),
                      )

                    ],
                  ),
                ),
              ),
            ),
          ),
          /// Request Sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              vsync: this,
              duration: new Duration(milliseconds: 150),
              curve: Curves.easeIn,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15.0, // soften the shadow
                      spreadRadius: 0.5, //extend the shadow
                      offset: Offset(
                        0.7, // Move to right 10  horizontally
                        0.7, // Move to bottom 10 Vertically
                      ),
                    )
                  ],
                ),
                height: requestingSheetHeight,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      SizedBox(height: 10,),

                      SizedBox(
                        width: double.infinity,
                        child: TextLiquidFill(
                          text: 'Requesting a Ride...',
                          waveColor: BrandColors.tacoBellBlack,
                          boxBackgroundColor: Colors.white,
                          textStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 22.0,
                              fontFamily: 'Brand-Bold'
                          ),
                          boxHeight: 40.0,
                        ),
                      ),

                      SizedBox(height: 20,),

                      GestureDetector(
                        onTap: (){
                          cancelRequest();
                          resetApp();
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(width: 1.0, color: Colors.grey),

                          ),
                          child: Icon(Icons.close, size: 25,),
                        ),
                      ),

                      SizedBox(height: 10,),

                      Container(
                        width: double.infinity,
                        child: Text(
                          'Cancel ride',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),


                    ],
                  ),
                ),
              ),
            ),
          ),


        ],
      ),
      drawer:Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Row(
                children: [
                  Image.asset('assets/images/profile.png',height: 60,width: 60,),
                  SizedBox(width: 10,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('User name ', style: TextStyle(fontSize: 20),),
                      SizedBox(height: 5,),
                      Text('View profile'),
                    ],
                  )
                ],
              ),
            ),
            ListTile(
              leading: Icon(OMIcons.cardGiftcard),
              title: Text('Free Rides',style: KdowerItemStyle,),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: Icon(OMIcons.payment),
              title: Text('Payments',style: KdowerItemStyle,),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: Icon(OMIcons.history),
              title: Text('Rides History ',style: KdowerItemStyle,),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: Icon(OMIcons.contactSupport),
              title: Text('Support',style: KdowerItemStyle,),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: Icon(OMIcons.info),
              title: Text('About',style: KdowerItemStyle,),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),

    );

  }

  Future<void> getDirection() async {

    var pickup = Provider.of<AppData>(context, listen: false).picukAddress;
    var destination =  Provider.of<AppData>(context, listen: false).destinationkAddress;

    var pickLatLng = LatLng(pickup.latitude, pickup.longitude);
    var destinationLatLng = LatLng(destination.latitude, destination.longitude);

    var thisDetails = await HelperMethods.getDirectionDetails(pickLatLng, destinationLatLng);

    setState(() {
      tripDirectionDetails = thisDetails;
    });

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results = polylinePoints.decodePolyline(thisDetails.encodedPoints);

    polylineCoordinates.clear();
    if(results.isNotEmpty){
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      results.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId('polyid'),
        color: Color.fromARGB(255, 95, 109, 237),
        points: polylineCoordinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      _polylines.add(polyline);

    });

    LatLngBounds bounds;

    if(pickLatLng.latitude > destinationLatLng.latitude && pickLatLng.longitude > destinationLatLng.longitude){
      bounds = LatLngBounds(southwest: destinationLatLng, northeast: pickLatLng);
    }
    else if(pickLatLng.longitude > destinationLatLng.longitude){
      bounds = LatLngBounds(
          southwest: LatLng(pickLatLng.latitude, destinationLatLng.longitude),
          northeast: LatLng(destinationLatLng.latitude, pickLatLng.longitude)
      );
    }
    else if(pickLatLng.latitude > destinationLatLng.latitude){
      bounds = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, pickLatLng.longitude),
        northeast: LatLng(pickLatLng.latitude, destinationLatLng.longitude),
      );
    }
    else{
      bounds = LatLngBounds(southwest: pickLatLng, northeast: destinationLatLng);
    }

    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));


    Marker pickupMarker = Marker(
      markerId: MarkerId('pickup'),
      position: pickLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(title: pickup.placeName, snippet: 'My Location'),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(title: destination.placeName, snippet: 'Destination'),
    );

    setState(() {
      _Markers.add(pickupMarker);
      _Markers.add(destinationMarker);
    });

    Circle pickupCircle = Circle(
      circleId: CircleId('pickup'),
      strokeColor: Colors.green,
      strokeWidth: 3,
      radius: 12,
      center: pickLatLng,
      fillColor: Colors.green[50],
    );

    Circle destinationCircle = Circle(
      circleId: CircleId('destination'),
      strokeColor: Colors.purpleAccent,
      strokeWidth: 3,
      radius: 12,
      center: destinationLatLng,
      fillColor: Colors.purpleAccent,
    );



    setState(() {
      _Circles.add(pickupCircle);
      _Circles.add(destinationCircle);
    });

  }
  resetApp(){

    setState(() {

      polylineCoordinates.clear();
      _polylines.clear();
      _Markers.clear();
      _Circles.clear();
      rideDetailsSheetHeight = 0;
      requestingSheetHeight = 0;
      searchSheetHight = (Platform.isAndroid) ? 275 : 300;
      mapBottomPadding = (Platform.isAndroid) ? 280 : 270;
      drawerCanOpen = true;
    });

    setUpLoaction();



  }

  void createRideRequest() {

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;


    String name ='';
    String phone ='';

    DatabaseReference userRef = FirebaseDatabase.instance.reference().child('users/$uid');

    userRef.once().then((DataSnapshot snapshot){

      if(snapshot.value == null){
        cancelRequest();
        resetApp();
        return;
      }
      if(snapshot.value != null){
        phone = snapshot.value['phone'];
        name = snapshot.value['fullname'];
      }

      rideRef = FirebaseDatabase.instance.reference().child('rideRequest').push();

      var pickup = Provider
          .of<AppData>(context, listen: false)
          .picukAddress;
      var destination = Provider
          .of<AppData>(context, listen: false)
          .destinationkAddress;


      Map pickupMap = {
        'latitude': pickup.latitude.toString(),
        'longitude': pickup.longitude.toString(),
      };

      Map destinationMap = {
        'latitude': destination.latitude.toString(),
        'longitude': destination.longitude.toString(),
      };


      Map rideMap = {
        'created_at': DateTime.now().toString(),
        'rider_name': name,
        'rider_phone': phone,
        'pickup_address': pickup.placeName,
        'destination_address': destination.placeName,
        'location': pickupMap,
        'destination': destinationMap,
        'payment_method': 'card',
        'driver_id': 'waiting',
      };
      rideRef.set(rideMap);


    });

    print('mmm $phone');




  }

  void cancelRequest(){
    rideRef.remove();

  }


}
