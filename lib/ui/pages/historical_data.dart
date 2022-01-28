import 'package:flutter/material.dart';
import 'package:fluttercurr/base/base_view.dart';
import 'package:fluttercurr/ui/page_models/hist_view_model.dart';

import '../pages.dart';
class HistoricalData extends StatelessWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: AppPages.histPage,
      key: ValueKey(AppPages.histPage),
      child: const HistoricalData(),
    );
  }
  const HistoricalData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<HistoryViewModel>(
      model: HistoryViewModel(),
      onModelReady: (model)=>model.onReady(context),
      builder: (context,model,_) {
        return Scaffold(
            body: Container()
        );
      }
    );
  }
}
