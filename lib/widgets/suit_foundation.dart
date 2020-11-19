import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:solitaire_app/models/card_model.dart';
import 'package:solitaire_app/providers/game.dart';
import 'package:solitaire_app/services/position_calculation.dart';
import 'package:solitaire_app/widgets/playing_card.dart';
import './empty_foundation.dart';

import 'dart:async';

class SuitFoundation extends StatefulWidget {
  final double width;
  final double height;
  final CardSuit suit;
  final int position;
  final Map foundation;
  final bool isLandscape;
  final bool gameInitial;

  SuitFoundation(
      {Key key,
      @required this.width,
      @required this.foundation,
      @required this.suit,
      @required this.height,
      @required this.position,
      @required this.gameInitial,
      @required this.isLandscape})
      : super(key: key ?? ValueKey([foundation]));

  @override
  _SuitFoundationState createState() => _SuitFoundationState(
      isLandscape: isLandscape,
      currentCard: foundation['rank'],
      width: width,
      position: position,
      height: height,
      cardIndex: foundation['cardIndex'],
      from: foundation['from'],
      deckLength: foundation['deckLength'],
      changed: foundation['changed'],
      manual: foundation['manual'],
      gameInitial: gameInitial,
      prevCard: foundation['prev']);
}

class _SuitFoundationState extends State<SuitFoundation>
    with TickerProviderStateMixin {
  Timer _timer;
  var left;
  var top = 0.0;
  final CardModel currentCard;
  final CardModel prevCard;
  final double width;
  final double height;
  final int position;
  final List from;
  final int deckLength;
  final int cardIndex;
  final bool isLandscape;
  final bool manual;
  final bool gameInitial;
  double newLeftValue;
  final bool changed;

  AnimationController rotationController;

  @override
  void initState() {
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
  }

  _SuitFoundationState(
      {@required this.currentCard,
      @required this.changed,
      @required this.width,
      @required this.position,
      @required this.from,
      @required this.manual,
      @required this.deckLength,
      @required this.prevCard,
      @required this.height,
      @required this.isLandscape,
      @required this.gameInitial,
      @required this.cardIndex}) {
    newLeftValue = PositionCalculations.columnLeftPosition(width, position);

    if (!_needRotate() || from == null) {
      left = newLeftValue;
    } else {
      if (from[0] == 'deck') {
        // card was moved from deck, animate only left property

        left = PositionCalculations.deckCardPostion(width, deckLength);
      } else {
        // card was moved from column, animate both left and top
        left = PositionCalculations.columnLeftPosition(width, from[1]);
        top = PositionCalculations.columnTopPosition(
            totalHeight: height,
            totalWidth: width,
            isLandscape: isLandscape,
            cardIndex: cardIndex);
      }

      _timer = Timer(Duration(microseconds: 500), () {
        setState(() {
          left = newLeftValue;
          top = 0;
          Provider.of<Game>(context, listen: false).unsetChanged();
        });
      });
    }
  }

  @override
  void dispose() {
    rotationController.dispose();
    super.dispose();

    if (_timer != null) {
      print('disposing...');
      _timer.cancel();
    }
  }

  // whether rotate animation is needed. Rotation
  // is used when card was auto-moved, when suit foundatiom
  // changed and current card is non null
  bool _needRotate() {
    return !(currentCard == null || manual || !changed);
  }

  @override
  Widget build(BuildContext context) {
    if (_needRotate()) {
      rotationController.forward();
    }

    final providerData = Provider.of<Game>(context, listen: false);
    final currentCardWidget = CardWidget(
      width: widget.width,
      isLandscape: isLandscape,
      card: currentCard,
    );

    final dragTarget = DragTarget<Map>(
      onAccept: (data) {
        if (data['move_from_deck'] == true) {
          providerData.pushMoveToFoundationFromDeckEvent();
        } else {
          providerData.pushMoveToFoundationFromColumnEvent(data['columnIndex']);
        }
      },
      builder: (context, candidateData, rejectedData) {
        return (currentCard == null)
            ? EmptyFoundation(
                width: widget.width,
                isLandscape: isLandscape,
                cardFraction: isLandscape ? 8 : 9,
              )
            : Draggable<Map>(
                childWhenDragging: Container(),
                data: {
                  'move_from_foundation': true,
                  'suit': currentCard.fetcSuitString()
                },
                feedback: currentCardWidget,
                child: currentCardWidget,
              );
      },
    );
    return Stack(
      children: [
        Positioned(
          left: newLeftValue,
          child: prevCard != null
              ? CardWidget(
                  width: width,
                  card: prevCard,
                  isLandscape: isLandscape,
                )
              : EmptyFoundation(
                  isLandscape: isLandscape,
                  width: widget.width,
                  cardFraction: isLandscape ? 8 : 9,
                ),
        ),
        AnimatedPositioned(
            curve: Curves.fastOutSlowIn,
            top: top,
            left: left,
            duration: const Duration(milliseconds: 500),
            child: !_needRotate()
                ? dragTarget
                : RotationTransition(
                    turns:
                        Tween(begin: 0.0, end: 1.0).animate(rotationController),
                    child: Selector<Game, bool>(
                        selector: (_ctx, game) => game.win,
                        builder: (ctx, winState, child) =>
                            winState ? currentCardWidget : dragTarget))),
      ],
    );
  }
}
