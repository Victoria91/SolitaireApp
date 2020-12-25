import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:solitaire_app/domain/models/card_model.dart';
import 'package:solitaire_app/domain/models/suit_foundation_model.dart';
import 'package:solitaire_app/domain/state/providers/game.dart';
import 'package:solitaire_app/ui/widgets/foundation/suit_foundation.dart';

class FoundationKlondike extends StatelessWidget {
  const FoundationKlondike({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildFoundation('spade', 3, context),
        buildFoundation('club', 4, context),
        buildFoundation('diamond', 5, context),
        buildFoundation('heart', 6, context),
      ],
    );
  }
}

Widget buildFoundation(String suit, int position, BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  final gameData = Provider.of<Game>(context, listen: false);
  return Selector<Game, SuitFoundationModel>(
      selector: (_ctx, game) => game.suitFoundation(suit),
      builder: (_ctx, foundation, _child) {
        print('rebuilding $suit......');
        print(foundation);
        // print(gameData.foundationHeart);

        // print('suitFoundation======${gameData.suitFoundation(suit)}');

        return gameData.suitFoundation(suit) == null
            ? Container()
            : SuitFoundation(
                columnsCount: gameData.columns.length,
                height: mediaQuery.size.height,
                isLandscape: mediaQuery.orientation == Orientation.landscape,
                foundation: gameData.suitFoundation(suit),
                width: mediaQuery.size.width,
                suit: CardModel.fetchSuit(suit),
                position: position,
                gameInitial: gameData.initial);
        // : SuitFoundation(
        //     columnsCount: gameData.columns.length,
        //     height: mediaQuery.size.height,
        //     isLandscape: mediaQuery.orientation == Orientation.landscape,
        //     foundation: foundation,
        //     width: mediaQuery.size.width,
        //     suit: CardModel.fetchSuit(suit),
        //     position: position,
        //     gameInitial: gameData.initial);
      },
      shouldRebuild: (previous, next) {
        // print('previous====$previous');
        // print('next====$next');
        print(previous == next);
        if (previous == null) {
          return true;
        }
        return !(previous == next);
        // return previous['rank'] != next['rank'];
      });
}
