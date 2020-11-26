import 'dart:math';

import '../constants.dart';

class PositionCalculations {
  static double columnLeftPosition(double totalWidth, int columnIndex) {
    return columnIndex * _cardWidth(totalWidth) +
        offsetBetweenColumns * columnIndex;
  }

  static double columnTopPosition(
      {bool isLandscape,
      int cardIndex,
      double totalHeight,
      double totalWidth}) {
    return verticalOffset(totalWidth) +
        cardIndex * totalHeight / verticalOffsetBetweenCards(isLandscape);
  }

  static double cardBorderRadius(bool isLandscape, double width) {
    return max(width / (isLandscape ? 8 : 9) / 7, 8);
  }

  static double deckCardPostion(double totalWidth, int deckCardIndex) {
    final cardWidth = _cardWidth(totalWidth);
    return cardWidth +
        cardWidth / 3 +
        deckCardIndex * _offsetBetweenWidgetCards(totalWidth);
  }

  static _cardWidth(double totalWidth) {
    return (totalWidth -
            horizontalTotalPadding * 2 -
            offsetBetweenColumns * 6) /
        7;
  }

  static verticalOffsetBetweenCards(bool isLandscape) {
    return isLandscape ? 20 : 40;
  }

  static verticalOffset(double totalWidth) {
    return totalWidth / 7 * 1.2 + 10;
  }

  static _offsetBetweenWidgetCards(double totalWidth) {
    return totalWidth / 32;
  }
}
