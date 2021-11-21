import 'package:assignment/configs/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Utils {
  static Widget buildAppBar(BuildContext context, String title, {bool isShowBackButton = true}) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          isShowBackButton
              ? GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: SizedBox(
                      width: 50,
                      child: Container(
                        color: Colors.transparent,
                        child: SvgPicture.asset(
                          'assets/arrow-back.svg',
                          color: Colors.white,
                        ),
                      )))
              : Container(),
          Expanded(
              child: Text(
            title,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
            textAlign: TextAlign.center,
          )),
          SizedBox(
            width: isShowBackButton ? 50 : 0,
          )
        ],
      ),
      backgroundColor: Constants.primaryColor,
      elevation: 0.0,
      leading: null,
      leadingWidth: 0,
      automaticallyImplyLeading: false,
    );
  }

  static void showMessage(String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: null,
            content: Text(message),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'))
            ],
          );
        });
  }
}
