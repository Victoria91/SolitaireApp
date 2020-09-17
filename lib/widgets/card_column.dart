import 'package:flutter/material.dart';
import 'package:solitaire_app/models/card_model.dart';

import '../widgets/playing_card.dart';

class CardColumn extends StatelessWidget {
  final List<CardModel> cards;

  CardColumn(this.cards);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;

    return Container(
      width: width / 8,
      height: height,
      child: DragTarget(
        onAccept: (data) {
          print(data);

          print("ACCEPTED");
        },
        onWillAccept: (data) {
          print('data+++$data');
          return false;
        },
        builder: (ctx, data, rejectedData) => Stack(
            children: cards
                .asMap()
                .entries
                .map((card) => PlayingCard(
                    top: (card.key * 30).toDouble(),
                    rank: card.value.rank,
                    last: card.key == cards.length - 1))
                .toList()),
      ),
    );
  }
}
