import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/card_model.dart';
import 'playing_card.dart';
import '../providers/game.dart';

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
    final gameData = Provider.of<Game>(context);

    return Stack(
        overflow: Overflow.visible,
        children: deck.asMap().entries.map((card) {
          final cardWidget = CardWidget(
            width: mediaQuery.size.width,
            card: card.value,
          );

          return Positioned(
              left: (card.key * 20).toDouble(),
              child: (card.key == deck.length - 1)
                  ? Draggable<Map>(
                      data: {'move_from_deck': true, 'card': deck.last},
                      feedback: cardWidget,
                      childWhenDragging: Container(),
                      child: cardWidget,
                      onDraggableCanceled: (_velocity, _offset) =>
                          gameData.setDeck(deck),
                      onDragStarted: () => gameData.takeCardFromDeck(),
                      onDragCompleted: () async {
                        var canMoveRes = await gameData.canMove(
                            gameData.columns[gameData.activeColumnIndex].last
                                .toServer(),
                            deck.last.toServer());

                        if (!canMoveRes) {
                          gameData.setDeck(deck);
                        }
                      },
                    )
                  : cardWidget);
        }).toList());
  }
}
