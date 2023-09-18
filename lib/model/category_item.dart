class CategoryItem {
  String itemName;
  String itemPrice;
  String dateTime;

  CategoryItem({
    required this.itemName,
    required this.itemPrice,
    required this.dateTime,
  });

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'itemPrice': itemPrice,
      'dateTime': dateTime,
    };
  }

  // Create a factory constructor to create an object from JSON
  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      itemName: json['itemName'],
      itemPrice: json['itemPrice'],
      dateTime: json['dateTime'],
    );
  }
}
