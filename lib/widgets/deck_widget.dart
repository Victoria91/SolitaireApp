import 'package:flutter/material.dart';

import '../models/card_model.dart';
import 'playing_card.dart';

class DeckWidget extends StatelessWidget {
  const DeckWidget({
    Key key,
    @required this.deck,
    @required this.mediaQuery,
  }) : super(key: key);

  final List<CardModel> deck;
  final MediaQueryData mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Stack(
        overflow: Overflow.visible,
        children: deck.asMap().entries.map((card) {
          final cardWidget = CardWidget(
            width: mediaQuery.size.width,
            card: card.value,
          );
          return Positioned(
              left: (card.key * 20).toDouble(),
              child: (true)
                  ? Draggable<Map>(
                      data: {'move_from_deck': true},
                      feedback: cardWidget,
                      childWhenDragging: Container(),
                      child: cardWidget,
                    )
                  : cardWidget);
        }).toList());
  }
}
