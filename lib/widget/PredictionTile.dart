import 'package:flutter/material.dart';
import 'package:loko_moto/dataProvider/appData.dart';
import 'package:loko_moto/datamodels/address.dart';
import 'package:loko_moto/datamodels/prediction.dart';
import 'package:loko_moto/globalvariable.dart';
import 'package:loko_moto/helpers/requesthelper.dart';
import 'package:loko_moto/widget/progressDialog.dart';
import 'package:provider/provider.dart';
class PredictionTile extends StatelessWidget {

  final Prediction prediction;
  PredictionTile({this.prediction});

  void getPlaceDetails(String placeid,context) async{

    String url = 'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeid&key=$mapkey';
    var response = await RequestHelper.getRequest(url);


    if(response == 'failed'){
      return;
    }
    if(response['status'] == 'OK'){
      Address thisplace = Address();
      thisplace.placeName = response['result']['name'];
      thisplace.placeID = placeid;
      thisplace.latitude = response['result']['geometry']['location']['lat'];
      thisplace.longitude = response['result']['geometry']['location']['lng'];

      Provider.of<AppData>(context,listen: false).updateDestinationAddress(thisplace);
      print(thisplace.placeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (){
        getPlaceDetails(prediction.placeId, context);

      },
      padding: EdgeInsets.all(0),
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Icon(Icons.place_outlined,color: Colors.black12,),
                SizedBox(width: 12,),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(prediction.mainText,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 16),),
                        SizedBox(height: 4,),
                        Text(prediction.secondaryText,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12,color: Colors.black38),),
                        SizedBox(height: 10,)
                      ],
                    )
                ),


              ],
            ),
          )
        ],
      ),
    );
  }
}