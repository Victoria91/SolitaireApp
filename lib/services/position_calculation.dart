import 'dart:math';

import 'package:solitaire_app/constants.dart';

class PositionCalculations {
  static double columnLeftPosition(
      double totalWidth, int columnsCount, int columnIndex) {
    return columnIndex * cardWidth(totalWidth, columnsCount) +
        offsetBetweenColumns * columnIndex;
  }

  static double columnTopPosition(
      {bool isLandscape,
      int cardIndex,
      double totalHeight,
      double totalWidth,
      int columnsCount}) {
    return cardHeight(totalWidth, columnsCount) +
        cardIndex * totalHeight / verticalOffsetBetweenCards(isLandscape);
  }

  static double cardBorderRadius(bool isLandscape, double width) {
    return max(width / (isLandscape ? 8 : 9) / 7, 8);
  }

  static double deckCardPostion(
      double totalWidth, int columnsCount, int deckCardIndex) {
    final calculatedCardWidth = cardWidth(totalWidth, columnsCount);
    return calculatedCardWidth +
        calculatedCardWidth / 3 +
        deckCardIndex * _offsetBetweenWidgetCards(totalWidth);
  }

  static double cardWidth(double totalWidth, int columnsCount) {
    return (totalWidth -
            horizontalTotalPadding * 2 -
            offsetBetweenColumns * (columnsCount - 1)) /
        columnsCount;
  }

  static int verticalOffsetBetweenCards(bool isLandscape) {
    return isLandscape ? 22 : 42;
  }

  static double cardHeight(double totalWidth, int columnsCount) {
    return totalWidth / 7 * (columnsCount > 7 ? 1 : 1.2);
  }

  static double _offsetBetweenWidgetCards(double totalWidth) {
    return totalWidth / 32;
  }
}
