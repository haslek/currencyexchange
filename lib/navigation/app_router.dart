import 'package:flutter/cupertino.dart';
import 'package:fluttercurr/core/providers/providers.dart';
import 'package:fluttercurr/ui/pages.dart';
import '../ui/pages/screens.dart';

class AppRouter extends RouterDelegate with ChangeNotifier,
    PopNavigatorRouterDelegateMixin{

  @override
  final GlobalKey<NavigatorState> navigatorKey;
  AppRouter({
    required this.appStateManager,
  }):
        navigatorKey = GlobalKey<NavigatorState>(){
    appStateManager.addListener(notifyListeners);
  }
  final AppStateManager appStateManager;

  @override
  Widget build(BuildContext context) {

    return Navigator(
      key: navigatorKey,
      onPopPage: _handlePop,
      pages: [
        if(!appStateManager.loggedIn)
          AuthenticationScreen.page(),
        if(appStateManager.loggedIn)
          CurrencyDashboard.page(),
        if(appStateManager.loggedIn && appStateManager.history)
          HistoricalData.page(),
        if(appStateManager.loggedIn && appStateManager.convert)
          CurrencyConverterPage.page(),
      ],
    );
  }

  bool _handlePop(Route<dynamic> route,result){
    if(!route.didPop(result)) {
      return false;
    }
    if(route.settings.name == AppPages.histPage){
      appStateManager.history = false;
    }
    if(route.settings.name == AppPages.convertPage){
      appStateManager.convert = false;
    }
    return true;
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    super.dispose();
  }




  @override
  Future<void> setNewRoutePath(configuration)async {
    // return null;
  }
}