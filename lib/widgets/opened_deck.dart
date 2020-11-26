import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solitaire_app/services/position_calculation.dart';

import 'card_widget.dart';
import '../providers/game.dart';

class OpenedDeck extends StatelessWidget {
  const OpenedDeck({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameData = Provider.of<Game>(context, listen: false);

    return Selector<Game, List>(
      selector: (ctx, game) => gameData.deck,
      builder: (ctx, deck, child) => deck.isEmpty
          ? Container()
          : Stack(
              overflow: Overflow.visible,
              children: deck.asMap().entries.map((card) {
                final cardWidget = CardWidget(
                  card: card.value,
                );

                return Positioned(
                    left: PositionCalculations.deckCardPostion(
                        MediaQuery.of(context).size.width, card.key),
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
                                    gameData.columns[gameData.activeColumnIndex]
                                        .last
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
              }).toList()),
    );
  }
}
