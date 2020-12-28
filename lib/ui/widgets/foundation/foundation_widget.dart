import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:solitaire_app/domain/state/providers/game.dart';
import 'package:solitaire_app/ui/widgets/foundation/foundation_klondike.dart';
import 'package:solitaire_app/ui/widgets/foundation/foundation_spider.dart';

class FoundationWidget extends StatelessWidget {
  const FoundationWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<Game, String>(
        builder: (context, gameType, child) {
          return gameType == 'spider'
              ? const FoundationSpider()
              : const FoundationKlondike();
        },
        selector: (ctx, game) => game.type);
  }
}
