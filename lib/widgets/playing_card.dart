import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:async';

import '../models/card_model.dart';
import 'card_column.dart';
import 'card/title_part.dart';
import '../providers/game.dart';

class PlayingCard extends StatefulWidget {
  final double top;
  final CardModel card;
  final List<CardModel> cardColumn;
  final int cardIndex;
  final int columnIndex;
  final bool dragging;
  final Game providerData;
  final bool isLandscape;

  PlayingCard(
      {@required this.top,
      @required this.providerData,
      @required this.card,
      @required this.cardColumn,
      @required this.cardIndex,
      @required this.columnIndex,
      @required this.isLandscape,
      this.dragging = false});

  @override
  _PlayingCardState createState() => _PlayingCardState(
      dragging: dragging, updatedTop: top, gameInitial: providerData.initial);
}

class _PlayingCardState extends State<PlayingCard> {
  Timer _timer;
  var top = 0.0;
  final bool dragging;
  final double updatedTop;
  final bool gameInitial;

  _PlayingCardState({this.dragging, this.updatedTop, this.gameInitial}) {
    if (!dragging && gameInitial) {
      _timer = Timer(Duration(microseconds: 1000), () {
        setState(() {
          top = widget.top;
        });
      });
    } else {
      top = updatedTop;
    }
  }

  @override
  void dispose() {
    super.dispose();

    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;

    final cardwiget = CardWidget(
      isLandscape: widget.isLandscape,
      width: width,
      card: widget.card,
    );

    final gameData = Provider.of<Game>(context);

    return AnimatedPositioned(
      duration: Duration(milliseconds: 1400 - widget.columnIndex * 200),
      curve: Curves.bounceIn,
      top: top,
      child: widget.card.played
          ? Draggable<Map>(
              child: cardwiget,
              childWhenDragging: cardwiget,
              onDraggableCanceled: (_velocity, _offset) =>
                  gameData.setColumns(widget.columnIndex, widget.cardColumn),
              onDragStarted: () => gameData.setColumns(widget.columnIndex,
                  widget.cardColumn.sublist(0, widget.cardIndex)),
              feedback: Material(
                color: Colors.transparent,
                child: Container(
                  width: width,
                  height: width / 7 * 1.15 +
                      widget.cardColumn.sublist(widget.cardIndex).length * 20 -
                      1,
                  child: Stack(children: [
                    CardColumn(
                        isLandscape: widget.isLandscape,
                        dragging: true,
                        cards: widget.cardColumn.sublist(widget.cardIndex),
                        columnIndex: widget.columnIndex),
                  ]),
                ),
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
  const CardWidget({
    @required this.card,
    @required this.width,
    @required this.isLandscape,
  });

  final CardModel card;
  final double width;
  final bool isLandscape;

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
        width: width / (isLandscape ? 8 : 9),
        height: width / 7 * 1.15,
        child: card.played
            ? LayoutBuilder(
                builder: (BuildContext ctx, BoxConstraints constaints) {
                  return Column(children: [
                    TitlePart(card.rank, card.suit, 'top'),
                    // Icon(
                    //   Icons.hail,
                    //   size: 15,
                    // ),
                    // Icon(Icons.hail),
                    // Icon(Icons.hail),
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
            isLandscape ? 10 : 8,
          ),
        ));
  }
}
