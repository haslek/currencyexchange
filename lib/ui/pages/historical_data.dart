import 'package:flutter/material.dart';
import 'package:fluttercurr/base/base_view.dart';
import 'package:fluttercurr/core/providers/currency_provider.dart';
import 'package:fluttercurr/ui/components/app_drop_down.dart';
import 'package:fluttercurr/ui/page_models/hist_view_model.dart';
import 'package:provider/provider.dart';

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
        onModelReady: (model) => model.onReady(context),
        builder: (context, model, _) {
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text('Historical rates for ' +
                    model.currChosen.value),
              ),
              backgroundColor: Colors.blue.withOpacity(.3),
              body: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Date',
                              style: TextStyle(
                                color: Colors.blue.shade100,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: model.selectDate,
                            child: Container(
                              height: 50,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.blue.withOpacity(.8),
                                ),
                              ),
                              // alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      model.date,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: buildDropDown(context, model.currDrop, 'Currency', model.currChosen, model.onCurrencyChange, 200)),
                    Flexible(
                      flex:7,
                      child: Container(
                        color: Colors.blue.withOpacity(.3),
                        child: Consumer<CurrencyProvider>(
                          builder: (context,cProvider,_) {
                            return cProvider.history.keys.isEmpty? Center(
                              child: Text('No history data to display for ${model.currChosen.value} on ${model.date}',style: const TextStyle(
                                color: Colors.white
                              ),),
                            ):ListView(
                              children: cProvider.history.keys.map((element) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 2),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.yellowAccent)
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${model.currChosen.value} / $element :',
                                          style:  TextStyle(color: Colors.white.withOpacity(0.3)),),
                                        Text(cProvider.history[element].toString(),
                                          style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          }
                        ),
                      ),
                    )
                  ],
                ),
              ));
        });
  }
}
