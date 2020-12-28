import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogWrapper extends StatelessWidget {
  const DialogWrapper({
    Key key,
    this.actions,
    this.content,
    this.titleText,
  }) : super(key: key);

  final List<Widget> actions;
  final Widget content;
  final String titleText;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoAlertDialog(
            actions: actions ?? [],
            content: content,
            title: Text(titleText),
          )
        : AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: content,
            actions: actions ?? [],
            title: Text(titleText),
          );
  }
}
