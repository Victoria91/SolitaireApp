import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import 'package:solitaire_app/models/card_model.dart';
import 'package:solitaire_app/widgets/playing_card.dart';

import 'dart:async';

class SuitFoundation extends StatefulWidget {
  final double width;
  final CardSuit suit;
  final int position;
  final Map foundation;

  SuitFoundation({
    Key key,
    @required this.width,
    @required this.foundation,
    @required this.suit,
    @required this.position,
  }) : super(key: key ?? ValueKey([foundation]));

  @override
  _SuitFoundationState createState() => _SuitFoundationState(
      currentCard: foundation['rank'],
      width: width,
      position: position,
      cardIndex: foundation['cardIndex'],
      from: foundation['from'],
      deckLength: foundation['deckLength'],
      prevCard: foundation['prev']);
}

class _SuitFoundationState extends State<SuitFoundation> {
  Timer _timer;
  var left;
  var top = 0.0;
  final CardModel currentCard;
  final CardModel prevCard;
  final double width;
  final int position;
  final List from;
  final int deckLength;
  double newLeftValue;
  final int cardIndex;

  _SuitFoundationState(
      {@required this.currentCard,
      @required this.width,
      @required this.position,
      @required this.from,
      @required this.deckLength,
      @required this.prevCard,
      @required this.cardIndex}) {
    newLeftValue = width / 8 * 3.4 + width / 8 * position + 10 * position;

    if (currentCard == null) {
      left = newLeftValue;
    } else {
      if (from[0] == "deck") {
        // card was moved from deck, animate only left property
        left = (width / 8 + deckLength * 20).toDouble();
      } else {
        // card was moved from column, animate both left and top
        left = from[1] * width / 7;
        top = (120 + cardIndex * 20).toDouble();
      }

      _timer = Timer(Duration(microseconds: 500), () {
        setState(() {
          left = newLeftValue;
          top = 0;
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
    return Stack(
      overflow: Overflow.clip,
      children: [
        Positioned(
          left: newLeftValue,
          child: prevCard != null
              ? CardWidget(width: width, card: prevCard)
              : EmptyFoundation(width: widget.width),
        ),
        AnimatedPositioned(
          curve: Curves.fastOutSlowIn,
          top: top,
          left: left,
          duration: Duration(milliseconds: 500),
          child: (currentCard == null)
              ? EmptyFoundation(width: widget.width)
              : CardWidget(width: widget.width, card: currentCard),
        ),
      ],
    );
  }
}

class EmptyFoundation extends StatelessWidget {
  const EmptyFoundation({
    Key key,
    @required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width / 8,
        height: width / 7 * 1.15,
        child: DottedBorder(
          child: Container(),
          borderType: BorderType.RRect,
          radius: Radius.circular(12),
        ));
  }
}