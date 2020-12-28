import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ApiColumnItem extends Equatable {
  const ApiColumnItem({
    @required this.rank,
    @required this.suit,
    @required this.unplayedCount,
    @required this.moveableCount,
  });

  ApiColumnItem.fromApi(
      {@required List cardData, @required int moveable, @required int unplayed})
      : suit = cardData[0],
        rank = cardData[1],
        unplayedCount = unplayed,
        moveableCount = moveable;

  final dynamic rank;
  final String suit;
  final int moveableCount;
  final int unplayedCount;

  @override
  List<Object> get props => [suit, rank, unplayedCount, moveableCount];

  @override
  String toString() {
    return 'rank: $rank -- suit: $suit -- unplayed: $unplayedCount -- moveable: $moveableCount \n';
  }
}
