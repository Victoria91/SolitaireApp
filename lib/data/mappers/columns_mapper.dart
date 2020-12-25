import 'package:solitaire_app/data/api/models/api_columns.dart';
import 'package:solitaire_app/data/mappers/card_mapper.dart';
import 'package:solitaire_app/domain/models/columns.dart';

class ColumnsMapper {
  static Columns fromApi(ApiColumns apiColumns, Columns oldColumns) {
    final items = apiColumns.columns
        .asMap()
        .entries
        .map((apiColumnItemListData) => cardColumnNotChanged(
                oldColumns, apiColumns, apiColumnItemListData.key)
            ? oldColumns.items[apiColumnItemListData.key]
            : apiColumnItemListData.value
                .asMap()
                .entries
                .map((apiColumnItem) => CardMapper.fromApiColumnItem(
                      apiColumnItem.value,
                      apiColumnItem.key,
                      apiColumnItemListData.value.length,
                      oldColumns.items.isEmpty
                          ? []
                          : oldColumns.items[apiColumnItemListData.key],
                    ))
                .toList())
        .toList();

    return Columns(items);
  }
}

bool cardColumnNotChanged(
    Columns oldColumns, ApiColumns apiColumns, int columnIndex) {
  if (oldColumns.items.isEmpty) {
    return false;
  }
  final oldColumn = oldColumns.items[columnIndex];
  return oldColumn.length == apiColumns.columns[columnIndex].length &&
      (oldColumn.isNotEmpty && oldColumn.last.played == true) &&
      (oldColumn.isNotEmpty && oldColumn.last.moveable == true);
}
