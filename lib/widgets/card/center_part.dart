import 'package:flutter/material.dart';
import 'package:solitaire_app/models/card_model.dart';

import 'dart:math';

class CenterPart extends StatelessWidget {
  const CenterPart({
    Key key,
    @required this.card,
    @required this.constaints,
    @required this.isLandscape,
  }) : super(key: key);

  final CardModel card;
  final BoxConstraints constaints;
  final bool isLandscape;

  @override
  Widget build(BuildContext context) {
    final color = card.isRed() ? Colors.red : Colors.black;

    final icon = card.icon();

    if (card.rank == 'A' || !isLandscape) {
      return Column(children: [
        Icon(
          icon,
          size: isLandscape ? 70 : 27,
          color: color,
        ),
      ]);
    } else if (['J', 'D', 'K'].contains(card.rank) && isLandscape) {
      return Column(children: [
        Image(
            image: NetworkImage(
                'https://bfa.github.io/solitaire-js/img/face-jack-spade.png'),
            width: constaints.maxWidth,
            height: constaints.maxHeight / 1.6)
      ]);
    } else {
      return Column(children: [
        Icon(
          icon,
          size: 24,
          color: color,
        ),
        Icon(
          icon,
          size: 24,
          color: color,
        ),
        Transform.rotate(
          angle: pi,
          child: Icon(
            icon,
            size: 24,
            color: color,
          ),
        )
      ]);
    }
  }
}
