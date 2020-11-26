import 'package:flutter/material.dart';

import 'package:solitaire_app/services/position_calculation.dart';

class CardContainer extends StatelessWidget {
  const CardContainer(
      {Key key,
      @required this.child,
      this.played = false,
      this.needBorder = true,
      this.transparent = false,
      this.needShadow = true})
      : super(key: key);
  final Widget child;
  final bool played;
  final bool needShadow;
  final bool needBorder;
  final bool transparent;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
        width: width / (isLandscape ? 8 : 9),
        height: width / 7 * (isLandscape ? 1.2 : 1.15),
        child: child,
        decoration: BoxDecoration(
          border: needBorder ? Border.all() : null,
          boxShadow: needShadow
              ? <BoxShadow>[
                  const BoxShadow(
                    color: Colors.black54,
                    blurRadius: 15.0,
                    offset: Offset(0.0, 8),
                  )
                ]
              : null,
          color: played
              ? Colors.white
              : transparent
                  ? Colors.transparent
                  : Colors.blue,
          borderRadius: BorderRadius.circular(
              PositionCalculations.cardBorderRadius(isLandscape, width)),
        ));
  }
}
