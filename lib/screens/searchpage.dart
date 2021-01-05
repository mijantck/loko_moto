import 'package:brand_colors/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:loko_moto/dataProvider/appData.dart';
import 'package:loko_moto/datamodels/prediction.dart';
import 'package:loko_moto/globalvariable.dart';
import 'package:loko_moto/helpers/requesthelper.dart';
import 'package:loko_moto/widget/BrandDivider.dart';
import 'package:loko_moto/widget/PredictionTile.dart';
import 'package:provider/provider.dart';
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var picupColtroller  = TextEditingController();
  var destinationColtroller  = TextEditingController();
  var destinationFocus = FocusNode();

  bool focus = false;
  void setFucos(){
    if(!focus){
      FocusScope.of(context).requestFocus(destinationFocus);
      focus = true;
    }
  }

  List<Prediction> destinationPredictionList = [];

  void searchPlace(String placeName) async {
    if (placeName.length > 1) {

      String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapkey&sessiontoken=1234567890&components=country:bd';

      var respons = await RequestHelper.getRequest(url);
      if(respons == 'failed'){
        return;
      }



      if(respons['status'] =='OK'){

        var predictionJson = respons['predictions'];
        var thisList = (predictionJson as List).map((e) => Prediction.fromJson(e)).toList();
        setState(() {
          destinationPredictionList = thisList;
          print('fild');
        });

      }


    }
  }



  @override
  Widget build(BuildContext context) {

    String address = Provider.of<AppData>(context).picukAddress.placeName ?? '';
    picupColtroller.text = address;

    setFucos();

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
                              controller: picupColtroller,
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
                              onChanged: (value){
                                searchPlace(value);
                              },
                              focusNode: destinationFocus,
                              controller: destinationColtroller,
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
          ),

      (destinationPredictionList.length > 0) ?
              ListView.separated(
                itemBuilder: (context,index){
                  return PredictionTile(
                    prediction: destinationPredictionList[index],
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>BrandDivider(),
                itemCount: destinationPredictionList.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
              )
              :Container(),

        ],
      ),
    );
  }
}


