import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String uid;
  String authId;
  String title;
  String author;
  String authpic;
  int likes;
  int cancel;
  String pic;
  Timestamp timestamp;

  Post.imageMessage({
    this.authpic,
    this.uid,
    this.authId,
    this.title,
    this.author,
    this.likes=0,
    this.pic="",
    this.timestamp,
    this.cancel=0
  });

  Map toMap() {
    var data = Map<String, dynamic>();
    data['uid'] = this.uid;
    data['authId'] = this.authId;
    data['cancel'] = this.cancel;
    data['authpic'] = this.authpic;
    data['title'] = this.title;
    data['author'] = this.author;
    data['likes'] = this.likes;
    data["pic"] = this.pic;
    data['timestamp']=this.timestamp;
    return data;
  }

  Post.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.authId = mapData['authId'];
    this.cancel = mapData['cancel'];
    this.authpic = mapData['authpic'];
    this.title = mapData['title'];
    this.author = mapData['author'];
    this.likes = mapData['likes'];
    this.pic = mapData['pic'];
    this.timestamp=mapData['timestamp'];
    }
}