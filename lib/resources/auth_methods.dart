import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:society_network/models/post.dart';
import 'package:society_network/models/user.dart';
import 'package:society_network/utils/utils.dart';

class AuthMethods {
  static final Firestore firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  static final CollectionReference _userCollection =
      firestore.collection("users");
  User user = User();

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  Future<User> getUserDetails() async {
    FirebaseUser currentUser = await getCurrentUser();

    DocumentSnapshot documentSnapshot =
        await _userCollection.document(currentUser.uid).get();

    return User.fromMap(documentSnapshot.data);
  }

  Stream<QuerySnapshot> fetchPosts({String userId}) {
    return firestore
        .collection('posts')
        .document('posts')
        .collection('posts')
        .orderBy('timestamp')
        .snapshots();
  }

  Future<void> addPostToDb(Post message) async {
    var map = message.toMap();

    await firestore
        .collection('posts')
        .document("posts")
        .collection("posts")
        .add(map);
  }

  sendRequest() async {
    await firestore
        .collection('posts')
        .document("posts")
        .collection("posts")
        .where("uid", isEqualTo: "786")
        .getDocuments()
        .then((value) => value.documents[0].reference
            .updateData({"likes": FieldValue.increment(1)}));
    return true;
  }

  Future<void> cancelPost(String uid) async{
     await firestore
        .collection('posts')
        .document("posts")
        .collection("posts")
        .where("uid", isEqualTo: uid)
        .getDocuments()
        .then((value) => value.documents[0].reference
            .updateData({"cancel": 1}));
  }

    Future<void> reLaunch(String uid) async{
     await firestore
        .collection('posts')
        .document("posts")
        .collection("posts")
        .where("uid", isEqualTo: uid)
        .getDocuments()
        .then((value) => value.documents[0].reference
            .updateData({"cancel": 0}));
  }



 Future<bool> likepost(String uid,int likes) async {
   print("Indide2");
 await firestore
        .collection('posts')
        .document("posts")
        .collection("posts")
        .where("uid", isEqualTo: uid)
        .getDocuments()
        .then((value) => value.documents[0].reference
            .updateData({"likes": likes}));
    return true;
 }

  Future<User> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _userCollection.document(id).get();

      return User.fromMap(documentSnapshot.data);
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _signInAuthentication.idToken,
        accessToken: _signInAuthentication.accessToken);

    AuthResult result = await _auth.signInWithCredential(credential);
    FirebaseUser user = result.user;
    return user;
  }

  Future<bool> authenticateUser(FirebaseUser user) async {
    QuerySnapshot result = await firestore
        .collection("users")
        .where("email", isEqualTo: user.email)
        .getDocuments();
    final List<DocumentSnapshot> docs = result.documents;
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(FirebaseUser currentUser) async {
    String username = Utils.getUsername(currentUser.email);
    user = User(
        uid: currentUser.uid,
        name: currentUser.displayName,
        email: currentUser.email,
        profilePhoto: currentUser.photoUrl,
        username: username);
    firestore
        .collection("users")
        .document(currentUser.uid)
        .setData(user.toMap(user));
  }

  Future<bool> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<List<User>> fetchAllUsers(FirebaseUser currentUser) async {
    List<User> userList = List();

    QuerySnapshot querySnapshot =
        await firestore.collection("users").getDocuments();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != currentUser.uid) {
        userList.add(User.fromMap(querySnapshot.documents[i].data));
      }
    }

    return userList;
  }

  Stream<DocumentSnapshot> getUserStream({@required String uid}) =>
      firestore.collection('users').document(uid).snapshots();

  void changeUserName({@required String name, @required String userId}) async {
    firestore.collection("users").document(userId).updateData({
      "name": name,
    });
  }

  void changeUserQuote(
      {@required String quote, @required String userId}) async {
    firestore.collection("users").document(userId).updateData({
      "quote": quote,
    });
  }
}
