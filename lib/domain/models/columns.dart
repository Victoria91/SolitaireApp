import 'package:solitaire_app/domain/models/card_model.dart';

class Columns {
  final List<List<CardModel>> items;

  Columns(this.items);

  @override
  String toString() {
    return '$items\n';
  }
}
