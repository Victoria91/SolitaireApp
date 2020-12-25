import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solitaire_app/domain/state/providers/game.dart';

class ChooseNewGameDialog extends StatelessWidget {
  const ChooseNewGameDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: const Center(child: const Text('Start new game')),
      content: Container(
        height: 250,
        width: 100,
        child: ListView(children: [
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
  final MaterialColor color;
  final String text;
  final String type;
  final int suitCount;
  const SelectGameButton(
      {Key key,
      @required this.color,
      @required this.text,
      @required this.type,
      @required this.suitCount})
      : super(key: key);

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
          style: TextStyle(color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ));
  }
}
