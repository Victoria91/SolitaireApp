import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:solitaire_app/domain/models/card_model.dart';
import 'package:solitaire_app/domain/state/providers/game.dart';

import 'card/card_widget.dart';

class ClosedDeck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<Game>(context, listen: false);

    return Selector<Game, String>(
      selector: (ctx, game) => game.type,
      builder: (context, gameType, child) {
        final offsetBetweenCards = gameType == 'klondike' ? 2 : 8;
        return Selector<Game, int>(
            selector: (ctx, game) => game.deckLength,
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
                        left:
                            ((deckLength - 1) * offsetBetweenCards).toDouble(),
                        child: InkWell(
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
      },
    );
  }
}
