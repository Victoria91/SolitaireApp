import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:async';
import 'dart:math';

import '../models/card_model.dart';
import 'card_column.dart';
import '../widgets/card_widget.dart';
import '../providers/game.dart';

class PlayingCard extends StatefulWidget {
  final double top;
  final CardModel card;
  final List<CardModel> cardColumn;
  final int cardIndex;
  final int columnIndex;
  final bool gameInitial;

  PlayingCard({
    @required this.top,
    @required this.gameInitial,
    @required this.card,
    @required this.cardColumn,
    @required this.cardIndex,
    @required this.columnIndex,
  });

  @override
  _PlayingCardState createState() =>
      _PlayingCardState(updatedTop: top, gameInitial: gameInitial);
}

class _PlayingCardState extends State<PlayingCard>
    with TickerProviderStateMixin {
  Timer _timer;
  var top = 0.0;
  final bool dragging;
  final double updatedTop;
  final bool gameInitial;

  AnimationController _animationController;
  Animation _animation;
  bool animationFinished = false;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    _animation = Tween(begin: pi, end: 0.0).animate(_animationController)
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

  _PlayingCardState({this.dragging, this.updatedTop, this.gameInitial}) {
    if (gameInitial) {
      _timer = Timer(Duration(microseconds: 500), () {
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

    final cardwiget = CardWidget(card: widget.card);

    final gameData = Provider.of<Game>(context, listen: false);

    if (widget.card.newCard) {
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
      duration: Duration(milliseconds: 1200 - widget.columnIndex * 200),
      curve: Curves.ease,
      top: top,
      child: widget.card.played
          ? (widget.card.newCard
              ? Transform(
                  alignment: FractionalOffset.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(_animation.value),
                  child: animationFinished
                      ? draggableCard
                      : CardWidget(
                          card: CardModel(played: false),
                        ),
                )
              : draggableCard)
          : cardwiget,
    );
  }
}
