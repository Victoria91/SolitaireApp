import 'package:solitaire_app/data/api/models/api_foundation.dart';
import 'package:solitaire_app/data/api/models/api_suit_foundation.dart';
import 'package:test/test.dart';

void main() {
  test('from API constructor', () {
    final response = {
      'deck': [
        ['spade', 2],
        ['heart', 3]
      ],
      'foundation': {
        'club': {'from': null, 'prev': null, 'rank': null},
        'diamond': {
          'from': ['column', 3],
          'prev': 'A',
          'rank': 2
        },
        'heart': {'from': null, 'prev': null, 'rank': null},
        'sorted': ['spade', 'heart'],
        'spade': {
          'from': ['column', 3],
          'prev': null,
          'rank': 'A'
        }
      }
    };

    final res = ApiFoundation.fromApi(response);

    expect(res.deckLength, 2);
    expect(res.sorted, ['spade', 'heart']);
    expect(res.club, null);
    expect(res.diamond,
        ApiSuitFoundation(rank: 2, prev: 'A', from: ['column', 3]));
    expect(res.heart, null);
    expect(res.spade, ApiSuitFoundation(from: ['column', 3], rank: 'A'));
  });
}
