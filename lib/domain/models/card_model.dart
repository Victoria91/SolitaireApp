import 'package:equatable/equatable.dart';
import 'package:solitaire_app/ui/custom_icons/club_icons.dart';
import 'package:solitaire_app/ui/custom_icons/diamond_icons.dart';
import 'package:solitaire_app/ui/custom_icons/heart_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:solitaire_app/ui/custom_icons/spade_icons.dart';

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

class CardModel extends Equatable {
  const CardModel(
      {@required this.played, this.moveable, this.rank, this.suit, this.isNew});

  final CardSuit suit;
  final CardRank rank;
  final bool played;
  final bool moveable;
  final bool isNew;

  @override
  List<Object> get props => [suit, rank, played, moveable, isNew];

  List<String> toServer() {
    return [fetchSuitString(), rankString()];
  }

  @override
  String toString() {
    return '$rank -- $suit -- $played -- moveable: $moveable --- isNew: $isNew \n';
  }

  static CardSuit fetchSuit(String suitString) {
    return {
      'spade': CardSuit.spade,
      'diamond': CardSuit.diamond,
      'club': CardSuit.club,
      'heart': CardSuit.heart
    }[suitString];
  }

  bool isRed() {
    return suit == CardSuit.heart || suit == CardSuit.diamond;
  }

  IconData icon() {
    return {
      CardSuit.heart: Heart.heart,
      CardSuit.diamond: Diamond.diamonds,
      CardSuit.club: Club.clubs,
      CardSuit.spade: Spade.spades
    }[suit];
  }

  String fetchSuitString() {
    return {
      CardSuit.spade: 'spade',
      CardSuit.club: 'club',
      CardSuit.diamond: 'diamond',
      CardSuit.heart: 'heart'
    }[suit];
  }

  String rankString() {
    return {
      CardRank.two: '2',
      CardRank.three: '3',
      CardRank.four: '4',
      CardRank.five: '5',
      CardRank.six: '6',
      CardRank.seven: '7',
      CardRank.eight: '8',
      CardRank.nine: '9',
      CardRank.ten: '10',
      CardRank.jack: 'J',
      CardRank.queen: 'Q',
      CardRank.king: 'K',
      CardRank.ace: 'A',
    }[rank];
  }
}
