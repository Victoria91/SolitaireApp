import 'package:flutter/material.dart';

import 'dart:math';

import '../../models/card_model.dart';

class TitlePart extends StatelessWidget {
  final position;
  final CardModel card;

  TitlePart(this.card, this.position);

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final color = card.isRed() ? Colors.red : Colors.black;

    final textWidget = Text(card.rank,
        style: TextStyle(
          fontSize: isLandscape ? 13 : 10,
          fontWeight: FontWeight.bold,
          color: color,
        ));

    final iconWidget = Icon(card.icon(), size: 9, color: color);
    return Transform.rotate(
      angle: position == 'top' ? 0 : pi,
      child: Container(
        margin: EdgeInsets.only(top: 3, left: 3, right: 3),
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
