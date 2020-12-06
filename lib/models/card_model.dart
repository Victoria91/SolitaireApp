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
  final bool moveable;
  bool newCard;

  CardModel(
      {@required this.played,
      this.rank,
      this.moveable,
      this.suit,
      this.newCard});

  CardModel.initFormServer(String suitString, String rankString, int index,
      int unplayed, int length, int moveableCount,
      [newCard = false])
      : rank = rankString,
        suit = fetchSuit(suitString),
        newCard = newCard,
        moveable = (length - index + 1) <= moveableCount,
        played = index > unplayed;

  CardModel.initFromDeck(String suitString, String rankString)
      : rank = rankString,
        suit = fetchSuit(suitString),
        newCard = false,
        moveable = true,
        played = true;

  List<String> toServer() {
    return [this.fetcSuitString(), rank];
  }

  @override
  String toString() {
    return '$rank -- $suit -- $newCard -- moveable: $moveable \n';
  }

  @override
  bool operator ==(other) {
    return this.rank == other.rank &&
        this.suit == other.suit &&
        this.played == other.played &&
        this.moveable == other.moveable;
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

  String fetcSuitString() {
    return {
      CardSuit.spade: 'spade',
      CardSuit.club: 'club',
      CardSuit.diamond: 'diamond',
      CardSuit.heart: 'heart'
    }[suit];
  }
}
