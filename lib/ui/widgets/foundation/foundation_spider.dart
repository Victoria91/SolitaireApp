import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:solitaire_app/domain/models/card_model.dart';
import 'package:solitaire_app/domain/models/sorted_foundation_model.dart';
import 'package:solitaire_app/domain/models/suit_foundation_model.dart';
import 'package:solitaire_app/domain/state/providers/game.dart';
import 'package:solitaire_app/ui/widgets/foundation/suit_foundation.dart';

class FoundationSpider extends StatelessWidget {
  const FoundationSpider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameData = Provider.of<Game>(context, listen: false);
    final mediaQuery = MediaQuery.of(context);

    return Selector<Game, SortedFoundationModel>(
      selector: (ctx, game) => game.foundationSorted,
      builder: (context, sortedSuitsModel, child) => Stack(children: [
        ...sortedSuitsModel.suits
            .asMap()
            .entries
            .map((suit) => buildFoundation(suit.value, suit.key, context,
                suit.key == sortedSuitsModel.suits.length - 1))
            .toList(),
        ...List.generate(
            sortedSuitsModel.unplayedCount,
            (index) => SuitFoundation(
                  columnsCount: gameData.columns.length,
                  width: mediaQuery.size.width,
                  foundation: const SuitFoundationModel(),
                  height: mediaQuery.size.height,
                  position: 8 - index + 1,
                  gameInitial: false,
                  isLandscape: mediaQuery.orientation == Orientation.landscape,
                ))
      ]),
    );
  }
}

Widget buildFoundation(
    String suit, int position, BuildContext context, bool last) {
  final mediaQuery = MediaQuery.of(context);
  final gameData = Provider.of<Game>(context, listen: false);

  final suitFoundation = gameData.suitFoundation(suit);

  return SuitFoundation(
      columnsCount: gameData.columns.length,
      height: mediaQuery.size.height,
      isLandscape: mediaQuery.orientation == Orientation.landscape,
      foundation: suitFoundation,
      width: mediaQuery.size.width,
      changed: gameData.foundationSorted.changed && last,
      suit: CardModel.fetchSuit(suit),
      position: position + 2,
      gameInitial: false);
}
