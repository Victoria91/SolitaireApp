import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

import 'dart:math';

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
          radius: Radius.circular(
            max(width / (isLandscape ? 8 : 9) / 7, 8),
          ),
        ));
  }
}
