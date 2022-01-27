import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttercurr/ui/pages/currency_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttercurr/firebase_options.dart';

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
  static Future<UserCredential?> signinWithEmail({required String email,required String password,bool newUser = false})async{
    try{
      UserCredential credential = newUser
          ? await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email,
          password: password)
          : await FirebaseAuth.instance.signInWithEmailAndPassword(email: email,
          password: password);
      return credential;
    } on FirebaseAuthException catch(e){
      print('Error signing in: ${e.code}');
    }
  }
  static Future<UserCredential?> loginWithGoogle()async{
    try{
      final signInAccount = await GoogleSignIn().signIn();
      final signInAuthentication = await signInAccount?.authentication;
      final credential =   GoogleAuthProvider.credential(
          accessToken: signInAuthentication?.accessToken,
          idToken: signInAuthentication?.idToken
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }catch (e){
      print(e.toString());
    }
  }

  static Future<UserCredential?> signInWithTwitter() async {
    // Create a TwitterLogin instance
    // print(dotenv.env);
    // return null;
    Map env = dotenv.env;
    final twitterLogin = TwitterLogin(
        apiKey: env['TWITTER_API_KEY']!,
        apiSecretKey: env['TWITTER_S_KEY']!,
        redirectURI: env['TWITTER_R_URI']!
    );

    // Trigger the sign-in flow
    final authResult = await twitterLogin.login();

    // Create a credential from the access token
    final twitterAuthCredential = TwitterAuthProvider.credential(
      accessToken: authResult.authToken!,
      secret: authResult.authTokenSecret!,
    );
    //
    // // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(twitterAuthCredential);
  }
  static Future<void> signout()async{
    await FirebaseAuth.instance.signOut();
  }
}