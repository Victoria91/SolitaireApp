import 'package:solitaire_app/data/api/models/api_column_item.dart';

class ApiColumns {
  final List<List<ApiColumnItem>> columns;

  @override
  String toString() {
    return '$columns \n';
  }

  ApiColumns(this.columns);

  ApiColumns.fromApi(Map<String, dynamic> map)
      : columns = map['columns']
            .map((res) => res['cards']
                .toList()
                .reversed
                .toList()
                .map((columnItem) => ApiColumnItem.fromApi(
                    cardData: columnItem,
                    moveable: res['moveable'],
                    unplayed: res['unplayed']))
                .toList()
                .cast<ApiColumnItem>())
            .toList()
            .cast<List<ApiColumnItem>>();
}
