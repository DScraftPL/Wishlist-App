import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
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
  bool _csvLoading = false;
  bool _rssLoading = false;
  bool _parseRssLoading = false;
  String? _error;

  bool get loading => _loading;
  bool get csvLoading => _csvLoading;
  bool get rssLoading => _rssLoading;
  bool get parseCsvLoading => _parseRssLoading;
  String? get error => _error;

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }

  void _setCsvLoading(bool v) {
    _csvLoading = v;
    notifyListeners();
  }

  void _setRssLoading(bool v) {
    _rssLoading = v;
    notifyListeners();
  }

  void _setParseRssLoading(bool v) {
    _parseRssLoading = v;
    notifyListeners();
  }

  Future<void> init() async {
    _setLoading(true);
    _setCsvLoading(true);
    _setRssLoading(true);
    _setParseRssLoading(true);
    _error = null;
    try {
      _csvItems = await _csvService.loadCsv();
      _themes = _csvItems.map((e) => e.theme).toSet().toList();
      _setCsvLoading(false);
      _rssItems = await _rssService.fetchRss();
      _setRssLoading(false);
      _parsedRssItems = parseRssData();
      _setParseRssLoading(false);
    } on ClientException {
      _error = "Network Error: Please enable internet!";
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
    final Map<String, CsvItem> setNumberToCsv = {
      for (var obj in _csvItems) obj.setNumber: obj,
    };

    return _rssItems.map((e) {
      final titleParsed = e.title.split(' ');
      final parsedSetNumber = titleParsed[1];
      // String parsedSetTheme = titleParsed[2];
      final itemFromMap = setNumberToCsv[parsedSetNumber];

      return ParsedRssItem(
        discountPrice: titleParsed.last,
        link: e.link,
        pieceCount: itemFromMap?.pieceCount ?? 'Unknown',
        retirementDate: itemFromMap?.retirementDate ?? 'Retired',
        setName: itemFromMap?.setName ?? e.title.split(' - ')[1],
        setNumber: parsedSetNumber,
        theme: itemFromMap?.theme ?? titleParsed[2],
      );
    }).toList();
  }
}
