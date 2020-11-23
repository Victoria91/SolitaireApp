import 'package:flutter/material.dart';
import 'package:solitaire_app/models/card_model.dart';

import 'dart:math';

class CenterPart extends StatelessWidget {
  const CenterPart({
    Key key,
    @required this.card,
    @required this.constaints,
  }) : super(key: key);

  final CardModel card;
  final BoxConstraints constaints;

  @override
  Widget build(BuildContext context) {
    final color = card.isRed() ? Colors.red : Colors.black;

    final icon = card.icon();

    if (card.rank == 'A' || constaints.maxHeight < 100) {
      return Column(children: [
        Icon(
          icon,
          size: constaints.maxHeight / 2.1,
          color: color,
        ),
      ]);
    } else if (['J', 'D', 'K'].contains(card.rank) &&
        constaints.maxHeight > 100) {
      return Column(children: [
        Image(
            image: NetworkImage(
                'https://bfa.github.io/solitaire-js/img/face-jack-spade.png'),
            width: constaints.maxWidth,
            height: constaints.maxHeight / 1.8)
      ]);
    } else {
      final iconWidget = Icon(
        icon,
        size: constaints.maxHeight / 5.2,
        color: color,
      );
      return Column(children: [
        iconWidget,
        iconWidget,
        Transform.rotate(
          angle: pi,
          child: iconWidget,
        )
      ]);
    }
  }
}
