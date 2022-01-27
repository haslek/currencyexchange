import 'package:flutter/material.dart';
import 'package:fluttercurr/base/base_view.dart';
import 'package:fluttercurr/ui/components/app_buttons.dart';
import 'package:fluttercurr/ui/pages.dart';

import '../page_models/auth_view_model.dart';
class AuthenticationScreen extends StatefulWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: AppPages.authPage,
      key: ValueKey(AppPages.authPage),
      child: const AuthenticationScreen(),
    );
  }
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {

  @override
  Widget build(BuildContext context) {
    return BaseView<AuthenticationViewModel>(
      model: AuthenticationViewModel(),
      onModelReady: (model)=> model.onReady(context),
      builder: (context,model,_) {
        return Scaffold(
          backgroundColor: Colors.blue.shade200,
            body: model.initialized ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: AppButton(text: 'Sign in with Email', action: model.signInWithEmail,disabled: model.isLoading,)),
            const Divider(color: Colors.black, ),
            Center(child: AppButton(text: 'Sign in with Google', action: model.signInWithGoogle,disabled: model.isLoading,)),
            Center(child: AppButton(text: 'Sign in with Twitter', action: model.signInWithTwitter,disabled: model.isLoading,)),
          ],
        ): const Center(
              child: CircularProgressIndicator(),
            )
        );
      }
    );
  }
}
