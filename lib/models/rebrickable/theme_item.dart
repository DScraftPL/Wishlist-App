class ThemeItem {
  String id;
  String name;
  String? parentId;

  ThemeItem({
    required this.id,
    required this.name,
    this.parentId
  });
}