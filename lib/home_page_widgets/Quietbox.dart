import 'package:flutter/material.dart';
import 'package:society_network/utils/universal_variables.dart';

class QuietBox extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(padding: EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        color: UniversalVariables.separatorColor,
          ),

        padding: EdgeInsets.symmetric(vertical: 35,horizontal: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("This is where all the contact are listed",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),

            SizedBox(height: 25,),

            Text("Search for your friends and family to start calling or chatting with them",
            style: TextStyle(
               fontWeight: FontWeight.normal,
               letterSpacing: 1.2,
               fontSize: 18
            ),
            textAlign: TextAlign.center,),
            
            SizedBox(height: 25,),
            
            FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),),
              color: UniversalVariables.lightBlueColor,
              child: Text("Start Searching"),
              onPressed: null,
            ),
          ],
        ),
      ),),
    );
  }
}