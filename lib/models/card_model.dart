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

  CardModel({this.played, this.rank, this.suit});

  CardModel.initFormServer(
      String suitString, String rankString, int index, int unplayed)
      : rank = rankString,
        suit = fetchSuit(suitString),
        played = index > unplayed;

  CardModel.initFromDeck(String suitString, String rankString)
      : rank = rankString,
        suit = fetchSuit(suitString),
        played = true;

  @override
  String toString() {
    return '$rank -- $suit';
  }

  @override
  bool operator ==(other) {
    return this.rank == other.rank && this.suit == other.suit;
  }

  @override
  int get hashCode => this.hashCode;
}

CardSuit fetchSuit(String suitString) {
  return {
    'spade': CardSuit.spade,
    'diamond': CardSuit.diamond,
    'club': CardSuit.club,
    'heart': CardSuit.heart
  }[suitString];
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
