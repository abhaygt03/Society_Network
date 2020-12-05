import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_network/home_page_widgets/appbar.dart';
import 'package:society_network/home_page_widgets/contactview.dart';
import 'package:society_network/models/contacts.dart';
import 'package:society_network/models/user.dart';
import 'package:society_network/provider/userprovider.dart';
import 'package:society_network/resources/chat_methods.dart';
import 'package:society_network/utils/universal_variables.dart';
import 'package:society_network/home_page_widgets/Quietbox.dart';


class ChatListScreen extends StatelessWidget {

     final User curruser;
      ChatListScreen(this.curruser);

    CustomAppBar customAppBar( BuildContext context)
    {
      return CustomAppBar(
        backcolor: "D",
        leading:IconButton(
          icon: Icon(
            Icons.notifications,
            color: Colors.white),
            onPressed: null),
            title:UserCircle(curruser.profilePhoto),
            centerTitle: true,
            actions: <Widget>[
              

              IconButton(
                icon: Icon(Icons.more_vert,
                color: Colors.white),
                onPressed: (){},
              ),
            ],
      );
    }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:UniversalVariables.blackColor,
      appBar: customAppBar(context),
      body: ChatListContainer(curruser),
    );
  }
}


class ChatListContainer extends StatelessWidget {

  final User curruser;
  ChatListContainer(this.curruser);

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider=Provider.of<UserProvider>(context);

    ChatMethods _chatMethods=ChatMethods();
    return Container(
      child: StreamBuilder(
              stream: _chatMethods.fetchContacts(
                userId: userProvider.getUser.uid
              ),
              builder: (context,snapshot){
                if(snapshot.hasData)
                {
                  var docList=snapshot.data.documents;
                  if(docList.isEmpty){
                  return  QuietBox();
                  }
                  return ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: docList.length,
                    itemBuilder:(context,index){
                      Contact contact=Contact.fromMap(docList[index].data);
                      return ContactView(contact,curruser.uid);
                    },);
                }
                return Center(child: CircularProgressIndicator(),);
             },
      ),
    );
  }
}




class UserCircle extends StatelessWidget {
 
 final String pic;
 UserCircle(this.pic);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: UniversalVariables.separatorColor,
          borderRadius: BorderRadius.circular(50)),

          child: Stack(children: <Widget>[
            Align(
              child: Text(
                "AB",
              style: TextStyle(
                color:UniversalVariables.lightBlueColor,
                fontWeight: FontWeight.bold,
                fontSize: 13),),
              alignment: Alignment.center,
            ),

                     Align(
                       alignment: Alignment.bottomRight,
                       child: Container(
                         height: 15,
                         width: 15,
                         decoration: BoxDecoration(
                           color: UniversalVariables.onlineDotColor,
                           shape: BoxShape.circle,
                           border: Border.all(
                             color:UniversalVariables.blackColor,
                             width: 2,
                           )
                         ),
                         ),)
          ],),
    );
  }
}