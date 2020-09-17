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

  CardModel.initFormServer(String suitString, String rankString)
      : rank = rankString,
        suit = fetchSuit(suitString);
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
