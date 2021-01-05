import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loko_moto/dataProvider/appData.dart';
import 'package:loko_moto/helpers/helperMethods.dart';
import 'package:loko_moto/screens/searchpage.dart';
import 'package:loko_moto/style/styles.dart';
import 'package:loko_moto/widget/BrandDivider.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:brand_colors/brand_colors.dart';
import 'dart:io';

import 'package:provider/provider.dart';




class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  var scaffoldKey = GlobalKey<ScaffoldState>();


  double searchSheetHight =(Platform.isIOS) ? 300 : 275;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  double mapBottomPadding = 0;

  var geoLocatior = Geolocator();
  Position currentPosition;


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

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


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
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);
              mapController = controller;

              setState(() {
                mapBottomPadding = (Platform.isAndroid) ? 280 : 270;
              });
               setUpLoaction();
            }
            ),

          Positioned(
              top: 44,
              left: 20,
              child: GestureDetector(
                onTap: (){
                  scaffoldKey.currentState.openDrawer();
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
                    child: Icon(Icons.menu,color: Colors.black26,),
                  ),
                ) ,
              )
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
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
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(

                          builder: (context) => SearchPage(),
                        ));
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
                            Text((Provider.of<AppData>(context).picukAddress != null)
                            ? Provider.of<AppData>(context).picukAddress.placeName
                            : 'Add Home'),
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
          )
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
}
