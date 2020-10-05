import 'package:flutter/material.dart';
import 'dart:async';
import '../models/card_model.dart';
import 'card_column.dart';
import 'card/title_part.dart';

class PlayingCard extends StatefulWidget {
  final double top;
  final double bottom;
  final CardModel card;
  final List<CardModel> cardColumn;
  final int cardIndex;
  final int columnIndex;
  final bool dragging;

  PlayingCard(
      {this.top,
      this.bottom,
      this.card,
      this.cardColumn,
      this.cardIndex,
      this.columnIndex,
      this.dragging = false});

  @override
  _PlayingCardState createState() => _PlayingCardState(dragging: dragging);
}

class _PlayingCardState extends State<PlayingCard> {
  Timer _timer;
  var top = 0.0;
  var left = 0.0;
  final bool dragging;

  _PlayingCardState({this.dragging}) {
    print('dragging $dragging');
    if (!dragging) {
      _timer = new Timer(Duration(microseconds: 1000), () {
        setState(() {
          top = widget.top;
          left = widget.columnIndex * 95.0;
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    if (!dragging) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;

    final cardwiget = CardWidget(
      width: width,
      card: widget.card,
    );

    return AnimatedPositioned(
      duration: Duration(milliseconds: 1400 - widget.columnIndex * 200),
      // duration: Duration(milliseconds: 1000),
      curve: Curves.bounceIn,
      top: top,
      // comment this to reproduce
      // left: left,
      child: widget.card.played
          ? Draggable<Map>(
              feedbackOffset: Offset.fromDirection(10, 10),
              // key: UniqueKey(),
              child: cardwiget,
              childWhenDragging: cardwiget,
              onDragStarted: () {
                print('started!!!');
              },
              feedback: Material(
                color: Colors.transparent,
                child: CardColumn(
                    dragging: true,
                    cards: widget.cardColumn.sublist(widget.cardIndex),
                    columnIndex: widget.columnIndex),
              ),
              data: {
                'columnIndex': widget.columnIndex,
                'cardIndex': widget.cardIndex
              },
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
