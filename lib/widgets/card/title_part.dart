import 'package:flutter/material.dart';

import '../../models/card_model.dart';

class TitlePart extends StatelessWidget {
  final position;
  final rank;
  final suit;

  TitlePart(this.rank, this.suit, this.position);

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
      margin: position == 'top'
          ? EdgeInsets.only(top: 3, left: 3, right: 3)
          : EdgeInsets.only(left: 3, right: 3),
      child: Align(
        alignment: position == 'top' ? Alignment.topLeft : Alignment.topRight,
        child: Text(
          rank,
          style: TextStyle(
            fontSize: isLandscape ? 14 : 10,
            fontWeight: FontWeight.bold,
            color: (suit == CardSuit.spade || suit == CardSuit.club)
                ? Colors.red
                : Colors.black,
          ),
        ),
      ),
    );
  }
}
