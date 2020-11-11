import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  CardColumn(
      {@required this.cards,
      @required this.columnIndex,
      @required this.isLandscape,
      this.width,
      this.dragging = false});

  @override
  _CardColumnState createState() =>
      _CardColumnState(dragging: dragging, width: width);
}

class _CardColumnState extends State<CardColumn> {
  Timer _timer;
  var left = 0.0;
  final bool dragging;
  final double width;

  _CardColumnState({this.dragging, this.width}) {
    if (!dragging) {
      _timer = Timer(Duration(microseconds: 1000), () {
        setState(() {
          left = widget.columnIndex * width / 7;
        });
      });
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
    final verticalOffset = widget.isLandscape ? 120 : 90;

    return AnimatedPositioned(
      duration: Duration(milliseconds: 1400 - widget.columnIndex * 200),
      left: left,
      child: Container(
        width: width / 8,
        height: height,
        child: DragTarget<Map>(
          onAccept: (data) {
            if (data['move_from_deck'] != null) {
              providerData.setActiveColumnIndex(widget.columnIndex);
              providerData.pushMoveFromDeckEvent(widget.columnIndex);
            } else {
              print('pushMoveFromColumnEvent+++');
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
                      providerData: providerData,
                      dragging: widget.dragging,
                      top: widget.dragging
                          ? (card.key * 18).toDouble()
                          : (verticalOffset + card.key * 18).toDouble(),
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
