import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solitaire_app/services/position_calculation.dart';

import '../models/card_model.dart';
import 'playing_card.dart';
import '../providers/game.dart';

class DeckWidget extends StatelessWidget {
  const DeckWidget(
      {Key key,
      @required this.deck,
      @required this.mediaQuery,
      @required this.isLandscape})
      : super(key: key);

  final List<CardModel> deck;
  final MediaQueryData mediaQuery;
  final bool isLandscape;

  @override
  Widget build(BuildContext context) {
    final gameData = Provider.of<Game>(context, listen: false);

    return Stack(
        overflow: Overflow.visible,
        children: deck.asMap().entries.map((card) {
          final cardWidget = CardWidget(
            isLandscape: isLandscape,
            width: mediaQuery.size.width,
            card: card.value,
          );

          return Positioned(
              left: PositionCalculations.deckCardPostion(
                  mediaQuery.size.width, card.key),
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
                        if (gameData.activeColumnIndex != null &&
                            gameData.columns[gameData.activeColumnIndex]
                                .isNotEmpty) {
                          final canMoveRes = await gameData.canMove(
                              gameData.columns[gameData.activeColumnIndex].last
                                  .toServer(),
                              deck.last.toServer());

                          if (!canMoveRes) {
                            gameData.setDeck(deck);
                          }

                          gameData.unsetActiveColumnIndex();
                        }
                      },
                    )
                  : cardWidget);
        }).toList());
  }
}
