import 'package:solitaire_app/domain/models/sorted_foundation_model.dart';
import 'package:test/test.dart';
import 'package:solitaire_app/data/api/models/api_foundation.dart';
import 'package:solitaire_app/data/api/models/api_suit_foundation.dart';
import 'package:solitaire_app/data/mappers/foundation_mapper.dart';
import 'package:solitaire_app/domain/models/card_model.dart';
import 'package:solitaire_app/domain/models/foundation_model.dart';
import 'package:solitaire_app/domain/models/suit_foundation_model.dart';

void main() {
  test('foundation mapper', () {
    const apiFoundation = ApiFoundation(
      deckLength: 3,
      sorted: ['spade', 'club'],
      diamond: ApiSuitFoundation(rank: 2, prev: 'A', from: ['column', 0]),
      club: ApiSuitFoundation(rank: 'A', prev: null, from: ['deck']),
      spade: null,
      heart: ApiSuitFoundation(rank: 2, prev: 'A', from: ['column', 1]),
    );

    const oldFoundationModel = FoundationModel(club: SuitFoundationModel());

    final res = FoundationMapper.fromApi(
        manual: true,
        apiFoundation: apiFoundation,
        oldFoundationModel: oldFoundationModel,
        response: {
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

    expect(
        res.sorted,
        const SortedFoundationModel(
          suits: ['spade', 'club'],
          changed: true,
          unplayedCount: 6,
        ));
    expect(res.spade,
        const SuitFoundationModel(manual: true, changed: true, deckLength: 3));
    expect(
        res.club,
        SuitFoundationModel(
            fromCardIndex: null,
            deckLength: 3,
            from: apiFoundation.club.from,
            current: const CardModel(
                played: true,
                moveable: true,
                rank: CardRank.ace,
                suit: CardSuit.club),
            prev: null,
            changed: false,
            manual: true));

    expect(
        res.heart,
        const SuitFoundationModel(
          deckLength: 3,
          current: CardModel(
              rank: CardRank.two,
              played: true,
              moveable: true,
              suit: CardSuit.heart),
          prev: CardModel(
              rank: CardRank.ace,
              played: true,
              moveable: true,
              suit: CardSuit.heart),
          changed: true,
          from: ['column', 1],
          manual: true,
          fromCardIndex: 3,
        ));

    expect(
        res.diamond,
        const SuitFoundationModel(
          from: ['column', 0],
          deckLength: 3,
          fromCardIndex: 2,
          changed: true,
          prev: CardModel(
              played: true,
              moveable: true,
              rank: CardRank.ace,
              suit: CardSuit.diamond),
          current: CardModel(
              rank: CardRank.two,
              played: true,
              moveable: true,
              suit: CardSuit.diamond),
          manual: true,
        ));
  });
}
