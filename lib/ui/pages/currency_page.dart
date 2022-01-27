import 'package:flutter/material.dart';
import 'package:fluttercurr/base/base_view.dart';
import 'package:fluttercurr/ui/page_models/cur_view_model.dart';

import '../pages.dart';

class CurrencyDashboard extends StatefulWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: AppPages.authPage,
      key: ValueKey(AppPages.authPage),
      child: const CurrencyDashboard(),
    );
  }
  const CurrencyDashboard({Key? key}) : super(key: key);

  @override
  _CurrencyDashboardState createState() => _CurrencyDashboardState();
}

class _CurrencyDashboardState extends State<CurrencyDashboard> {
  @override
  Widget build(BuildContext context) {
    return BaseView<CurrencyPageViewModel>(
      model: CurrencyPageViewModel(),
      onModelReady: (model)=>model.onReady(context),
      builder: (context,model,_) {
        return Scaffold(
          backgroundColor: Colors.blue.withOpacity(.3),
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Current Exchange'),
          ),
          body: Column(
            children: [
              Center(
                child: Text(model.user?.displayName??'guest'),
              ),
            ],
          ),
        );
      }
    );
  }
}
