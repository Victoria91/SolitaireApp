import 'package:equatable/equatable.dart';

class SortedFoundationModel extends Equatable {
  const SortedFoundationModel({
    this.changed,
    this.suits,
    this.unplayedCount,
  });

  final List<String> suits;
  final bool changed;
  final int unplayedCount;

  @override
  List<Object> get props => [suits, changed, unplayedCount];

  @override
  String toString() {
    return 'SortedFoundationModel: suits: $suits -- changed: $changed -- unplayedCount: $unplayedCount \n';
  }
}
