import 'package:flutter/material.dart';

import 'dart:math';

import '../../models/card_model.dart';

class TitlePart extends StatelessWidget {
  final position;
  final CardModel card;

  TitlePart(this.card, this.position);

  @override
  Widget build(BuildContext context) {
    final color = card.isRed() ? Colors.red : Colors.black;
    final totalWidth = MediaQuery.of(context).size.width;

    final textWidget = Text(card.rank,
        style: TextStyle(
          fontSize: max(totalWidth / 50, 9),
          fontWeight: FontWeight.bold,
          color: color,
        ));

    final iconWidget = Icon(card.icon(), size: totalWidth / 70, color: color);
    return Transform.rotate(
      angle: position == 'top' ? 0 : pi,
      child: Container(
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
