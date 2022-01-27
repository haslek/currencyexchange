import 'package:flutter/material.dart';

void showError(BuildContext context, String error) {
  Dialog cDialog = Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: SizedBox(
      height: 200,
      width: 200,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Avenir',
                      color: Colors.black),
                  text: error,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Dismiss',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: Color(0xFF479B8C),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  showDialog(
      context: context,
      useRootNavigator: false,
      builder: (BuildContext dContext) => cDialog);
}
