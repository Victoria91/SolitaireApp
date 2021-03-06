import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solitaire_app/domain/models/card_model.dart';
import 'package:solitaire_app/domain/state/providers/game.dart';
import 'package:solitaire_app/services/position_calculation.dart';

import 'package:solitaire_app/ui/widgets/card/card_widget.dart';
import 'package:solitaire_app/ui/widgets/card_column.dart';

class PlayingCard extends StatefulWidget {
  const PlayingCard({
    @required this.top,
    @required this.gameInitial,
    @required this.card,
    this.width,
    this.dragging = false,
    this.last,
    this.newCardSet,
    this.columnCount,
    @required this.cardColumn,
    @required this.cardIndex,
    @required this.columnIndex,
  });

  final double top;
  final double width;
  final bool last;
  final bool dragging;
  final CardModel card;
  final List<CardModel> cardColumn;
  final int cardIndex;
  final int columnIndex;
  final int columnCount;
  final bool gameInitial;
  final bool newCardSet;

  @override
  _PlayingCardState createState() => _PlayingCardState(
      updatedTop: top,
      gameInitial: gameInitial,
      columnIndex: columnIndex,
      width: width,
      dragging: dragging,
      played: card.played,
      newCardSet: newCardSet,
      columnCount: columnCount,
      last: last);
}

class _PlayingCardState extends State<PlayingCard>
    with TickerProviderStateMixin {
  _PlayingCardState(
      {this.dragging,
      this.updatedTop,
      this.gameInitial,
      this.last,
      this.width,
      this.columnCount,
      this.newCardSet,
      this.played,
      this.columnIndex}) {
    if (gameInitial) {
      _timer = Timer(const Duration(microseconds: 500), () {
        setState(() {
          top = widget.top;
        });
      });
    } else if (last && newCardSet) {
      left = -PositionCalculations.columnLeftPosition(
        width,
        columnCount,
        columnIndex,
      );
      _timer = Timer(const Duration(microseconds: 500), () {
        setState(() {
          top = widget.top;

          left = 0;
          Provider.of<Game>(context, listen: false).unsetNewCardSet();
        });
      });
    } else {
      top = updatedTop;
    }
  }

  Timer _timer;
  var top = 0.0;
  var left = 0.0;
  final bool dragging;
  final bool last;
  final double updatedTop;
  final bool gameInitial;
  final bool played;
  final bool newCardSet;
  final int columnIndex;
  final int columnCount;
  final double width;

  AnimationController _animationController;
  Animation _animation;
  bool animationFinished = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 180));
    _animation = Tween(begin: pi / 2, end: 0.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        setState(() {
          if (status == AnimationStatus.completed) {
            animationFinished = true;
          }
        });
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;

    final cardwiget = CardWidget(
      card: widget.card,
      needShadow: played,
    );

    final gameData = Provider.of<Game>(context, listen: false);

    if (widget.card.isNew) {
      _animationController.forward();
      gameData.unsetColumnNewCard(widget.columnIndex);
    }

    final draggableCard = Draggable<Map>(
      child: cardwiget,
      childWhenDragging: cardwiget,
      onDraggableCanceled: (_velocity, _offset) =>
          gameData.setColumns(widget.columnIndex, widget.cardColumn),
      onDragStarted: () => gameData.setColumns(
          widget.columnIndex, widget.cardColumn.sublist(0, widget.cardIndex)),
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: width,
          height: mediaQuery.size.height,
          child: Stack(children: [
            CardColumn(
                columnCount: gameData.columns.length,
                gameType: gameData.type,
                width: width,
                gameInitial: gameData.initial,
                dragging: true,
                cards: widget.cardColumn.sublist(widget.cardIndex),
                columnIndex: widget.columnIndex),
          ]),
        ),
      ),
      data: {'columnIndex': widget.columnIndex, 'cardIndex': widget.cardIndex},
    );
    return AnimatedPositioned(
      duration: Duration(milliseconds: 1800 - widget.columnIndex * 200),
      curve: Curves.ease,
      left: left,
      top: top,
      child: widget.card.played
          ? (widget.card.isNew
              ? Transform(
                  alignment: FractionalOffset.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(_animation.value),
                  child: animationFinished
                      ? draggableCard
                      : const CardWidget(
                          card: CardModel(played: false),
                        ),
                )
              : widget.card.moveable
                  ? draggableCard
                  : cardwiget)
          : cardwiget,
    );
  }
}
