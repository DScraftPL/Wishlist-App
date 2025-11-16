import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:wishlist_app/models/csv_item.dart';
import 'package:wishlist_app/models/parsed_rss_item.dart';
import 'package:wishlist_app/models/rebrickable/set_item.dart';
import 'package:wishlist_app/models/rebrickable/theme_item.dart';
import 'package:wishlist_app/models/rss_item.dart';
import 'package:wishlist_app/services/rebrickable/rebrickable_service.dart';
import 'package:wishlist_app/services/retirement_service.dart';
import 'package:wishlist_app/services/rss_service.dart';

class DataService extends ChangeNotifier {
  final RssService _rssService = RssService();
  final RetirementService _retirementService = RetirementService();

  List<RetirementItem> _retirementItems = [];
  List<RssItem> _rssItems = [];
  List<ParsedRssItem> _parsedRssItems = [];
  List<ParsedThemeItem> _allThemeItems = [];
  List<ParsedSetItem> _allSetItems = [];

  List<RetirementItem> get retirementItems =>
      List.unmodifiable(_retirementItems);
  List<RssItem> get rssItems => List.unmodifiable(_rssItems);
  List<ParsedRssItem> get parsedRssItems => List.unmodifiable(_parsedRssItems);
  List<ParsedThemeItem> get parsedThemeItem =>
      List.unmodifiable(_allThemeItems);
  List<ParsedSetItem> get allSetItems => List.unmodifiable(_allSetItems);

  bool _loading = false;
  bool _retirementLoading = false;
  bool _rssLoading = false;
  bool _parseRssLoading = false;
  String? _error;

  bool get loading => _loading;
  bool get retirementLoading => _retirementLoading;
  bool get rssLoading => _rssLoading;
  bool get parseRssLoading => _parseRssLoading;
  String? get error => _error;

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }

  void _setRetirementLoading(bool v) {
    _retirementLoading = v;
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
    _setRetirementLoading(true);
    _setRssLoading(true);
    _setParseRssLoading(true);
    _error = null;
    try {
      _retirementItems = await _retirementService.loadCsv();
      _allThemeItems = await _parseThemeItem();
      _allSetItems = await _parseAllItem();
      _setRetirementLoading(false);
      _rssItems = await _rssService.fetchRss();
      _setRssLoading(false);
      _parsedRssItems = _parseRssData();
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

  List<ParsedRssItem> _parseRssData() {
    final Map<String, RetirementItem> setNumberToCsv = {
      for (var obj in _retirementItems) obj.setNumber: obj,
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

  Future<List<ParsedSetItem>> _parseAllItem() async {
    final data = (await RebrickableService.parseSetCsv())
      .where(
        (e) => e.pieceCount != '0' &&  e.pieceCount != '1' 
      )
      .toList();
  
    Map<String, String> idToTheme = {
      for(var obj in _allThemeItems) obj.id : obj.fullName
    };

    return data.map((e) {
      return ParsedSetItem(
        setName: e.setName, 
        setNumber: e.setNumber, 
        themeName: idToTheme[e.themeId] ?? 'Unknown', 
        pieceCount: e.pieceCount,
        link: e.link,
        year: e.year
      );
    }).toList();
  }

  Future<List<ParsedThemeItem>> _parseThemeItem() async {
    final data = await RebrickableService.parseThemeCsv();
    Map<String, String> idToName = {for (var obj in data) obj.id: obj.name};

    List<ParsedThemeItem> result = data.map((e) {
      String result = e.name;
      if (e.parentId != null) {
        e.name += idToName[e.parentId] ?? 'Unknown';
      }
      return ParsedThemeItem(id: e.id, fullName: result);
    }).toList();

    return result;
  }
}
