import 'package:flutter/foundation.dart';

class WishlistModel extends ChangeNotifier {
  final List<String> _items = List.generate(10, (i) => 'i = $i');

  List<String> get items => List.unmodifiable(_items);

  void add(String item) {
    _items.insert(0, item);
    notifyListeners();
  }

  void removeAt(int index) {
    if(index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }
}
