import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ApiColumnItem extends Equatable {
  final dynamic rank;
  final String suit;
  final int moveableCount;
  final int unplayedCount;

  List<Object> get props => [suit, rank, unplayedCount, moveableCount];

  @override
  String toString() {
    return 'rank: $rank -- suit: $suit -- unplayed: $unplayedCount -- moveable: $moveableCount \n';
  }

  ApiColumnItem({
    @required this.rank,
    @required this.suit,
    @required this.unplayedCount,
    @required this.moveableCount,
  });

  ApiColumnItem.fromApi(
      {@required List<Object> cardData,
      @required int moveable,
      @required int unplayed})
      : this.suit = cardData[0],
        this.rank = cardData[1],
        this.unplayedCount = unplayed,
        this.moveableCount = moveable;
}
