import 'package:solitaire_app/data/api/models/api_column_item.dart';
import 'package:solitaire_app/data/api/models/api_columns.dart';
import 'package:test/test.dart';

void main() {
  test('fromApi constructor', () {
    final res = ApiColumns.fromApi({
      'columns': [
        {
          'cards': [
            ['diamond', 'K']
          ],
          'moveable': 10,
          'unplayed': 0
        },
        {
          'cards': [
            ['diamond', '9'],
            ['spade', '2']
          ],
          'moveable': 12,
          'unplayed': 1
        }
      ]
    });

    expect(res.columns, const [
      [
        ApiColumnItem(
          rank: 'K',
          suit: 'diamond',
          moveableCount: 10,
          unplayedCount: 0,
        )
      ],
      [
        ApiColumnItem(
          rank: '2',
          suit: 'spade',
          moveableCount: 12,
          unplayedCount: 1,
        ),
        ApiColumnItem(
          rank: '9',
          suit: 'diamond',
          moveableCount: 12,
          unplayedCount: 1,
        ),
      ]
    ]);
  });
}
