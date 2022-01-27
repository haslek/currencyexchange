import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback action;
  final bool disabled;
  final bool isLoading;
  final bool? inverted;
  final double? width;
  final Color? color;
  final double? height;
  const AppButton({
    Key? key,
    required this.text,
    required this.action,
    this.disabled = false,
    this.color,
    this.height,
    this.width,
    this.inverted,
    this.isLoading = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool inv = inverted ?? false;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
      child: GestureDetector(
          onTap: disabled ? null: action,
          child: Container(
              width: width ?? 200,
              height: height ?? 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: inv ? Colors.white
                    : Colors.black,
              ),
              child: isLoading ? const SpinKitThreeBounce(
                color:  Colors.blue,
                size: 24.0,) :Center(
                child: Text(text,
                  style:  TextStyle(
                      fontFamily: 'Avenir',
                      color: inv ? Colors.black
                          :Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                  ),
                ),
              )
          )
      ),
    );
  }
}
