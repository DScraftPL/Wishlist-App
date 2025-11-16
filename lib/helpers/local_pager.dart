import 'package:flutter/material.dart';

class LocalPager<T> extends ChangeNotifier {
  final List<T> source;
  final int pageSize;

  final List<T> _visible = [];
  int _page = 0;
  
  bool get hasMore => _visible.length < source.length;
  List<T> get items => _visible;

  LocalPager(this.source, {this.pageSize = 30}) {
    loadNextPage();
  }

  void loadNextPage() {
    if(!hasMore) return;

    final start = _page * pageSize;
    final end = (start + pageSize).clamp(0, source.length);

    _visible.addAll(source.sublist(start,end));
    _page++;
    notifyListeners();
  }
}