import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttercurr/base/base_view_model.dart';
import 'package:fluttercurr/core/providers/app_state_manager.dart';
import 'package:fluttercurr/core/providers/user_provider.dart';
import 'package:fluttercurr/core/utils/auth.dart';
import 'package:fluttercurr/ui/components/error_widget.dart';
import 'package:provider/provider.dart';

class AuthenticationViewModel extends BaseViewModel{
  late UserProvider userProvider;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController cPassController = TextEditingController();
  late AppStateManager appStateManager;
  bool _initialized = false;
  bool get initialized => _initialized;
  set initialized(bool v){
    _initialized = v;
    notifyListeners();
  }
  bool _newUser = false;
  bool get newUser => _newUser;
  set newUser(bool v){
    _newUser = v;
    notifyListeners();
  }
  bool _obscurePass = true;
  bool get obscurePass => _obscurePass;
  set obscurePass(bool v){
    _obscurePass = v;
    notifyListeners();
  }
  void togglePass(){
    obscurePass = !obscurePass;
  }
  void toggleForm(){
    newUser = !newUser;
  }
  Future<void> onReady(BuildContext context) async {
    appContext = context;
    isLoading = true;
    userProvider = Provider.of<UserProvider>(context,listen: false);
    appStateManager = Provider.of<AppStateManager>(appContext!,listen: false);

    User? user = await Authentication.initialize();
    if(user != null){
      userProvider.user = user;
      appStateManager.loggedIn = true;
    }
    isLoading = false;
    initialized = true;
  }
  Future<void> signInWithEmail()async{
    isLoading = true;
    bool resp = await Authentication.signinWithEmail(appContext!,email: emailController.text,
        password: passController.text,newUser: _newUser);
    isLoading = false;
    if(resp){
      userProvider.user = FirebaseAuth.instance.currentUser;
      appStateManager.loggedIn = true;
    }else{
      showError(appContext!, appStateManager.curError ?? 'Error occurred');
    }
  }
  Future<void> signInWithGoogle()async{
    isLoading = true;
    bool resp  = await Authentication.loginWithGoogle(appContext!);
    isLoading = false;
    if(resp){
      userProvider.user = FirebaseAuth.instance.currentUser;
      appStateManager.loggedIn = true;
    }else{
      showError(appContext!, appStateManager.curError ?? 'Error occurred');
    }
  }
  Future<void> signInWithTwitter()async{
    isLoading = true;
    bool resp = await Authentication.signInWithTwitter(appContext!);
    isLoading = false;
    if(resp){
      userProvider.user = FirebaseAuth.instance.currentUser;
      appStateManager.loggedIn = true;
    } else {
      showError(appContext!, appStateManager.curError ?? 'Error occurred');
    }
  }
}