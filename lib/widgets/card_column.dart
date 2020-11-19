import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solitaire_app/services/position_calculation.dart';

import 'dart:async';

import '../providers/game.dart';
import '../models/card_model.dart';
import '../widgets/playing_card.dart';

class CardColumn extends StatefulWidget {
  final List<CardModel> cards;
  final int columnIndex;
  final bool dragging;
  final double width;
  final bool isLandscape;
  final bool gameInitial;

  CardColumn(
      {Key key,
      @required this.cards,
      @required this.columnIndex,
      @required this.isLandscape,
      @required this.gameInitial,
      @required this.width,
      this.dragging = false})
      : super(key: key ?? ObjectKey([cards]));

  @override
  _CardColumnState createState() => _CardColumnState(
      dragging: dragging,
      width: width,
      gameInitial: gameInitial,
      columnIndex: columnIndex);
}

class _CardColumnState extends State<CardColumn> {
  Timer _timer;
  var left = 0.0;
  final bool dragging;
  final double width;
  final int columnIndex;
  final bool gameInitial;

  _CardColumnState(
      {this.dragging, this.width, this.gameInitial, this.columnIndex}) {
    // since we can't use columns here because of animations, left property is calculated for each
    // column.
    final leftAfterAnimation =
        PositionCalculations.columnLeftPosition(width, columnIndex);

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
      duration: Duration(milliseconds: 1200 - widget.columnIndex * 200),
      left: left,
      child: Container(
        width: width / 8,
        height: height,
        child: DragTarget<Map>(
          onAccept: (data) {
            if (data['move_from_deck'] == true) {
              providerData.setActiveColumnIndex(widget.columnIndex);
              providerData.pushMoveFromDeckEvent(widget.columnIndex);
            } else if (data['move_from_foundation'] == true) {
              print(data['suit']);
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
            children: widget.cards
                .asMap()
                .entries
                .map(
                  (card) => PlayingCard(
                      isLandscape: widget.isLandscape,
                      gameInitial: gameInitial,
                      top: widget.dragging
                          ? PositionCalculations.columnTopPosition(
                                  totalHeight: height,
                                  totalWidth: width,
                                  cardIndex: card.key,
                                  isLandscape: widget.isLandscape) -
                              PositionCalculations.verticalOffset(width)
                          : PositionCalculations.columnTopPosition(
                              totalHeight: height,
                              totalWidth: width,
                              cardIndex: card.key,
                              isLandscape: widget.isLandscape),
                      card: card.value,
                      cardColumn: widget.cards,
                      columnIndex: widget.columnIndex,
                      cardIndex: card.key),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
