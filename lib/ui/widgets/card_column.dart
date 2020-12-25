import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:async';

import 'package:solitaire_app/domain/models/card_model.dart';
import 'package:solitaire_app/domain/state/providers/game.dart';
import 'package:solitaire_app/services/position_calculation.dart';

import '../widgets/playing_card.dart';

class CardColumn extends StatefulWidget {
  final List<CardModel> cards;
  final int columnIndex;
  final int columnCount;
  final bool dragging;
  final double width;
  final bool gameInitial;
  final String gameType;

  CardColumn(
      {Key key,
      @required this.cards,
      @required this.columnIndex,
      @required this.gameInitial,
      @required this.width,
      @required this.columnCount,
      @required this.gameType,
      this.dragging = false})
      : super(key: key ?? ObjectKey([cards]));

  @override
  _CardColumnState createState() => _CardColumnState(
      columnCount: columnCount,
      dragging: dragging,
      width: width,
      gameInitial: gameInitial,
      gameType: gameType,
      columnIndex: columnIndex);
}

class _CardColumnState extends State<CardColumn> {
  Timer _timer;
  var left = 0.0;
  final bool dragging;
  final double width;
  final int columnIndex;
  final bool gameInitial;
  final String gameType;
  final int columnCount;

  _CardColumnState(
      {@required this.dragging,
      @required this.width,
      @required this.columnCount,
      @required this.gameInitial,
      @required this.columnIndex,
      @required this.gameType}) {
    // since we can't use columns here because of animations, left property is calculated for each
    // column.
    final leftAfterAnimation = PositionCalculations.columnLeftPosition(
        width, columnCount, columnIndex);

    if (gameInitial) {
      _timer = Timer(Duration(microseconds: 1000), () {
        setState(() {
          left = leftAfterAnimation;

          Provider.of<Game>(context, listen: false).setInitial();
        });
      });
    } else if (!dragging) {
      left = leftAfterAnimation;
    }
  }

  @override
  void dispose() {
    super.dispose();

    if (_timer != null) {
      print('disposing...');
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;

    final providerData = Provider.of<Game>(context, listen: false);

    return AnimatedPositioned(
      duration: Duration(milliseconds: 1800 - widget.columnIndex * 200),
      left: left,
      child: Container(
        width: width / 8,
        height: height + 500,
        child: DragTarget<Map>(
          onAccept: (data) {
            if (data['move_from_deck'] == true) {
              providerData.setActiveColumnIndex(widget.columnIndex);
              providerData.pushMoveFromDeckEvent(widget.columnIndex);
            } else if (data['move_from_foundation'] == true) {
              providerData.pushMoveFromFoundation(
                  data['suit'], widget.columnIndex);
            } else {
              providerData.pushMoveFromColumnEvent(
                  data['columnIndex'], data['cardIndex'], widget.columnIndex);
            }
          },
          onWillAccept: (data) {
            if (data['columnIndex'] == widget.columnIndex) {
              return false;
            }

            return true;
          },
          builder: (ctx, _candidateData, _rejectedData) => Stack(
            overflow: Overflow.visible,
            children: widget.cards.asMap().entries.map(
              (card) {
                final isLandscape =
                    mediaQuery.orientation == Orientation.landscape;
                return PlayingCard(
                    last: card.key == widget.cards.length - 1,
                    width: width,
                    dragging: dragging,
                    gameInitial: gameInitial,
                    newCardSet: providerData.newCardSet,
                    columnCount: providerData.columns.length,
                    top: 10 +
                        (widget.dragging
                            ? PositionCalculations.columnTopPosition(
                                    totalHeight: height,
                                    totalWidth: width,
                                    cardIndex: card.key,
                                    isLandscape: isLandscape,
                                    columnsCount: providerData.columns.length) -
                                PositionCalculations.cardHeight(
                                  width,
                                  providerData.columns.length,
                                )
                            : PositionCalculations.columnTopPosition(
                                totalHeight: height,
                                totalWidth: width,
                                cardIndex: card.key,
                                columnsCount: providerData.columns.length,
                                isLandscape: isLandscape)),
                    card: card.value,
                    cardColumn: widget.cards,
                    columnIndex: widget.columnIndex,
                    cardIndex: card.key);
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}
