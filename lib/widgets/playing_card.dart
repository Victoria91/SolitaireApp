import 'package:flutter/material.dart';
import 'package:solitaire_app/models/card_model.dart';
import 'card/title_part.dart';

import '../widgets/card_column.dart';

class PlayingCard extends StatelessWidget {
  final double top;
  final double bottom;
  final Function handler;
  final CardModel card;
  final List<CardModel> cardColumn;
  final int cardIndex;
  final int columnIndex;

  PlayingCard(
      {this.top,
      this.bottom,
      this.card,
      this.cardColumn,
      this.cardIndex,
      this.handler,
      this.columnIndex});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;

    final cardwiget = CardWidget(
      width: width,
      card: card,
    );
    return Positioned(
      top: top,
      child: card.played
          ? Draggable(
              child: cardwiget,
              childWhenDragging: cardwiget,
              feedback: Material(
                color: Colors.transparent,
                child: CardColumn(
                    cardColumn.sublist(cardIndex), columnIndex, handler),
              ),
              data: [columnIndex, cardIndex],
            )
          : cardwiget,
    );
  }
}

class CardWidget extends StatelessWidget {
  final CardModel card;
  const CardWidget({
    this.card,
    @required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width / 8,
        height: width / 7 * 1.15,
        child: card.played
            ? Column(children: [
                if (card.played) TitlePart(card.rank, card.suit, 'top'),
                Image(
                  image: NetworkImage(
                      'https://bfa.github.io/solitaire-js/img/face-jack-spade.png'),
                  width: 50,
                  height: 70,
                ),
                TitlePart(card.rank, card.suit, 'down'),
              ])
            : null,
        decoration: BoxDecoration(
          border: Border.all(),
          color: card.played ? Colors.white : Colors.blue,
          borderRadius: BorderRadius.circular(
            10,
          ),
        ));
  }
}
