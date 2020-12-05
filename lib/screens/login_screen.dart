import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:society_network/resources/auth_methods.dart';
import 'package:shimmer/shimmer.dart';
import 'package:society_network/startscreen.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
    AuthMethods _authMethods = AuthMethods();

  bool isLoginPressed=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff19191b),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
       children: <Widget>[
         loginButton(),
      isLoginPressed?Center(child:CircularProgressIndicator(),):Container(),
       ], 
      ));
  }

  Widget loginButton() {
    return   FlatButton(
      padding: EdgeInsets.all(35),
      child:Shimmer.fromColors(
      child:Text(
        "LOGIN",
        style: TextStyle(
            fontSize: 35, fontWeight: FontWeight.w900, letterSpacing: 1.2),
      ),
      baseColor: Colors.white, 
    highlightColor: Color(0xff2b343b)),
      onPressed: () { performLogin();},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ); 
    
  }

  void performLogin() {
    setState(() {
         isLoginPressed=true;
       });
    _authMethods.signIn().then((FirebaseUser user) {
      if (user != null)
        authenticateUser(user);
      else
        print("Some error occoured");
    });
  }

  void authenticateUser(FirebaseUser user) {
     setState(() {
      isLoginPressed=false;
    });
    _authMethods.authenticateUser(user).then((isNewUser) {
      if (isNewUser) {
        _authMethods.addDataToDb(user).then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
        });
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      }
    });
  }
}
