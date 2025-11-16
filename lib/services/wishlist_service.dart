import 'package:hive_flutter/hive_flutter.dart';
import 'package:wishlist_app/models/wishlist.dart';

class WishlistService {
  static const boxName = 'wishlistBox';
  static Box<WishlistItem> get wishlistBox =>
      Hive.box<WishlistItem>(boxName);

  static Future<void> addEntry(WishlistItem item) async {
    await wishlistBox.add(item);
  }

  static List<WishlistItem> getAllEntry() {
    return wishlistBox.values.toList();
  }

  static WishlistItem? getEntry(int key) {
    return wishlistBox.get(key);
  }

  static Future<void> updateEntry(int key, WishlistItem item) async {
    await wishlistBox.put(key, item);
  }

  static Future<void> deleteEntry(int key) async {
    await wishlistBox.delete(key);
  }
}
