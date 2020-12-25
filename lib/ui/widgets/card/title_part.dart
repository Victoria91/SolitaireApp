import 'package:flutter/material.dart';

import 'dart:math';

import 'package:solitaire_app/domain/models/card_model.dart';

class TitlePart extends StatelessWidget {
  final position;
  final CardModel card;

  TitlePart(this.card, this.position);

  @override
  Widget build(BuildContext context) {
    if (card.rankString() == null) {
      print("CARD???????????????????????????? $card");
      print("CARD???????????????????????????? ${card.rankString()}");
    }
    final color = card.isRed() ? Colors.red : Colors.black;
    final totalWidth = MediaQuery.of(context).size.width;

    final textWidget = Material(
        color: Color.fromRGBO(255, 233, 236, 1),
        child: Text(card.rankString(),
            style: TextStyle(
              fontSize: max(totalWidth / 60, 9),
              fontWeight: FontWeight.bold,
              color: color,
            )));

    final iconWidget = Icon(card.icon(), size: totalWidth / 70, color: color);
    return Transform.rotate(
      angle: position == 'top' ? 0 : pi,
      child: Container(
        // height: 5,
        // width: 5,
        margin: EdgeInsets.all((totalWidth / 180)),
        child: Align(
          alignment: Alignment.topLeft,
          child: Row(children: [
            textWidget,
            iconWidget,
          ]),
        ),
      ),
    );
  }
}
