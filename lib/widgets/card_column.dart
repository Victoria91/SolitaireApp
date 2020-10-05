import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game.dart';
import '../models/card_model.dart';
import '../widgets/playing_card.dart';

class CardColumn extends StatelessWidget {
  final List<CardModel> cards;
  final int columnIndex;
  final bool dragging;

  CardColumn(
      {@required this.cards,
      @required this.columnIndex,
      this.dragging = false});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;

    final providerData = Provider.of<Game>(context);

    return Container(
      width: width / 8,
      height: height,
      child: DragTarget<Map>(
        onAccept: (data) {
          if (data['move_from_deck'] != null) {
            providerData.pushMoveFromDeckEvent(columnIndex);
          } else {
            providerData.pushMoveFromColumnEvent(
                data['columnIndex'], data['cardIndex'], columnIndex);
          }
        },
        onWillAccept: (data) {
          if (data['columnIndex'] == columnIndex) {
            return false;
          }

          return true;
        },
        builder: (ctx, data2, rejectedData) => Stack(
          overflow: Overflow.visible,
          children: cards
              .asMap()
              .entries
              .map(
                (card) => PlayingCard(
                    dragging: dragging,
                    top:
                        //  dragging
                        (card.key * 20).toDouble(),
                    // : (120 + card.key * 20).toDouble(),
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
