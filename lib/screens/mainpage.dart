import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loko_moto/widget/BrandDivider.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:brand_colors/brand_colors.dart';
import 'dart:io';




class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  double searchSheetHight =(Platform.isIOS) ? 300 : 275;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  double mapBottomPadding = 0;


  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );




  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget> [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapBottomPadding),
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);
              mapController = controller;

              setState(() {
                mapBottomPadding = (Platform.isAndroid) ? 280 : 270;

              });
            }
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
                  children: <Widget> [
                    SizedBox(height: 5,),
                    Text('Nice to see you',style: TextStyle(fontSize: 10),),
                    Text('Where are you going',style: TextStyle(fontSize: 18,),),

                    SizedBox(height: 10,),
                    Container(
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
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Item 2'),
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
