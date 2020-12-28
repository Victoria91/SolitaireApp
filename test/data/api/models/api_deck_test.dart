import 'package:solitaire_app/data/api/models/api_deck.dart';
import 'package:solitaire_app/data/api/models/api_deck_item.dart';
import 'package:test/test.dart';

void main() {
  test('fromApi constructor', () {
    final res = ApiDeck.fromApi({
      'deck': [
        ['spade', 5],
        ['heart', 8],
        ['club', 'A']
      ]
    });

    expect(res.cards, const [
      ApiDeckItem(rank: 'A', suit: 'club'),
      ApiDeckItem(rank: 8, suit: 'heart'),
      ApiDeckItem(rank: 5, suit: 'spade'),
    ]);
  });
}
