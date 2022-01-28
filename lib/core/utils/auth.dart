import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttercurr/core/providers/app_state_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Authentication{
  static Future<User?> initialize() async{

    User? user = FirebaseAuth.instance.currentUser;
    print(user.toString());
    // if(user != null){
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (context)=>CurrencyDashboard(
    //       user: user,
    //     )),
    //   );
    // }
    return user;
  }
  static Future<bool> signinWithEmail(BuildContext context,{required String email,required String password,bool newUser = false})async{
    try{
      UserCredential credential = newUser
          ? await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email,
          password: password)
          : await FirebaseAuth.instance.signInWithEmailAndPassword(email: email,
          password: password);
      if(credential?.user != null){
        return true;
      }
      Provider.of<AppStateManager>(context,listen: false).curError = "Error occurred";
      return false;
    } on FirebaseAuthException catch(e){
      Provider.of<AppStateManager>(context,listen: false).curError = e.message;
      return false;
    }
  }
  static Future<bool> loginWithGoogle(BuildContext context)async{
    try{
      final signInAccount = await GoogleSignIn().signIn();
      final signInAuthentication = await signInAccount?.authentication;
      final credential =   GoogleAuthProvider.credential(
          accessToken: signInAuthentication?.accessToken,
          idToken: signInAuthentication?.idToken
      );
      UserCredential? userCredential =  await FirebaseAuth.instance.signInWithCredential(credential);
      if(userCredential?.user != null){
        return true;
      }
      Provider.of<AppStateManager>(context,listen: false).curError = "Error occurred";
      return false;
    } on FirebaseAuthException catch(e){
      Provider.of<AppStateManager>(context,listen: false).curError = e.message;
      return false;
    }
  }

  static Future<bool> signInWithTwitter(BuildContext context) async {
    // Create a TwitterLogin instance
    // print(dotenv.env);
    // return null;
    try{
      Map env = dotenv.env;
      final twitterLogin = TwitterLogin(
          apiKey: env['TWITTER_API_KEY']!,
          apiSecretKey: env['TWITTER_S_KEY']!,
          redirectURI: 'flutter-curr://'
      );

      print(twitterLogin);
      // Trigger the sign-in flow
      final authResult = await twitterLogin.login();

      print(authResult.status.toString());
      // Create a credential from the access token
      final twitterAuthCredential = TwitterAuthProvider.credential(
        accessToken: authResult.authToken!,
        secret: authResult.authTokenSecret!,
      );
      print(twitterAuthCredential);
      //
      // // Once signed in, return the UserCredential
      UserCredential? userCredential =  await FirebaseAuth.instance.signInWithCredential(twitterAuthCredential);
      if(userCredential?.user != null){
        return true;
      }
      Provider.of<AppStateManager>(context,listen: false).curError = "Error occurred";
      return false;
    } on FirebaseAuthException catch(e){
      Provider.of<AppStateManager>(context,listen: false).curError = e.message;
      return false;
    }
  }
  static Future<void> signOut()async{
    await FirebaseAuth.instance.signOut();
  }
}