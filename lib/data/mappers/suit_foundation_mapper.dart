import 'package:solitaire_app/data/api/models/api_suit_foundation.dart';
import 'package:solitaire_app/data/mappers/card_mapper.dart';
import 'package:solitaire_app/domain/models/suit_foundation_model.dart';
import 'package:collection/collection.dart';

class SuitFoundationMapper {
  static SuitFoundationModel fromApi(
      {ApiSuitFoundation apiSuitFoundation,
      String suitString,
      Map response,
      int deckLength,
      SuitFoundationModel oldSuitFoundationModel,
      bool manual}) {
    final newCurrent = apiSuitFoundation != null
        ? CardMapper.fromApiFoundation(apiSuitFoundation.rank, suitString)
        : null;
    final eq = const ListEquality().equals;

    if (oldSuitFoundationModel != null &&
        newCurrent == oldSuitFoundationModel.current &&
        apiSuitFoundation != null &&
        eq(
          oldSuitFoundationModel.from,
          apiSuitFoundation.from,
        )) {
      return oldSuitFoundationModel;
    }

    return SuitFoundationModel(
        current: newCurrent,
        manual: manual,
        fromCardIndex: calculateFromCardIndex(apiSuitFoundation, response),
        from: apiSuitFoundation != null ? apiSuitFoundation.from : null,
        deckLength: deckLength,
        changed: oldSuitFoundationModel == null || apiSuitFoundation != null,
        prev: apiSuitFoundation != null
            ? CardMapper.fromApiFoundation(apiSuitFoundation.prev, suitString)
            : null);
  }
}

dynamic calculateFromCardIndex(
    ApiSuitFoundation apiSuitFoundation, Map response) {
  if (apiSuitFoundation != null &&
      apiSuitFoundation.from != null &&
      apiSuitFoundation.from[0] == 'column') {
    return response['columns'][apiSuitFoundation.from[1]]['cards'].length + 1;
  }
}
