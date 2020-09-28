import 'package:flutter/material.dart';
import 'package:solitaire_app/models/card_model.dart';

import '../widgets/playing_card.dart';

class CardColumn extends StatelessWidget {
  final List<CardModel> cards;
  final Function moveFromColumnHandler;
  final Function moveFromDeckHandler;
  final int columnIndex;

  CardColumn({
    @required this.cards,
    @required this.columnIndex,
    @required this.moveFromColumnHandler,
    this.moveFromDeckHandler,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;

    return Container(
      width: width / 8,
      height: height,
      child: DragTarget<Map>(
        onAccept: (data) {
          if (data['move_from_deck'] != null) {
            print('handling move_from_deck+++');
            moveFromDeckHandler(columnIndex);
          } else {
            moveFromColumnHandler(
                data['columnIndex'], data['cardIndex'], columnIndex);
          }
        },
        onWillAccept: (data) {
          print('onWillAccept++$data');
          if (data['columnIndex'] == columnIndex) {
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
                    handler: moveFromColumnHandler,
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
