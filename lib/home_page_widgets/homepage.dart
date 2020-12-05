import 'dart:io';

import 'package:flutter/material.dart';
import 'package:society_network/models/post.dart';
import 'package:society_network/provider/image_upload_provider.dart';
import 'package:society_network/resources/auth_methods.dart';
import 'package:society_network/resources/storage_methods.dart';
import 'package:society_network/screens/login_screen.dart';
import 'package:society_network/utils/utils.dart';
import 'feedbox.dart';
import 'actionbtn.dart';
import 'package:flutter/scheduler.dart';
import 'storytile.dart';
import 'package:provider/provider.dart';
import 'package:society_network/provider/userprovider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  UserProvider userProvider;
  final StorageMethods _storageMethods = StorageMethods();
  ImageUploadProvider _imageUploadProvider;
  final AuthMethods _authMethods = AuthMethods();


  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();
    });
    WidgetsBinding.instance.addObserver(this);
  }

  Color bgBlack = Color(0xFF1a1a1a);
  Color mainBlack = Color(0xFF262626);
  Color mainGrey = Color(0xFF505050);

  List<String> avatarUrl = [
    "https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=700&q=80",
    "https://images.unsplash.com/photo-1457449940276-e8deed18bfff?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=80",
    "https://images.unsplash.com/photo-1525879000488-bff3b1c387cf?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80",
  ];

  List<String> storyUrl = [
    "https://images.unsplash.com/photo-1600055882386-5d18b02a0d51?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=621&q=80",
    "https://images.unsplash.com/photo-1600174297956-c6d4d9998f14?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80",
    "https://images.unsplash.com/photo-1600008646149-eb8835bd979d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=666&q=80",
    "https://images.unsplash.com/photo-1502920313556-c0bbbcd00403?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=967&q=80",
  ];

  Widget postList() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('posts')
          .document("posts")
          .collection("posts")
          .orderBy("timestamp", descending: false)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null)
          return Center(child: CircularProgressIndicator());

        return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: snapshot.data.documents.length,
            reverse: true,
            controller: ScrollController(),
            itemBuilder: (context, index) {
              Post posts = Post.fromMap(snapshot.data.documents[index].data);

              return feedBox(posts.authpic, posts.author, posts.timestamp,
                  posts.title, posts.pic, posts.likes, posts.cancel,posts.uid,posts.authId,context);
            });
      },
    );
  }

  pickImage(ImageSource source,String authPic ,String title,String author,String authId) async {
    File selectedImage = await Utils.pickImage(source: source);
    _storageMethods.uploadImage(
        selectedImage, authPic,authId, _imageUploadProvider, title, author);
  }

  TextEditingController textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlack,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: mainBlack,
        title: Text(
          "Society Network",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        // Actions button
        
        actions: [
          IconButton(
            onPressed: ()async{
      final bool isLoggedOut=await _authMethods.signOut();
         if(isLoggedOut){
           Navigator.pushAndRemoveUntil(context, 
           MaterialPageRoute(builder: (context)=>LoginScreen()),
            (route) => false);
         } 
    },
            icon: Icon(Icons.logout),
          ),

        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //First of all we need to create the post editor
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: mainBlack,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 25.0,
                            backgroundImage: NetworkImage(avatarUrl[1]),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: TextField(
                              controller: textFieldController,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 25.0),
                                  hintText: "Post something...",
                                  filled: true,
                                  fillColor: mainGrey,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide.none,
                                  )),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Divider(
                        color: mainGrey,
                        thickness: 1.5,
                      ),
                      //Now we will create a Row of three button
                      Row(
                        children: [
                          
                          actionButton(
                              Icons.image, "Picture", Color(0xFF58C472), () {
                                var curr_user=userProvider.getUser;
                                String author=curr_user.name;
                            String title = textFieldController.text;
                            pickImage(ImageSource.gallery,curr_user.profilePhoto ,title,author,curr_user.uid);
                            textFieldController.text = "";
                          }),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              //We have finished the Post editor now let's create
              //the story's timeline
              // let's first create a new file for the custom widget
              //now let's buil the container
              SizedBox(
                height: 10.0,
              ),
              // Container(
              //   height: 160.0,
              //   width: double.infinity,
              //   child: ListView(
              //     scrollDirection: Axis.horizontal,
              //     children: [
              //       storyTile(avatarUrl[0], storyUrl[0], "Ling chang"),
              //       storyTile(avatarUrl[1], storyUrl[1], "Ling chang"),
              //       storyTile(avatarUrl[2], storyUrl[2], "Ling chang"),
              //     ],
              //   ),
              // ),
              // SizedBox(
              //   height: 20.0,
              // ),

              postList(),
            ],
          ),
        ),
      ),
    );
  }
}
