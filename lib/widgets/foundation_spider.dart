import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/game.dart';
import '../models/card_model.dart';
import 'suit_foundation.dart';

class FoundationSpider extends StatelessWidget {
  const FoundationSpider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameData = Provider.of<Game>(context, listen: false);
    final foundation = gameData.foundation;
    final mediaQuery = MediaQuery.of(context);

    return Selector<Game, List>(
      selector: (ctx, game) => game.foundation['sorted'],
      builder: (context, sortedSuits, child) => Stack(children: [
        ...foundation['sorted']
            .asMap()
            .entries
            .map((suit) => buildFoundation(suit.value, foundation[suit.value],
                suit.key, context, suit.key == foundation['sorted'].length - 1))
            .toList(),
        ...List.generate(
            8 - foundation['sorted'].length,
            (index) => SuitFoundation(
                  columnsCount: gameData.columns.length,
                  width: mediaQuery.size.width,
                  foundation: {},
                  height: mediaQuery.size.height,
                  position: 8 - index + 1,
                  gameInitial: false,
                  isLandscape: mediaQuery.orientation == Orientation.landscape,
                ))
      ]),
    );
  }
}

Widget buildFoundation(String suit, Map suitFoundation, int position,
    BuildContext context, bool last) {
  final mediaQuery = MediaQuery.of(context);
  final gameData = Provider.of<Game>(context, listen: false);

  print('==========last $last');

  print(suitFoundation.isNotEmpty && suitFoundation['changed'] == true);

  return SuitFoundation(
      columnsCount: gameData.columns.length,
      height: mediaQuery.size.height,
      isLandscape: mediaQuery.orientation == Orientation.landscape,
      foundation: suitFoundation,
      width: mediaQuery.size.width,
      changed: suitFoundation['changed'] == true && last,
      suit: CardModel.fetchSuit(suit),
      position: position + 2,
      gameInitial: false);
}
