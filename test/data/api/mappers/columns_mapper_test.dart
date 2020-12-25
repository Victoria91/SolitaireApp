import 'package:solitaire_app/data/api/models/api_column_item.dart';
import 'package:solitaire_app/data/api/models/api_columns.dart';
import 'package:solitaire_app/data/mappers/columns_mapper.dart';
import 'package:solitaire_app/domain/models/card_model.dart';
import 'package:solitaire_app/domain/models/columns.dart';
import 'package:test/test.dart';

void main() {
  test('mapper test', () {
    final apiColumns = ApiColumns([
      [
        ApiColumnItem(
          rank: 'K',
          suit: 'diamond',
          moveableCount: 0,
          unplayedCount: 1,
        ),
        ApiColumnItem(
          rank: 'Q',
          suit: 'heart',
          moveableCount: 0,
          unplayedCount: 1,
        )
      ],
      [
        ApiColumnItem(
          rank: 2,
          suit: 'spade',
          moveableCount: 1,
          unplayedCount: 0,
        ),
        ApiColumnItem(
          rank: 9,
          suit: 'club',
          moveableCount: 1,
          unplayedCount: 0,
        ),
      ]
    ]);

    final oldColumns = [
      [
        CardModel(
            played: false,
            suit: CardSuit.diamond,
            rank: CardRank.king,
            moveable: false),
        CardModel(
            played: false,
            suit: CardSuit.heart,
            rank: CardRank.queen,
            moveable: false),
      ],
      [
        CardModel(
            played: true,
            suit: CardSuit.spade,
            rank: CardRank.two,
            moveable: false),
        CardModel(
            played: true,
            suit: CardSuit.club,
            rank: CardRank.nine,
            moveable: true),
        CardModel(
            played: false,
            suit: CardSuit.heart,
            rank: CardRank.queen,
            moveable: false)
      ]
    ];

    final res = ColumnsMapper.fromApi(apiColumns, Columns(oldColumns));

    expect(res.items, [
      [
        CardModel(
            played: false,
            suit: CardSuit.diamond,
            rank: CardRank.king,
            moveable: false,
            isNew: false),
        CardModel(
            played: true,
            suit: CardSuit.heart,
            rank: CardRank.queen,
            moveable: false,
            isNew: true)
      ],
      [
        CardModel(
            played: true,
            suit: CardSuit.spade,
            rank: CardRank.two,
            moveable: false,
            isNew: false),
        CardModel(
            played: true,
            suit: CardSuit.club,
            rank: CardRank.nine,
            moveable: true,
            isNew: false)
      ]
    ]);
  });
}
