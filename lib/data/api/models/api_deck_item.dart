import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ApiDeckItem extends Equatable {
  final dynamic rank;
  final String suit;

  List<Object> get props => [suit, rank];

  ApiDeckItem({@required this.rank, @required this.suit});

  ApiDeckItem.fromApi(List cardData)
      : this.suit = cardData[0],
        this.rank = cardData[1];

  @override
  String toString() {
    return 'rank: $rank -- suit: $suit \n';
  }
}
