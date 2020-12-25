// {club: {from: null, prev: null, rank: null},
// diamond: {from: [column, 3], prev: A, rank: 2},
// heart: {from: null, prev: null, rank: null},
// sorted: [],
// spade: {from: [column, 3], prev: null, rank: A}}

// {club: {from: null, prev: null, rank: null},
// diamond: {from: null, prev: null, rank: null},
// heart: {from: null, prev: null, rank: null},
// sorted: [spade],
// spade: {count: 1, from: [column, 0], prev: null, rank: A}}

// {
//               'count': responseBySuit['count'],
//               'prev': responseBySuit['prev'] == null
//                   ? null
//                   : CardModel.initFromDeck(suit, responseBySuit['prev']),
//               'from': fromResponseBySuit,
//               'cardIndex': fromCardIndex,
//               'deckLength': response['deck'].length,
//               'manual': manual,
//               'changed':
//                   foundation[suit].isNotEmpty && responseBySuit['rank'] != null,
//               'rank': CardModel.initFromDeck(suit, responseBySuit['rank'])
//             };

import 'package:solitaire_app/data/api/models/api_suit_foundation.dart';

class ApiFoundation {
  final List<String> sorted;
  final ApiSuitFoundation club;
  final ApiSuitFoundation spade;
  final ApiSuitFoundation diamond;
  final ApiSuitFoundation heart;
  final int deckLength;

  ApiFoundation({
    this.sorted,
    this.club,
    this.spade,
    this.diamond,
    this.heart,
    this.deckLength,
  });

  @override
  String toString() {
    return 'sorted: $sorted -*- heart: $heart -*- deckLength: $deckLength \n';
  }

  ApiFoundation.fromApi(Map response)
      : sorted = response['foundation']['sorted'].cast<String>(),
        club = fetchApiSuitFoundation('club', response),
        diamond = fetchApiSuitFoundation('diamond', response),
        heart = fetchApiSuitFoundation('heart', response),
        spade = fetchApiSuitFoundation('spade', response),
        deckLength = response['deck'].length;
}

ApiSuitFoundation fetchApiSuitFoundation(String suit, Map response) {
  return response['foundation'][suit]['rank'] != null
      ? ApiSuitFoundation.fromApi(response['foundation'][suit])
      : null;
}
