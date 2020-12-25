import 'package:flutter/material.dart';
import 'package:solitaire_app/domain/models/card_model.dart';

import 'title_part.dart';
import 'center_part.dart';
import 'card_container.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({@required this.card, this.needShadow = true});

  final CardModel card;
  final bool needShadow;

  @override
  Widget build(BuildContext context) => CardContainer(
        needShadow: needShadow,
        played: card.played,
        child: card.played
            ? LayoutBuilder(
                builder: (BuildContext _ctx, BoxConstraints constraints) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TitlePart(card, 'top'),
                        CenterPart(card: card, constraints: constraints),
                        TitlePart(card, 'down'),
                      ]);
                },
              )
            : null,
      );
}
