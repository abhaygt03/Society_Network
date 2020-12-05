import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:society_network/const/const.dart';
import 'package:society_network/const/custom_app_bar.dart';
import 'package:society_network/const/custom_tile.dart';
import 'package:society_network/models/message.dart';
import 'package:society_network/utils/universal_variables.dart';
import 'package:society_network/models/user.dart';
import 'package:society_network/resources/auth_methods.dart';
import 'package:society_network/resources/chat_methods.dart';

class ChatScreen extends StatefulWidget {
  final String receiveruid;
  final String receivername;

  ChatScreen({this.receiveruid,this.receivername});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final ChatMethods _chatMethods = ChatMethods();
  final AuthMethods _authMethods = AuthMethods();

  User sender;
  String _currentUserId;

  bool isWriting=false;
  bool showEmojiPicker=false;


  FocusNode textFieldFocus=FocusNode();

  setWritingTo(bool v)
          {
            setState(() {
              isWriting=v;
            });
          }

  @override
  void initState() {
    super.initState();

    _authMethods.getCurrentUser().then((value) {
      _currentUserId=value.uid;   

      setState(() {
        sender=User(
          name:value.displayName,
          profilePhoto: value.photoUrl,
          uid: value.uid );
      });
    });
  }

  showKeyboard()=>textFieldFocus.requestFocus();
  hideKeyboard()=>textFieldFocus.unfocus();

  hideEmojiContainer(){
    setState(() {
      showEmojiPicker=false;
    });
  }

showEmojiContainer(){
    setState(() {
      showEmojiPicker=true;
    });
  }

  var theImage=AssetImage("lib/const/doodle.jpg");

