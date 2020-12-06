import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solitaire_app/widgets/dialogs/choose_game_dialog.dart';

import '../../providers/game.dart';

import 'package:solitaire_app/main.dart';

class ConfirmNewGameDialog extends StatelessWidget {
  const ConfirmNewGameDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(20.0))),
          title: const Center(child: const Text('Start new game')),
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
              child: Text('Another game'),
              onPressed: () {
                Navigator.of(context).pop();

                showMyDialog(context, ChooseNewGameDialog());
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ]),
    );
  }
}
