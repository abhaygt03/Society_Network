import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:like_button/like_button.dart';
import 'package:society_network/resources/auth_methods.dart';
import 'package:society_network/screens/chat_screen.dart';

//the feed box will have for parameters :
// the user name , the user avatar, the pub date, the content text and content img
Widget aButton(IconData icon, String actionTitle, Color iconColor, String url) {
  return Expanded(
    child: FlatButton.icon(
      onPressed: () async {
        await FlutterShare.share(
            title: 'Society Notification',
            text: 'I just saw this amazing post.\nIts fun! try watching it: ',
            linkUrl: url,
            chooserTitle: 'Example Chooser Title');
      },
      icon: Icon(
        icon,
        color: iconColor,
      ),
      label: Text(
        actionTitle,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  );
}

Widget feedBox(String avatarUrl, String userName, Timestamp date,
    String contentText, String contentImg, final int likes,
    int cancel,String uid,String authId,BuildContext context) {

  final AuthMethods _authMethods = AuthMethods();

  var msgstamp = date.toDate();
  var msgdate = DateTime(msgstamp.year, msgstamp.month, msgstamp.day,
      msgstamp.hour, msgstamp.minute, msgstamp.second);
  var now = DateTime.now();
  final difference = now.difference(msgdate).inSeconds;
  String text;
  if (difference < 60)
    text = "few sec ago";
  else if (difference < 3600)
    text = (difference ~/ 60).toString() + "m ago";
  else if (difference < 86400)
    text = (difference ~/ 3600).toString() + "h ago";
  else if (difference < 864000)
    text = (difference ~/ 86400).toString() + "d ago";
  else if (difference < 2592000)
    text = (difference ~/ 604800).toString() + "w ago";
  else
    text = msgstamp.day.toString() +
        "/" +
        msgstamp.month.toString() +
        "/" +
        msgstamp.year.toString();

          // Future<bool> onLikeButtonTapped(bool isLiked) async{
          //   print("Inside1");
          // bool success= false;
          // success= await _authMethods.likepost(uid,likes+1);
          // return success? !isLiked:isLiked;
          //   }

  return Container(
    margin: EdgeInsets.only(bottom: 20.0),
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15.0),
      color: Color(0xFF262626),
    ),
    child: Padding(
      padding: EdgeInsets.all(9.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(avatarUrl),
                radius: 25.0,
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ButtonTheme(
                      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), //adds padding inside the button
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, //limits the touch area to the button area
                      minWidth: 0, //wraps child's width
                      // height: 10, //wraps child's height
                      child:FlatButton(
                      padding: EdgeInsets.fromLTRB(0,5,40,5),
                   onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(receiveruid: authId,receivername: userName,)));},
                    child:Text(
                      userName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),),),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              // FlatButton(onPressed: null, child: Text("Cancel"),color: Colors.teal)
              // RaisedButton(onPressed: null,child:Text("Cancel"))
            FlatButton(
              color: cancel==1?Colors.teal[700]:Colors.red,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(5),
              // splashColor: cancel==1?Colors.red:Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                // side: BorderSide(color: Colors.red)
              ),
              onPressed: () async{
                cancel==0?
                await _authMethods.cancelPost(uid):
                await _authMethods.reLaunch(uid);

                },
                child: Text(
                  cancel==1?"ReLaunch":"Cancel",
                  style: TextStyle(fontSize: 15.0),
                ),
              )
            ],
          ),

          SizedBox(
            height: 10.0,
          ),
          
          if (contentText != "")
            Text(
              contentText,
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),

            cancel==1? SizedBox(
            height: 10.0,
          ):Container(),

            cancel==1?Container(  
            decoration: BoxDecoration(borderRadius:BorderRadius.circular(5) ,color: Colors.red[400]),
            padding: EdgeInsets.symmetric(horizontal: 8,vertical: 2),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text("This event has been cancelled"),
            Icon(Icons.cancel,size: 20,)
          ],),):Container(),

          SizedBox(
            height: 10.0,
          ),
          if (contentImg != "") Image.network(contentImg),
          SizedBox(
            height: 10.0,
          ),
          Divider(
            thickness: 1.5,
            color: Color(0xFF505050),
          ),
          Row(
            children: [
              Expanded(
                child: likes > -1
                    ? LikeButton(bubblesSize: 100.0, likeCount: likes)
                    : LikeButton(),
              ),
              // actionButton(Icons.thumb_up, "Like", likes==0?Color(0xFF505050):Colors.red),
              // actionButton(Icons.comment, "Comment", Color(0xFF505050)),
              aButton(Icons.share, "Share", Color(0xFF505050), contentImg),
            ],
          )
        ],
      ),
    ),
  );
}

//child: Row(
//mainAxisAlignment: MainAxisAlignment.center,
//children: <Widget>[
//GestureDetector(
//onTap: () {
// _authMethods.likepost(liked);
//liked = !liked;
//},
//child: Icon(Icons.favorite,
//color: liked ? Colors.pink : Colors.white,
//size: 32.0)),
//Text("$likes")
