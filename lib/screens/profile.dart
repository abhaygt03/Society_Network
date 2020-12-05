import 'package:flutter/material.dart';
import 'package:society_network/models/user.dart';
import 'package:society_network/resources/auth_methods.dart';
import 'package:society_network/screens/login_screen.dart';

class ProfilePage extends StatefulWidget {
  
     final User curruser;
      ProfilePage(this.curruser);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthMethods _authMethods = AuthMethods();

  var _imageList = [
    'images/1.jpg',
    'images/2.jpeg',
    'images/3.jpg',
    'images/4.jpeg',
    'images/5.jpg',
    'images/6.jpg',
    'images/7.jpeg',
    'images/8.jpg',
    'images/9.jpg',
    'images/10.jpeg',
    'images/11.png',
    'images/12.jpeg',
    'images/13.jpg',
    'images/14.jpg',
    'images/15.jpg',
    'images/16.jpeg',
    'images/17.jpg',
    'images/18.jpeg',
  ];


  @override
  Widget build(BuildContext context) {
    double hPadding = 40;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FractionallySizedBox(
            alignment: Alignment.topCenter,
            heightFactor: 0.7,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.curruser.profilePhoto),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: 0.4,
            child: Container(
              decoration:BoxDecoration(
              borderRadius:BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50)),
              color: Color(0xFF1a1a1a),
                         ),

              child:  Container(
            padding: EdgeInsets.symmetric(horizontal: hPadding),
            height: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _titleSection(),
                _infoSection(),
                _actionSection(hPadding: hPadding),
              ],
            ),
          ),
            ),
          ),

          /// Sliding Panel
        
        ],
      ),
    );
  }



  /// Action Section
  Row _actionSection({double hPadding}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Visibility(
          visible: true,
          child: Expanded(
            child: OutlineButton(
              onPressed:()=>print("pressed") ,
              borderSide: BorderSide(color: Colors.blue),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Text(
                "Profile Settings",
                style: TextStyle(
                  fontFamily: 'NimbusSanL',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: true,
          child: SizedBox(
            width: 16,
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: SizedBox(
              width: true
                  ? (MediaQuery.of(context).size.width - (2 * hPadding)) / 1.6
                  : double.infinity,
              child: FlatButton(
                onPressed:()async{
      final bool isLoggedOut=await _authMethods.signOut();
         if(isLoggedOut){
           Navigator.pushAndRemoveUntil(context, 
           MaterialPageRoute(builder: (context)=>LoginScreen()),
            (route) => false);
         } 
    },
                color: Colors.blue,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Text(
                  'Log Out',
                  style: TextStyle(
                    fontFamily: 'NimbusSanL',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Info Section
  Row _infoSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _infoCell(title: 'Posts', value: '5'),
        // Container(
        //   width: 1,
        //   height: 40,
        //   color: Colors.grey,
        // ),
        // _infoCell(title: 'Hourly Rate', value: "\$65"),
        Container(
          width: 1,
          height: 40,
          color: Colors.grey,
        ),
        _infoCell(title: 'Location', value: 'Patiala'),
      ],
    );
  }

  /// Info Cell
  Column _infoCell({String title, String value}) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w300,
            fontSize: 14,
            color: Colors.white
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Colors.white

          ),
        ),
      ],
    );
  }

  /// Title Section
  Column _titleSection() {
      String name=widget.curruser.name.toLowerCase();
      int indsp=name.indexOf(" ");
    return Column(
      children: <Widget>[
        Text(
          indsp>0?
          name[0].toUpperCase()+name.substring(1,indsp)+" "+name[indsp+1].toUpperCase()+name.substring(indsp+2):
           name[0].toUpperCase()+name.substring(1),
          style: TextStyle(
            fontFamily: 'NimbusSanL',
            fontWeight: FontWeight.w700,
            fontSize: 30,
            color: Colors.white

          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          "Society Admin",
          style: TextStyle(
            fontFamily: 'NimbusSanL',
            fontStyle: FontStyle.italic,
            fontSize: 16,
            color: Colors.white

          ),
        ),
      ],
    );
  }
}