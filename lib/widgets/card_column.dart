import 'package:flutter/material.dart';
import 'package:solitaire_app/models/card_model.dart';

import '../widgets/playing_card.dart';

class CardColumn extends StatelessWidget {
  final List<CardModel> cards;
  final Function handler;
  final int columnIndex;

  CardColumn(this.cards, this.columnIndex, this.handler);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;

    return Container(
      width: width / 8,
      height: height,
      child: DragTarget<List<int>>(
        onAccept: (data) {
          handler(data[0], data[1], columnIndex);
        },
        onWillAccept: (data) {
          if (data[0] == columnIndex) {
            return false;
          }

          return true;
        },
        builder: (ctx, data2, rejectedData) => Stack(
          children: cards
              .asMap()
              .entries
              .map(
                (card) => PlayingCard(
                    handler: handler,
                    top: (card.key * 20).toDouble(),
                    card: card.value,
                    cardColumn: cards,
                    columnIndex: columnIndex,
                    cardIndex: card.key),
              )
              .toList(),
        ),
      ),
    );
  }
}
