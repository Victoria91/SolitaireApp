import 'package:solitaire_app/domain/models/card_model.dart';

class Columns {
  Columns(this.items);

  final List<List<CardModel>> items;

  @override
  String toString() {
    return '$items\n';
  }
}
