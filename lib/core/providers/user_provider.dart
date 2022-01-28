import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier{
  UserCredential? _userCredential;
  UserCredential? get userCredential => _userCredential;

  set userCredential(UserCredential? u){
    _userCredential = u;
    notifyListeners();
  }
  User? _user;
  User? get user => _user;
  set user(User? u){
    _user = u;
    notifyListeners();
  }
}