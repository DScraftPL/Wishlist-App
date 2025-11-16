import 'package:hive_flutter/hive_flutter.dart';

part 'wishlist.g.dart';

@HiveType(typeId: 1)
class WishlistItem {
  @HiveField(0)
  final String setName;

  @HiveField(1)
  final String setNumber;

  @HiveField(2)
  final int pieceCount;

  @HiveField(3)
  final String retirmentDate;

  @HiveField(4)
  final String theme;

  WishlistItem({
    required this.setName,
    required this.setNumber,
    required this.pieceCount,
    required this.retirmentDate,
    required this.theme,
  });
}
