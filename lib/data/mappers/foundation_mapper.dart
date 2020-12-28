import 'package:solitaire_app/data/api/models/api_foundation.dart';
import 'package:solitaire_app/data/mappers/suit_foundation_mapper.dart';
import 'package:solitaire_app/domain/models/foundation_model.dart';
import 'package:solitaire_app/domain/models/sorted_foundation_model.dart';

class FoundationMapper {
  static FoundationModel fromApi(
      {ApiFoundation apiFoundation,
      Map response,
      bool manual,
      FoundationModel oldFoundationModel}) {
    return FoundationModel(
      sorted: SortedFoundationModel(
          unplayedCount: 8 - apiFoundation.sorted.length,
          suits: apiFoundation.sorted,
          changed: oldFoundationModel.sorted == null ||
              oldFoundationModel.sorted.suits.length !=
                  apiFoundation.sorted.length),
      spade: SuitFoundationMapper.fromApi(
          apiSuitFoundation: apiFoundation.spade,
          suitString: 'spade',
          manual: manual,
          response: response,
          oldSuitFoundationModel: oldFoundationModel.spade,
          deckLength: apiFoundation.deckLength),
      heart: SuitFoundationMapper.fromApi(
          apiSuitFoundation: apiFoundation.heart,
          suitString: 'heart',
          manual: manual,
          response: response,
          oldSuitFoundationModel: oldFoundationModel.heart,
          deckLength: apiFoundation.deckLength),
      club: SuitFoundationMapper.fromApi(
          apiSuitFoundation: apiFoundation.club,
          suitString: 'club',
          manual: manual,
          response: response,
          oldSuitFoundationModel: oldFoundationModel.club,
          deckLength: apiFoundation.deckLength),
      diamond: SuitFoundationMapper.fromApi(
          apiSuitFoundation: apiFoundation.diamond,
          suitString: 'diamond',
          manual: manual,
          response: response,
          oldSuitFoundationModel: oldFoundationModel.diamond,
          deckLength: apiFoundation.deckLength),
    );
  }
}

List fetchFrom(ApiFoundation apiFoundation, List suits) {
  return suits.isNotEmpty
      ? {
          'spade': apiFoundation.spade,
          'heart': apiFoundation.heart,
          'diamond': apiFoundation.diamond,
          'club': apiFoundation.club
        }[suits.last]
          .from
      : null;
}
