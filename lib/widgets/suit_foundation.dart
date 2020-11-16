import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:solitaire_app/models/card_model.dart';
import 'package:solitaire_app/providers/game.dart';
import 'package:solitaire_app/widgets/playing_card.dart';

import 'dart:async';

class SuitFoundation extends StatefulWidget {
  final double width;
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
      @required this.isLandscape,
      @required this.gameInitial,
      @required this.cardIndex}) {
    final cardFraction = isLandscape ? 8 : 9;
    final ratio = isLandscape ? 3.40 : 3.7;
    newLeftValue = width / cardFraction * ratio +
        width / cardFraction * position +
        10 * position;

    if (currentCard == null || manual || !changed) {
      left = newLeftValue;
    } else {
      if (from[0] == "deck") {
        // card was moved from deck, animate only left property

        final cardOffset = isLandscape ? 20 : 15;
        left = (width / cardFraction + deckLength * cardOffset).toDouble();
      } else {
        // card was moved from column, animate both left and top
        left = from[1] * width / 7;
        top = (120 + cardIndex * 20).toDouble();
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

  @override
  Widget build(BuildContext context) {
    if (currentCard == null || manual || !changed) {
      rotationController.forward(from: 0.0);
    }

    final providerData = Provider.of<Game>(context, listen: false);

    final dragTarget = DragTarget<Map>(
      onAccept: (data) {
        if (data['move_from_deck'] != null) {
          providerData.pushMoveToFoundationFromDeckEvent();
        } else {
          providerData.pushMoveToFoundationFromColumnEvent(data['columnIndex']);
        }
      },
      builder: (context, candidateData, rejectedData) => (currentCard == null)
          ? EmptyFoundation(
              width: widget.width,
              isLandscape: isLandscape,
              cardFraction: isLandscape ? 8 : 9,
            )
          : CardWidget(
              width: widget.width, isLandscape: isLandscape, card: currentCard),
    );
    return Stack(
      overflow: Overflow.clip,
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
            duration: Duration(milliseconds: 500),
            child: (currentCard == null || manual || !changed)
                ? dragTarget
                : RotationTransition(
                    turns:
                        Tween(begin: 0.0, end: 1.0).animate(rotationController),
                    child: dragTarget,
                  )),
      ],
    );
  }
}

class EmptyFoundation extends StatelessWidget {
  const EmptyFoundation(
      {Key key,
      @required this.width,
      @required this.cardFraction,
      @required this.isLandscape})
      : super(key: key);

  final double width;
  final double cardFraction;
  final bool isLandscape;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width / cardFraction,
        height: width / 7 * 1.15,
        child: DottedBorder(
          child: Container(),
          borderType: BorderType.RRect,
          radius: Radius.circular(isLandscape ? 10 : 8),
        ));
  }
}
