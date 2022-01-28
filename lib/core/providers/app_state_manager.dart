import 'package:flutter/cupertino.dart';

class AppStateManager extends ChangeNotifier{
  bool _isInitialized = false;
  bool _loggedIn = false;
  bool _history = false;
  bool _convert = false;
  String? _curError;

  bool get initialized => _isInitialized;
  bool get loggedIn => _loggedIn;
  bool get history => _history;
  bool get convert => _convert;
  String? get curError => _curError;

  set loggedIn(bool v){
    _loggedIn = v;
    notifyListeners();
  }
  set initialized(bool v){
    _isInitialized = v;
    notifyListeners();
  }
  set history(bool v){
    _history = v;
    notifyListeners();
  }
  set convert(bool v){
    _convert = v;
    notifyListeners();
  }
  set curError(String? v){
    _curError = v;
    notifyListeners();
  }

}