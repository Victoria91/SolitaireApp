import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ApiDeckItem extends Equatable {
  const ApiDeckItem({@required this.rank, @required this.suit});

  ApiDeckItem.fromApi(List cardData)
      : suit = cardData[0],
        rank = cardData[1];

  final dynamic rank;
  final String suit;

  @override
  List<Object> get props => [suit, rank];

  @override
  String toString() {
    return 'rank: $rank -- suit: $suit \n';
  }
}
