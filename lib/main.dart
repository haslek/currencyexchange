import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttercurr/core/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'core/providers/app_state_manager.dart';
import 'core/providers/currency_provider.dart';
import 'firebase_options.dart';
import 'navigation/app_router.dart';

Future<void> main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await runZonedGuarded(()async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
     await dotenv.load();
     runApp(const MyApp());
  },  (error,stacktrace){
    // FirebaseCrashlytics.instance.recordError(error,stacktrace);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const AppRoot(),
    );
  }
}


class AppRoot extends StatefulWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  _AppRootState createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {

  final _appStateManager = AppStateManager();
  final _userManager = UserProvider();
  final _currencyManager = CurrencyProvider();
  late AppRouter _appRouter;

  @override
  void initState() {
    _appRouter = AppRouter(
        appStateManager: _appStateManager
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => _userManager),
        ChangeNotifierProvider(
          create: (context) => _appStateManager,
        ),
        ChangeNotifierProvider(
          create: (context) => _currencyManager,
        ),
      ],
      child: Consumer<AppStateManager>(
        builder: (context,appManager,child){
          ThemeData themeData = ThemeData();

          return MaterialApp(
            theme: themeData,
            home: Router(
              routerDelegate: _appRouter,
              backButtonDispatcher: RootBackButtonDispatcher(),
            ),
          );
        },
      ),
    );
  }
}

