import 'package:solitaire_app/data/api/models/api_column_item.dart';
import 'package:solitaire_app/data/api/models/api_deck_item.dart';
import 'package:solitaire_app/domain/models/card_model.dart';

class CardMapper {
  static CardModel fromApiColumnItem(ApiColumnItem apiColumnItem,
      int columnItemIndex, int columnLength, List<CardModel> oldColumns) {
    return CardModel(
      isNew: _cardHadTurnedOver(columnItemIndex, columnLength, oldColumns),
      suit: fetchSuit(apiColumnItem.suit),
      rank: fetchRank(apiColumnItem.rank),
      moveable: columnLength - columnItemIndex <= apiColumnItem.moveableCount,
      played: columnItemIndex + 1 > apiColumnItem.unplayedCount,
    );
  }

  static CardModel fromApiDeckItem(ApiDeckItem apiDeckItem,
      [bool moveable = true]) {
    return CardModel(
        suit: fetchSuit(apiDeckItem.suit),
        rank: fetchRank(apiDeckItem.rank),
        moveable: moveable,
        played: true);
  }

  static CardModel fromApiFoundation(dynamic rankString, String suitString) {
    return rankString != null
        ? CardModel(
            suit: fetchSuit(suitString),
            rank: fetchRank(rankString),
            moveable: true,
            played: true)
        : null;
  }
}

bool _cardHadTurnedOver(
    int columnItemIndex, int columnLength, List<CardModel> oldColumns) {
  return columnItemIndex == columnLength - 1 &&
      columnLength == oldColumns.length &&
      oldColumns.last.played == false;
}

CardSuit fetchSuit(String suitString) {
  return {
    'spade': CardSuit.spade,
    'diamond': CardSuit.diamond,
    'club': CardSuit.club,
    'heart': CardSuit.heart
  }[suitString];
}

CardRank fetchRank(dynamic rankString) {
  return {
    2: CardRank.two,
    3: CardRank.three,
    4: CardRank.four,
    5: CardRank.five,
    6: CardRank.six,
    7: CardRank.seven,
    8: CardRank.eight,
    9: CardRank.nine,
    10: CardRank.ten,
    'J': CardRank.jack,
    'Q': CardRank.queen,
    'K': CardRank.king,
    'A': CardRank.ace,
  }[rankString];
}
