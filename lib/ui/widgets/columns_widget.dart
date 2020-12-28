import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:solitaire_app/domain/state/providers/game.dart';
import 'package:solitaire_app/ui/widgets/card_column.dart';

class ColumnsWidget extends StatelessWidget {
  const ColumnsWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      buildCardColumn(0, context),
      buildCardColumn(1, context),
      buildCardColumn(2, context),
      buildCardColumn(3, context),
      buildCardColumn(4, context),
      buildCardColumn(5, context),
      buildCardColumn(6, context),
      buildCardColumn(7, context),
      buildCardColumn(8, context),
      buildCardColumn(9, context),
    ]);
  }
}

Selector<Game, List> buildCardColumn(int index, BuildContext context) {
  final gameData = Provider.of<Game>(context, listen: false);
  return Selector<Game, List>(
    selector: (_ctx, game) =>
        game.columns.isNotEmpty && game.columns.length > index
            ? game.columns[index]
            : null,
    builder: (_ctx, columnsData, _child) {
      return columnsData == null
          ? Container()
          : CardColumn(
              gameInitial: gameData.initial,
              gameType: gameData.type,
              columnCount: gameData.columns.length,
              cards: columnsData,
              columnIndex: index,
              width: MediaQuery.of(context).size.width);
    },
  );
}
