import 'package:solitaire_app/data/api/models/api_suit_foundation.dart';

class ApiFoundation {
  const ApiFoundation({
    this.sorted,
    this.club,
    this.spade,
    this.diamond,
    this.heart,
    this.deckLength,
  });

  ApiFoundation.fromApi(Map response)
      : sorted = (response['foundation']['sorted']).cast<String>(),
        club = fetchApiSuitFoundation('club', response),
        diamond = fetchApiSuitFoundation('diamond', response),
        heart = fetchApiSuitFoundation('heart', response),
        spade = fetchApiSuitFoundation('spade', response),
        deckLength = (response['deck']).length;

  final List<String> sorted;
  final ApiSuitFoundation club;
  final ApiSuitFoundation spade;
  final ApiSuitFoundation diamond;
  final ApiSuitFoundation heart;
  final int deckLength;

  @override
  String toString() {
    return 'sorted: $sorted -*- heart: $heart -*- deckLength: $deckLength \n';
  }
}

ApiSuitFoundation fetchApiSuitFoundation(String suit, Map response) {
  return response['foundation'][suit]['rank'] != null
      ? ApiSuitFoundation.fromApi(response['foundation'][suit])
      : null;
}
