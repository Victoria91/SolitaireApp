import 'package:solitaire_app/data/api/models/api_deck.dart';
import 'package:solitaire_app/data/api/models/api_deck_item.dart';
import 'package:solitaire_app/data/mappers/deck_mapper.dart';
import 'package:solitaire_app/domain/models/card_model.dart';
import 'package:test/test.dart';

void main() {
  test('mapper test', () {
    const apiDeck = ApiDeck([
      ApiDeckItem(rank: 2, suit: 'spade'),
      ApiDeckItem(rank: 4, suit: 'diamond'),
      ApiDeckItem(rank: 'K', suit: 'club')
    ]);

    final res = DeckMapper.fromApi(apiDeck);

    expect(res, const [
      CardModel(
          played: true,
          rank: CardRank.two,
          suit: CardSuit.spade,
          moveable: false),
      CardModel(
          played: true,
          rank: CardRank.four,
          suit: CardSuit.diamond,
          moveable: false),
      CardModel(
          played: true,
          rank: CardRank.king,
          suit: CardSuit.club,
          moveable: true)
    ]);
  });
}
