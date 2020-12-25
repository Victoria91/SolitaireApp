import 'package:equatable/equatable.dart';
// import 'package:solitaire_app/domain/models/card_model.dart';

class SortedFoundationModel extends Equatable {
  final List<String> suits;
  final bool changed;
  // final CardModel current;
  // final List from;
  final int unplayedCount;
  // final bool manual;

  List<Object> get props => [suits, changed, unplayedCount];

  @override
  String toString() {
    return 'SortedFoundationModel: suits: $suits -- changed: $changed -- unplayedCount: $unplayedCount \n';
  }

  SortedFoundationModel({
    this.changed,
    this.suits,
    this.unplayedCount,
    // this.from,
    // this.fromCardIndex,
  });
}
