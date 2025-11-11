class ParsedRssItem {
  String setName;
  String setNumber;
  String pieceCount;
  String retirementDate;
  String theme;
  String discountPrice;
  String link;

  ParsedRssItem({
    required this.discountPrice,
    required this.link,
    required this.pieceCount,
    required this.retirementDate,
    required this.setName,
    required this.setNumber,
    required this.theme
  });
}