import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:society_network/models/post.dart';
import 'package:society_network/provider/image_upload_provider.dart';


class StorageMethods{
  static final Firestore firestore=Firestore.instance;

  StorageReference _storageReference;
  // User user = User();


    Future<String> uploadImageToStorage(File image) async{

      try{ 
        _storageReference=FirebaseStorage.instance
      .ref().child('${DateTime.now().millisecondsSinceEpoch}');

      StorageUploadTask _storageUploadTask=_storageReference.putFile(image);

      var url=await(await _storageUploadTask.onComplete).ref.getDownloadURL();
      return url;
      }
      catch(err)
      {
        print(err);
        return null;
      }
    }

    void setImageMsg(String authPic,String url,String senderId,String uid,String title,String author){
    
   

        Post _message;
        _message=Post.imageMessage(
         authId: senderId,
         author: author,
         authpic: authPic,
         uid: uid,
         title: title,
         likes: 0,
         pic: url,
         timestamp: Timestamp.now(),
        );

        var map=_message.toMap();

        firestore.collection('posts')
        .document("posts")
        .collection("posts")
        .add(map);

    }

      void uploadImage(File image,String authPic,String senderId,ImageUploadProvider imageUploadProvider,String title,String author) async{
        // imageUploadProvider.setToLoading();

        String url=await uploadImageToStorage(image);

        // imageUploadProvider.setToIdle();
        String uid=UniqueKey().toString();
        setImageMsg(authPic,url,senderId,uid,title,author);
        
    }

     Future<void> uploadProfilePic(File image,String userId,ImageUploadProvider imageUploadProvider) async{
        imageUploadProvider.setToLoading();

        String url=await uploadImageToStorage(image);

        imageUploadProvider.setToIdle();

        firestore.collection("users").document(userId).updateData({
          "profile_photo":url});
    }
 
}