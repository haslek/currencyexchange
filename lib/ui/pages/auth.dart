import 'package:flutter/gestures.dart';
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
        onModelReady: (model) => model.onReady(context),
        builder: (context, model, _) {
          return Scaffold(
              backgroundColor: Colors.blue.shade200,
              body: model.initialized
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                                child: TextFormField(
                                  controller:model.emailController,
                                  decoration: InputDecoration(
                                      hintText: 'Enter email here',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                          width: 1.4,
                                        ),
                                      ),
                                      labelText: 'Email'),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                                child: TextFormField(
                                  controller: model.passController,
                                  obscureText: model.obscurePass,
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        onPressed: model.togglePass,
                                          icon: Icon(model.obscurePass ? Icons.visibility:Icons.visibility_off)),
                                      hintText: 'Enter password here',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                          width: 1.4,
                                        ),
                                      ),
                                      labelText: 'Password'),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              if (model.newUser)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                                  child: TextFormField(
                                    controller: model.cPassController,
                                    obscureText: model.obscurePass,
                                    decoration: InputDecoration(
                                      suffixIcon:  IconButton(
                                          onPressed: model.togglePass,
                                          icon: Icon(model.obscurePass ? Icons.visibility:Icons.visibility_off)),
                                        hintText: 'Confirm password here',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(14),
                                          borderSide: const BorderSide(
                                            color: Colors.white,
                                            width: 1.4,
                                          ),
                                        ),
                                        labelText: 'Confrim Password'),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Center(
                            child: AppButton(
                          text: model.newUser ?'Sign up':'Sign in',
                          action: model.signInWithEmail,
                          disabled: model.isLoading,
                        )),
                        RichText(
                            text: TextSpan(
                          text: model.newUser ? 'Have an account? ':'Don\'t have an account? ',
                              children: [
                                TextSpan(
                                  text: model.newUser?'Login here':'Sign up here',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = model.toggleForm,
                                )
                              ]
                        )),
                        const SizedBox(height: 10,),
                        const Center(
                          child: Text('OR',style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),),
                        ),
                        Center(
                            child: AppButton(
                          text: 'Sign in with Google',
                          action: model.signInWithGoogle,
                          disabled: model.isLoading,
                        )),
                        Center(
                            child: AppButton(
                          text: 'Sign in with Twitter',
                          action: model.signInWithTwitter,
                          disabled: model.isLoading,
                        )),
                      ],
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ));
        });
  }
}
