import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import '../models/display_item.dart';

Future<List<DisplayItem>> loadCsv() async {
  final raw = await rootBundle.loadString('assets/csv/expiration_date.csv');
  final rows = const CsvToListConverter().convert(raw);

  final List<DisplayItem> result = [];

  for (var i = 0; i < rows.length; i++) {
    final row = rows[i];
    String cell(int id) => row[id].toString().trim();

    final temp = cell(5);

    if(temp.isEmpty || temp == 'Piece Count' || temp == '-') {
      continue;
    }

    result.add(
      DisplayItem(
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

class CsvService {
  final List<DisplayItem> csvList;

  CsvService(this.csvList);

  static Future<CsvService> load() async {
    final data = await loadCsv();
    return CsvService(data);
  }
}
