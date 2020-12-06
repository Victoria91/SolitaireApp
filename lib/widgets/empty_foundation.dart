import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:solitaire_app/models/card_model.dart';
import 'package:solitaire_app/services/position_calculation.dart';

import 'package:solitaire_app/widgets/card/card_container.dart';

class EmptyFoundation extends StatelessWidget {
  final CardModel card;
  const EmptyFoundation({Key key, this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    final double width = mediaQuery.size.width;

    return CardContainer(
        needShadow: false,
        needBorder: false,
        transparent: true,
        child: DottedBorder(
          child: Container(
              child: Center(
            child: card != null
                ? Opacity(
                    opacity: 0.3,
                    child: Icon(
                      card.icon(),
                      size: mediaQuery.size.width / 10,
                    ))
                : Container(),
          )),
          borderType: BorderType.RRect,
          radius: Radius.circular(
              PositionCalculations.cardBorderRadius(isLandscape, width)),
        ));
  }
}
