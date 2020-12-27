import 'package:equatable/equatable.dart';
import 'package:solitaire_app/domain/models/card_model.dart';

class SuitFoundationModel extends Equatable {
  const SuitFoundationModel(
      {this.fromCardIndex,
      this.current,
      this.from,
      this.deckLength,
      this.prev,
      this.manual,
      this.changed});

  final CardModel prev;
  final CardModel current;
  final List from;
  final int fromCardIndex;
  final int deckLength;
  final bool manual;
  final bool changed;

  @override
  List<Object> get props =>
      [prev, current, from, fromCardIndex, deckLength, manual];

  @override
  String toString() {
    return 'manual : $manual \n deckLength : $deckLength \n changed: $changed \n prev: $prev \n current: $current \n from: $from \n fromCardIndex: $fromCardIndex \n';
  }
}
