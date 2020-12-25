import 'package:solitaire_app/data/api/models/api_deck_item.dart';

class ApiDeck {
  final List<ApiDeckItem> cards;

  ApiDeck(this.cards);

  ApiDeck.fromApi(Map map)
      : cards = map['deck']
            .map((deckCard) => ApiDeckItem.fromApi(deckCard))
            .toList()
            .reversed
            .toList()
            .cast<ApiDeckItem>();
}
