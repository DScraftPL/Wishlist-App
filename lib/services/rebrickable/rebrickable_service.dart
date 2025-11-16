import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:wishlist_app/models/rebrickable/minifig_item.dart';
import 'package:wishlist_app/models/rebrickable/set_item.dart';
import 'package:wishlist_app/models/rebrickable/theme_item.dart';

class RebrickableService {
  static Future<List<T>> _parseCsv<T>(
    String file,
    T Function(List<dynamic>) rowParser,
  ) async {
    final raw = await rootBundle.loadString(file);
    final rows = const CsvToListConverter().convert(raw);

    final List<T> result = [];

    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      result.add(rowParser(row));
    }

    return result;
  }

  static Future<List<SetItem>> parseSetCsv({
    String setLink = 'assets/csv/sets.csv',
  }) async {
    return _parseCsv(setLink, (row) {
      String cell(int id) => row[id].toString().trim();

      return SetItem(
        link: cell(5),
        setName: cell(1),
        setNumber: cell(0),
        themeId: cell(3),
        pieceCount: cell(4),
      );
    });
  }

  static Future<List<ThemeItem>> parseThemeCsv({
    String themeLink = 'assets/csv/themes.csv',
  }) async {
    return _parseCsv(themeLink, (row) {
      String cell(int id) => row[id].toString().trim();

      return ThemeItem(id: cell(0), name: cell(1), parentId: cell(2));
    });
  }

  static Future<List<MinifigItem>> parseMinifigCsv({
    String minifigLink = 'assets/csv/minifigs.csv',
  }) async {
    return _parseCsv(minifigLink, (row) {
      String cell(int id) => row[id].toString().trim();

      return MinifigItem(
        figureName: cell(1),
        figureNumber: cell(0),
        link: cell(2),
      );
    });
  }
}
