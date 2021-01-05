import 'package:brand_colors/brand_colors.dart';
import 'package:flutter/material.dart';
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget> [
          Container(
            height: 210,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
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
              padding: EdgeInsets.only(left: 24,top: 48,right: 24,bottom: 20),
              child: Column(
                children: [

                  SizedBox(height: 5,),
                  Stack(
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                       child: Icon(Icons.arrow_back)
                      ),
                      Center(
                        child: Text('Set destination',style: TextStyle(fontSize: 20,),),
                      ),

                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Icon(Icons.where_to_vote_outlined,size: 16,),
                      SizedBox(width: 18,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(4)
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Pickup Location ',
                                fillColor: Colors.black12,
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(left: 10,top: 8,bottom: 8),

                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Icon(Icons.where_to_vote_outlined,size: 16,color: Colors.amberAccent,),
                      SizedBox(width: 18,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(4)
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Where to?',
                                fillColor: Colors.black12,
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(left: 10,top: 8,bottom: 8),

                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),


                ],
              ),
            )


          )
        ],
      ),
    );
  }
}
