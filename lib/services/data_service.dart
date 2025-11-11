import 'package:flutter/foundation.dart';
import 'package:wishlist_app/models/csv_item.dart';
import 'package:wishlist_app/models/parsed_rss_item.dart';
import 'package:wishlist_app/models/rss_item.dart';
import 'package:wishlist_app/services/csv_service.dart';
import 'package:wishlist_app/services/rss_service.dart';

class DataService extends ChangeNotifier {
  final RssService _rssService = RssService();
  final CsvService _csvService = CsvService();

  List<CsvItem> _csvItems = [];
  List<RssItem> _rssItems = [];
  List<ParsedRssItem> _parsedRssItems = [];
  List<String> _themes = [];

  List<CsvItem> get csvItems => List.unmodifiable(_csvItems);
  List<RssItem> get rssItems => List.unmodifiable(_rssItems);
  List<ParsedRssItem> get parsedRssItems => List.unmodifiable(_parsedRssItems);
  List<String> get themes => List.unmodifiable(_themes);

  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }

  Future<void> init() async {
    _setLoading(true);
    _error = null;
    try {
      _csvItems = await _csvService.loadCsv();
      _rssItems = await _rssService.fetchRss();
      _themes = _csvItems.map((e) => e.theme).toSet().toList();
      _parsedRssItems = parseRssData();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshRss() async {
    try {
      final items = await _rssService.fetchRss();
      _rssItems = items;
    } catch (e) {
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  List<ParsedRssItem> parseRssData() {
    final List<ParsedRssItem> result = [];

    final Map<String, CsvItem> setNumberToCsv = {
      for (var obj in _csvItems) obj.setNumber: obj,
    };

    for (final rss in _rssItems) {
      List<String> titleParsed = rss.title.split(' ');
      List<String> titleOfTitle = rss.title.split(' - ');
      String parsedSetNumber = titleParsed[1];
      String parsedSetTheme = titleParsed[2];

      CsvItem? itemFromMap = setNumberToCsv[parsedSetNumber];

      result.add(
        ParsedRssItem(
          discountPrice: titleParsed.last,
          link: rss.link,
          pieceCount: itemFromMap?.pieceCount ?? 'Unknown',
          retirementDate: itemFromMap?.retirementDate ?? 'Retired',
          setName: itemFromMap?.setName ?? titleOfTitle[1],
          setNumber: parsedSetNumber,
          theme: itemFromMap?.theme ?? parsedSetTheme,
        ),
      );
    }

    return result;
  }
}
