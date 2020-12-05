import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_network/home_page_widgets/CustomTile.dart';
import 'package:society_network/home_page_widgets/LastMessage.dart';
import 'package:society_network/models/contacts.dart';
import 'package:society_network/models/user.dart';
import 'package:society_network/provider/userprovider.dart';
import 'package:society_network/resources/auth_methods.dart';
import 'package:society_network/resources/chat_methods.dart';
import 'package:society_network/screens/chat_screen.dart';


class ContactView extends StatelessWidget {
  final Contact contact;
  final String curruid;
  final AuthMethods _authMethods=AuthMethods();

  ContactView(this.contact,this.curruid);
  @override
  Widget build(BuildContext context) { 
    return FutureBuilder<User>(
      future: _authMethods.getUserDetailsById(contact.uid),
      builder: (context,snapshot){
        if(snapshot.hasData){
          User user=snapshot.data;
          return ViewLayout(contact: user,thcolor: "D",curruid:curruid);
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final User contact;
  final String curruid;
  final ChatMethods _chatMethods=ChatMethods();
  final String thcolor;
  ViewLayout({
    @required this.contact,
    @required this.curruid,
    @required this.thcolor
  });



  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider=Provider.of<UserProvider>(context);
    if(curruid==contact.uid)
    return Container();
    return CustomTile(
            trailing:  LastMessageContainer(
              requirement: "time",
              stream: _chatMethods.fetchLastMessage(
                senderId: userProvider.getUser.uid,
                recerverId: contact.uid
              ), 
              ),
            mini: false,
            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(receivername: contact.name,receiveruid: contact.uid))),
            title: Text(
                    contact.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color:(thcolor=="D")? Colors.white:Colors.black,fontFamily: "Arial",fontSize: 19),),
            subtitle: LastMessageContainer(
              requirement: "lastmsg",
              stream: _chatMethods.fetchLastMessage(
                senderId: userProvider.getUser.uid,
                recerverId: contact.uid
              ),
            ),
             leading: Container(
               constraints: BoxConstraints(maxHeight: 58,maxWidth: 58),
               child: Stack(
                 children: <Widget>[
                   CircleAvatar(
                     maxRadius: 30,
                     backgroundColor: Colors.grey,
                     backgroundImage: NetworkImage(contact.profilePhoto),
                   ),
                 ],),
             ),                  
          );
  }
}