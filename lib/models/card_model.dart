import 'package:solitaire_app/custom_icons/club_icons.dart';
import 'package:solitaire_app/custom_icons/diamond_icons.dart';
import 'package:solitaire_app/custom_icons/heart_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:solitaire_app/custom_icons/spade_icons.dart';

enum CardSuit {
  spade,
  heart,
  diamond,
  club,
}

enum CardRank {
  ace,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  jack,
  queen,
  king
}

class CardModel {
  final CardSuit suit;
  final String rank;
  final bool played;
  bool newCard;

  CardModel({@required this.played, this.rank, this.suit, this.newCard});

  CardModel.initFormServer(
      String suitString, String rankString, int index, int unplayed,
      [newCard = false])
      : rank = rankString,
        suit = fetchSuit(suitString),
        newCard = newCard,
        played = index > unplayed;

  CardModel.initFromDeck(String suitString, String rankString)
      : rank = rankString,
        suit = fetchSuit(suitString),
        newCard = false,
        played = true;

  List<String> toServer() {
    return [fetchString(suit), rank];
  }

  @override
  String toString() {
    return '$rank -- $suit -- $newCard';
  }

  @override
  bool operator ==(other) {
    return this.rank == other.rank &&
        this.suit == other.suit &&
        this.played == other.played;
  }

  @override
  int get hashCode => this.hashCode;

  static CardSuit fetchSuit(String suitString) {
    return {
      'spade': CardSuit.spade,
      'diamond': CardSuit.diamond,
      'club': CardSuit.club,
      'heart': CardSuit.heart
    }[suitString];
  }

  bool isRed() {
    return (suit == CardSuit.heart || suit == CardSuit.diamond);
  }

  IconData icon() {
    return {
      CardSuit.heart: Heart.heart,
      CardSuit.diamond: Diamond.diamonds,
      CardSuit.club: Club.clubs,
      CardSuit.spade: Spade.spades
    }[suit];
  }
}

String fetchString(CardSuit suit) {
  return {
    CardSuit.spade: 'spade',
    CardSuit.club: 'club',
    CardSuit.diamond: 'diamond',
    CardSuit.heart: 'heart'
  }[suit];
}

CardRank fetchRank(String rankString) {
  return {
    'A': CardRank.ace,
    '2': CardRank.two,
    '3': CardRank.three,
    '4': CardRank.four,
    '5': CardRank.five,
    '6': CardRank.six,
    '7': CardRank.seven,
    '8': CardRank.eight,
    '9': CardRank.nine,
    '10': CardRank.ten,
    'J': CardRank.jack,
    'Q': CardRank.queen,
    'K': CardRank.king
  }[rankString];
}
