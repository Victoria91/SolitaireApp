import 'package:flutter/material.dart';
import 'package:solitaire_app/domain/models/card_model.dart';

import 'dart:math';

class CenterPart extends StatelessWidget {
  const CenterPart({
    Key key,
    @required this.card,
    @required this.constraints,
  }) : super(key: key);

  final CardModel card;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final color = card.isRed() ? Colors.red : Colors.black;

    final icon = card.icon();

    if (card.rank == CardRank.ace || constraints.maxHeight < 100) {
      return Column(children: [
        Icon(
          icon,
          size: constraints.maxHeight / 2.6,
          color: color,
        ),
      ]);
      // } else if (['J', 'D', 'K'].contains(card.rank) &&
    } else if ([CardRank.jack, CardRank.queen, CardRank.king]
            .contains(card.rank) &&
        constraints.maxHeight > 100) {
      return Column(children: [
        Image.asset(
            'assets/images/${card.rankString()}-${card.fetcSuitString()}.png',
            width: constraints.maxWidth,
            height: constraints.maxHeight / 1.9)
      ]);
    } else {
      final iconWidget = Icon(
        icon,
        size: constraints.maxHeight / 6,
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
