import 'package:solitaire_app/domain/models/sorted_foundation_model.dart';
import 'package:solitaire_app/domain/models/suit_foundation_model.dart';

class FoundationModel {
  const FoundationModel({
    this.club,
    this.diamond,
    this.sorted,
    this.spade,
    this.heart,
  });

  final SuitFoundationModel club;
  final SuitFoundationModel diamond;
  final SuitFoundationModel spade;
  final SuitFoundationModel heart;
  final SortedFoundationModel sorted;
}
