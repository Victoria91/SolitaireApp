import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:solitaire_app/domain/models/card_model.dart';
import 'package:solitaire_app/domain/models/suit_foundation_model.dart';
import 'package:solitaire_app/domain/state/providers/game.dart';
import 'package:solitaire_app/services/position_calculation.dart';

import '../card/card_widget.dart';
import 'empty_foundation.dart';

class SuitFoundation extends StatefulWidget {
  SuitFoundation({
    Key key,
    @required this.width,
    @required this.foundation,
    @required this.columnsCount,
    @required this.height,
    @required this.position,
    @required this.gameInitial,
    @required this.isLandscape,
    this.suit,
    this.changed,
  }) : super(key: key ?? ObjectKey([foundation, position]));

  final double width;
  final double height;
  final CardSuit suit;
  final int position;
  final SuitFoundationModel foundation;
  final bool isLandscape;
  final bool changed;
  final bool gameInitial;
  final int columnsCount;

  @override
  _NewSuitFoundationState createState() => _NewSuitFoundationState(
      isLandscape: isLandscape,
      columnsCount: columnsCount,
      currentCard: foundation.current,
      width: width,
      position: position,
      height: height,
      cardIndex: foundation.fromCardIndex,
      from: foundation.from,
      suit: suit,
      deckLength: foundation.deckLength,
      changed: changed ?? foundation.changed,
      manual: foundation.manual,
      gameInitial: gameInitial,
      prevCard: foundation.prev);
}

class _NewSuitFoundationState extends State<SuitFoundation>
    with TickerProviderStateMixin {
  _NewSuitFoundationState(
      {@required this.currentCard,
      @required this.changed,
      @required this.width,
      @required this.position,
      @required this.from,
      @required this.columnsCount,
      @required this.manual,
      @required this.suit,
      @required this.deckLength,
      @required this.prevCard,
      @required this.height,
      @required this.isLandscape,
      @required this.gameInitial,
      @required this.cardIndex}) {
    newLeftValue =
        PositionCalculations.columnLeftPosition(width, columnsCount, position);

    if (!_needRotate() || from == null) {
      left = newLeftValue;
    } else {
      print(currentCard.suit);
      print('deckLength????????????????$deckLength');
      if (from[0] == 'deck') {
        // card was moved from deck, animate only left property

        left = PositionCalculations.deckCardPostion(
            width, columnsCount, deckLength);
      } else {
        // card was moved from column, animate both left and top
        left = PositionCalculations.columnLeftPosition(
            width, columnsCount, from[1]);
        top = PositionCalculations.columnTopPosition(
            totalHeight: height,
            totalWidth: width,
            isLandscape: isLandscape,
            columnsCount: columnsCount,
            cardIndex: cardIndex);
      }
      if (changed) {
        _timer = Timer(const Duration(microseconds: 500), () {
          setState(() {
            left = newLeftValue;
            top = 0;
            Provider.of<Game>(context, listen: false)
                .unsetChanged(currentCard.fetchSuitString());
          });
        });
      } else {
        left = newLeftValue;
        top = 0;
      }
    }
  }
  Timer _timer;
  double left;
  var top = 0.0;
  final CardModel currentCard;
  final CardModel prevCard;
  final double width;
  final double height;
  final int position;
  final List from;
  final CardSuit suit;
  final int deckLength;
  final int cardIndex;
  final int columnsCount;
  final bool isLandscape;
  final bool manual;
  final bool gameInitial;
  final bool changed;
  double newLeftValue;

  AnimationController rotationController;

  @override
  void initState() {
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
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
      card: currentCard,
    );

    final emptyFoundationWidget = providerData.type == 'spider'
        ? const EmptyFoundation()
        : EmptyFoundation(card: CardModel(played: false, suit: widget.suit));

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
            ? emptyFoundationWidget
            : providerData.type == 'spider'
                ? currentCardWidget
                : Draggable<Map<String, dynamic>>(
                    childWhenDragging: Container(),
                    data: {
                      'move_from_foundation': true,
                      'suit': currentCard.fetchSuitString()
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
                    card: prevCard,
                    needShadow: false,
                  )
                : emptyFoundationWidget),
        AnimatedPositioned(
            curve: Curves.fastOutSlowIn,
            top: top,
            left: left,
            duration: const Duration(milliseconds: 700),
            child: !_needRotate()
                ? dragTarget
                : RotationTransition(
                    turns:
                        Tween(begin: 0.0, end: 1.0).animate(rotationController),
                    child: Selector<Game, bool>(
                        selector: (_ctx, game) => game.win,
                        builder: (ctx, winState, child) =>
                            winState || providerData.type == 'spider'
                                ? currentCardWidget
                                : dragTarget))),
      ],
    );
  }
}