    @override
  void didChangeDependencies() {
    precacheImage(theImage, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image:theImage,
                fit: BoxFit.cover),
            ),
            child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: customAppBar(context),
        body: Column( 
            children: <Widget>[
              Flexible(         //Or we can use expandable
                child: messageList(widget.receiveruid),
              ),
              chatControls(context),

              showEmojiPicker?Container(child: emojiContainer(),):Container(),
            ],
        ),
        ),
    );
      
  }

  emojiContainer()
  {
    return EmojiPicker(
      bgColor: UniversalVariables.separatorColor,
      indicatorColor: UniversalVariables.blueColor,
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji,category){
        setState(() {
          isWriting=true;
        });

        textFieldController.text=textFieldController.text+emoji.emoji;
      },
      recommendKeywords: ["face","happy","sad","party"],
      numRecommended: 50,
    );
  }


  
  Widget messageList(String receiverId){
    return StreamBuilder(
      stream: Firestore.instance.collection('messages')
      .document(_currentUserId).collection(receiverId).orderBy("timestamp",descending: true).snapshots(),
      builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.data==null)
        return Center(child: CircularProgressIndicator(),);

        return ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: snapshot.data.documents.length,
        reverse: true,
        controller: _listScrollController,
        itemBuilder:(context,index){
          return chatMessageItem(snapshot.data.documents[index]);
        }
    );
      },
    );
  }

    Container chatMessageItem(DocumentSnapshot snapshot){

      Message _message=Message.fromMap(snapshot.data);
      EdgeInsetsGeometry pad=_message.type=="image"?EdgeInsets.all(6):EdgeInsets.all(10);
       
        return Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          child: Container(
            alignment: _message.senderId==_currentUserId? 
            Alignment.centerRight:
            Alignment.centerLeft,
            
            child:_message.senderId==_currentUserId? 
            messageLayout(_message,senderBubble,pad):
            messageLayout(_message,receiverBubble,pad),
          )
        );
    }

    Widget messageLayout(Message message,BorderRadiusGeometry brad,EdgeInsetsGeometry pad)
    {
      
      return Container(
        margin: EdgeInsets.only(top:12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width*0.65
        ),
        decoration: BoxDecoration(
          color:UniversalVariables.senderColor,
          borderRadius: brad,
        ),
        child: Padding(
          padding: pad,
          child: 
          message.type=="image"?
          message.photoUrl!=null?
          // SizedBox(child: ClipRRect(child: Image.network(message.photoUrl),borderRadius: BorderRadius.circular(5),),height: 220,)
         Container(
                  height: 270,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(message.photoUrl),
                      fit: BoxFit.cover
                      ),
                    borderRadius: BorderRadius.circular(10),
                  ),)
          :Text("Image not found!")
          :Text(
            message.message,
          style: TextStyle(color:Colors.white,fontSize: 16),),)
      );
    }

    TextEditingController textFieldController=TextEditingController();

    ScrollController _listScrollController=ScrollController();

  Widget chatControls(context){
    var theme="D";
    return Container(
      padding:EdgeInsets.all(10),
      child:Row(children: <Widget>[
        GestureDetector(
                  child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              gradient: UniversalVariables.fabGradient,
              shape:BoxShape.circle,
            ),
            child: Icon(Icons.add),
          ),
          onTap: (){
            addMediaModal(context);
          },
        ),
        SizedBox(width:8),
        Expanded(
          child: Stack(
            alignment: Alignment.centerRight,
            children:[
               TextField(
                 onTap: ()=>hideEmojiContainer(),
                 focusNode: textFieldFocus,
              controller: textFieldController,
              style: TextStyle(
                color: Colors.white,
              ),
              onChanged: (value){
              (value.length>0&&value.trim()!="")
              ?setWritingTo(true):
              setWritingTo(false);   
              },
              decoration: InputDecoration(
                hintText: "Type a message..",
                hintStyle: TextStyle(
                  color: UniversalVariables.greyColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    const Radius.circular(50)
                  ),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                filled: true,
                fillColor: (theme=="D")?UniversalVariables.separatorColor:Colors.white,

              ),
            ),
              IconButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onPressed: (){
                  if(showEmojiPicker)
                  {
                  hideEmojiContainer();
                  showKeyboard();
                  }
                  else{
                    showEmojiContainer();
                    hideKeyboard();
                  }
                },
                icon: Icon(Icons.face,color: (theme=="D")?Colors.white:Colors.grey[500],),
              )
            ]
          ),),

         isWriting ?Container():Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.keyboard_voice,size: 30,color: (theme=="D")?Colors.white:Colors.grey[600],)),

           isWriting ?Container(): GestureDetector(
             child: Icon(Icons.camera_alt,size: 30,color: (theme=="D")?Colors.white:Colors.grey[600],),
            onTap: (){}),

          isWriting? Container(
            margin:EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              gradient: UniversalVariables.fabGradient,
              shape: BoxShape.circle,
            ),

           child: IconButton(
            icon: Icon(Icons.send,color: Colors.white,), 
            onPressed: (){
              sendMessage();
            })
          ):
            Container(),
            
      ],)
    );
  }

  addMediaModal(context){
    showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: UniversalVariables.blackColor,
      builder: (context){
        return Column(
          children: <Widget>[
            Container(
            padding: EdgeInsets.symmetric(vertical:15),
            child: Row(children: <Widget>[
              FlatButton(
                child: Icon(Icons.close),
                onPressed: ()=>Navigator.pop(context),),

                Expanded(child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Content and tools",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),),
                  
                ))
            ],),
            ),

            Flexible(
              child: ListView(
                children: <Widget>[
                  ModalTile(
                    icon: Icons.image,
                    title: "Media",
                    subtitle: "Share photos and videos",
                    onTap: (){
                      Navigator.pop(context);},),

                    ModalTile(
                    icon: Icons.tab,
                    title: "File",
                    subtitle: "Share files",),
                    
                    ModalTile(
                    icon: Icons.contacts,
                    title: "Contact",
                    subtitle: "Share contacts",),

                    ModalTile(
                    icon: Icons.add_location,
                    title: "Location",
                    subtitle: "Share a location",),

                    ModalTile(
                    icon: Icons.schedule,
                    title: "Schedule Call",
                    subtitle: "Arrange a Vulpix call and get reminders",),

                    ModalTile(
                    icon: Icons.poll,
                    title: "Create Poll",
                    subtitle: "Share polls",),
                ],
              ),
            )
          ],
        );
      }
    );
  }

  sendMessage(){
    String text=textFieldController.text;

    Message _message=Message(
      receiverId: widget.receiveruid,
      senderId: sender.uid,
      timestamp: Timestamp.now(),
      message: text,
      type: 'text',
    );

    setState(() {
      isWriting=false;
    });

    textFieldController.text="";

    _chatMethods.addMessageToDb(_message,sender);
  }

  CustomAppBar customAppBar(context)
  {
    return CustomAppBar(
      backcolor: "D",

      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: (){
          Navigator.pop(context);
        },
        ),
      centerTitle: false,
      title: Text(
        widget.receivername,
      ), 
      actions: <Widget>[
        
      ], );
  }
}

  class ModalTile extends StatelessWidget {
   final String title;
   final String subtitle;
   final IconData icon;
   final Function onTap;
   
   const ModalTile({
     this.icon,
     this.subtitle,
     this.title,
     this.onTap,
   });

    @override
    Widget build(BuildContext context) {
      return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                    child: CustomTile(mini:false,
                    onTap: onTap,
                    leading: Container(
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: UniversalVariables.receiverColor
                      ),
                      padding: EdgeInsets.all(10),
                      child: Icon( icon,
                      color: UniversalVariables.greyColor,
                      size: 38,)),

                     title: Text(title,
                     style: TextStyle(
                       color: UniversalVariables.greyColor,
                       fontSize: 18 ,
                     ),), 
                     subtitle:Text(subtitle,
                     style: TextStyle(
                       color:UniversalVariables.greyColor,
                       fontSize: 14,
                     ),)),
      );
    }
  }