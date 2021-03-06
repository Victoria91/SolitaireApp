import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:solitaire_app/domain/state/providers/game.dart';
import 'package:solitaire_app/ui/widgets/dialogs/choose_game_dialog.dart';
import 'package:solitaire_app/ui/widgets/dialogs/dialog_wrapper.dart';
import 'package:solitaire_app/ui/widgets/dialogs/show_alert_dialog.dart';

class ConfirmNewGameDialog extends StatelessWidget {
  const ConfirmNewGameDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogWrapper(
        titleText: 'Start a new game',
        content: const Text(
          'Are you sure you want to start a new game?',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Provider.of<Game>(context, listen: false).startNewGame();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Another game'),
            onPressed: () {
              Navigator.of(context).pop();

              showAlertDialog(context, const ChooseNewGameDialog());
            },
          ),
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ]);
  }
}
