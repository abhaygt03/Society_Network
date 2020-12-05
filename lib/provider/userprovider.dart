import 'package:flutter/material.dart';
import 'package:society_network/models/user.dart';
import 'package:society_network/resources/auth_methods.dart';


class UserProvider with ChangeNotifier{
  User _user;
  AuthMethods _authMethods = AuthMethods(); 

  User get getUser=>_user;

  Future<void> refreshUser() async{
    User user =await _authMethods.getUserDetails();
    _user=user;
    notifyListeners();
  }
  
}