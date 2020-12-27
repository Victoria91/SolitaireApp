import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:solitaire_app/domain/state/providers/game.dart';
import 'package:solitaire_app/ui/widgets/dialogs/dialog_wrapper.dart';

class ChooseNewGameDialog extends StatelessWidget {
  const ChooseNewGameDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogWrapper(
      titleText: 'Start a new game',
      content: Container(
        height: 250,
        width: 100,
        child: ListView(children: const [
          SelectGameButton(
            color: Colors.purple,
            type: 'klondike',
            suitCount: 1,
            text: 'Klondike by ones',
          ),
          SelectGameButton(
            color: Colors.blue,
            type: 'klondike',
            suitCount: 3,
            text: 'Klondike by threes',
          ),
          SelectGameButton(
            color: Colors.purple,
            type: 'spider',
            suitCount: 1,
            text: 'Spider one suit',
          ),
          SelectGameButton(
            color: Colors.blue,
            type: 'spider',
            suitCount: 2,
            text: 'Spider two suits',
          ),
          SelectGameButton(
            color: Colors.purple,
            type: 'spider',
            suitCount: 4,
            text: 'Spider four suits',
          ),
        ]),
      ),
    );
  }
}

class SelectGameButton extends StatelessWidget {
  const SelectGameButton(
      {Key key,
      @required this.color,
      @required this.text,
      @required this.type,
      @required this.suitCount})
      : super(key: key);

  final MaterialColor color;
  final String text;
  final String type;
  final int suitCount;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        height: 30,
        color: color,
        onPressed: () {
          Provider.of<Game>(context, listen: false)
              .startNewGame(type, suitCount);
          Navigator.of(context).pop();
        },
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ));
  }
}
