import 'package:flutter/material.dart';

Future<void> showAlertDialog(BuildContext context, Widget dialogWidget) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext _context) {
      return dialogWidget;
    },
  );
}
