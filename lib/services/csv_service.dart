import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import '../models/csv_item.dart';

class CsvService {
  Future<List<CsvItem>> loadCsv({
    String csvFile = 'assets/csv/expiration_date.csv',
  }) async {
    final raw = await rootBundle.loadString(csvFile);
    final rows = const CsvToListConverter().convert(raw);

    final List<CsvItem> result = [];

    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      String cell(int id) => row[id].toString().trim();

      final temp = cell(5);

      if (temp.isEmpty || temp == 'Piece Count' || temp == '-') {
        continue;
      }

      result.add(
        CsvItem(
          theme: cell(0),
          setName: cell(3),
          setNumber: cell(2),
          pieceCount: cell(5),
          retirementDate: cell(6),
        ),
      );
    }

    return result;
  }
}
