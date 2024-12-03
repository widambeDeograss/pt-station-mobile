import 'package:flutter/material.dart';

class CustomerDialog {
  static dismiss(BuildContext context) {
    Navigator.pop(context);
  }

  static show(BuildContext context, Color bg, Color textColor, String msg) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              insetPadding: const EdgeInsets.all(20),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Container(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: Row(
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(width: 20.0),
                            Flexible(
                                child: Text(msg,
                                    style: TextStyle(color: textColor)))
                          ],
                        ),
                      ))
                ],
              ));
        });
  }
}
