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
          ? Draggable<Map>(
              child: cardwiget,
              childWhenDragging: cardwiget,
              feedback: Material(
                color: Colors.transparent,
                child: CardColumn(
                    cards: cardColumn.sublist(cardIndex),
                    columnIndex: columnIndex,
                    moveFromColumnHandler: handler),
              ),
              data: {'columnIndex': columnIndex, 'cardIndex': cardIndex},
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
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
        width: width / 8,
        height: width / 7 * 1.15,
        child: card.played
            ? LayoutBuilder(
                builder: (BuildContext ctx, BoxConstraints constaints) {
                  return Column(children: [
                    TitlePart(card.rank, card.suit, 'top'),
                    Image(
                      image: NetworkImage(
                          'https://bfa.github.io/solitaire-js/img/face-jack-spade.png'),
                      width: isLandscape
                          ? constaints.maxWidth
                          : constaints.maxWidth / 1.7,
                      height: isLandscape
                          ? constaints.maxHeight / 1.6
                          : constaints.maxHeight / 1.9,
                    ),
                    TitlePart(card.rank, card.suit, 'down'),
                  ]);
                },
              )
            : null,
        decoration: BoxDecoration(
          border: Border.all(),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black54,
              blurRadius: 15.0,
              offset: Offset(0.0, 8),
            )
          ],
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.5),
          //     spreadRadius: 5,
          //     blurRadius: 7,
          //     offset: Offset(0, 3), // changes position of shadow
          //   ),
          // ],
          // border: Border.symmetric(
          //     horizontal: BorderSide(width: 2.0, color: Colors.black)),
          // Border(bottom: BorderSide(color: Theme.of(context).dividerColor))

          // border: Border(
          //   bottom: BorderSide(width: 2.0, color: Colors.black),
          // ),
          color: card.played ? Colors.white : Colors.blue,
          borderRadius: BorderRadius.circular(
            10,
          ),
        ));
  }
}
