class Categories {
  int id;
  String categoryName;
  String childCategories;
  bool hasChildren;
  String categoryIcon;
  String categoryParentName;
  Categories(
      {required this.id,
      required this.categoryName,
      required this.childCategories,
      required this.hasChildren,
      required this.categoryIcon,
      required this.categoryParentName});

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
      id: json["id"] ?? 0,
      categoryName: json["categoryName"] ?? "",
      childCategories: json["childCategories"] ?? "",
      hasChildren: json["hasChildren"] ?? false,
      categoryIcon: json["categoryIcon"] ?? "",
      categoryParentName: json["parentName"] ?? "");
  factory Categories.fromMap(Map<String, dynamic> map) {
    return Categories(
        id: map["id"] ?? 0,
        categoryName: map["name"] ?? "",
        childCategories: map["childCategories"] ?? "",
        hasChildren: map["hasChildren"] ?? false,
        categoryIcon: map["categoryIcon"] ?? "",
        categoryParentName: map["parentName"] ?? "");
  }
}
