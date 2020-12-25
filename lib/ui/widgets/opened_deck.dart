import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:solitaire_app/domain/state/providers/game.dart';
import 'package:solitaire_app/services/position_calculation.dart';

import 'card/card_widget.dart';

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
                    left: gameData.suitCount == 3
                        ? PositionCalculations.deckCardPostion(
                            MediaQuery.of(context).size.width,
                            gameData.columns.length,
                            card.key)
                        : PositionCalculations.columnLeftPosition(
                                MediaQuery.of(context).size.width,
                                gameData.columns.length,
                                2) -
                            15,
                    child: card.value.moveable
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
