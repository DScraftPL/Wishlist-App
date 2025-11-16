class SetItem {
  String setName;
  String setNumber;
  String themeId;
  String pieceCount;
  String link;

  SetItem({
    required this.setName,
    required this.setNumber,
    required this.themeId,
    required this.pieceCount,
    required this.link,
  });
}

class ParsedSetItem {
  String setName;
  String setNumber;
  String themeName;
  String pieceCount;
  String link;

  ParsedSetItem({
    required this.setName,
    required this.setNumber,
    required this.themeName,
    required this.pieceCount,
    required this.link,
  });
}
