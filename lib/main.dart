import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_network/provider/image_upload_provider.dart';
import 'package:society_network/resources/auth_methods.dart';
import 'package:society_network/home_page_widgets/homepage.dart';
import 'package:society_network/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:society_network/provider/userprovider.dart';
import 'package:society_network/startscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    AuthMethods _authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          // ChangeNotifierProvider(create: (context)=>ImageUploadProvider()),
          ChangeNotifierProvider(create: (context)=>UserProvider()),
          ChangeNotifierProvider(create: (context)=>ImageUploadProvider()),
        ],
          child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
          title: "Society-Network",
          debugShowCheckedModeBanner: false,
          initialRoute: "/",
          routes: {
            '/home_screen':(context)=>HomePage(),
          },
          home: FutureBuilder(
            future: _authMethods.getCurrentUser(),
            builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
              if (snapshot.hasData) {
                return HomeScreen();
              } else {
                return LoginScreen();
              }
            },
          )),
    );
  }
}





