import 'package:solitaire_app/data/api/models/api_deck.dart';
import 'package:solitaire_app/data/mappers/card_mapper.dart';
import 'package:solitaire_app/domain/models/card_model.dart';

class DeckMapper {
  static List<CardModel> fromApi(ApiDeck deck) {
    return deck.cards
        .asMap()
        .entries
        .map((deckItem) => CardMapper.fromApiDeckItem(
            deckItem.value, deckItem.key == deck.cards.length - 1))
        .toList();
  }
}
