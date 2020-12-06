import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'card_widget.dart';
import '../models/card_model.dart';
import '../providers/game.dart';

class ClosedDeck extends StatelessWidget {
  final String gameType;
  const ClosedDeck({
    Key key,
    @required this.gameType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<Game>(context, listen: false);

    final offsetBetweenCards = gameType == 'klondike' ? 2 : 8;

    return Selector<Game, int>(
        selector: (ctx, game) => gameProvider.deckLength,
        builder: (context, deckLength, child) => deckLength > 0
            ? Stack(
                overflow: Overflow.visible,
                children: [
                  if (deckLength > 1)
                    ...List.generate(deckLength - 1, (i) => i)
                        .map((e) => Positioned(
                            left: (e * offsetBetweenCards).toDouble(),
                            child: CardWidget(
                              needShadow: gameType == 'spider',
                              card: CardModel(played: false),
                            ))),
                  Positioned(
                    left: ((deckLength - 1) * offsetBetweenCards).toDouble(),
                    child: InkWell(
                      focusColor: Colors.amber,
                      onTap: gameType == 'spider'
                          ? gameProvider.pushMoveFromDeckEventSpider
                          : gameProvider.pushChangeEvent,
                      child: CardWidget(
                        card: CardModel(played: false),
                      ),
                    ),
                  ),
                ],
              )
            : Container());
  }
}
