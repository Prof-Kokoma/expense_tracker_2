import 'package:expense_tracker_2/model/category_item.dart';

class CategorizedExpense {
  String name;
  double budgetedAmount;
  double spentAmount;
  List<CategoryItem> categoryItems;

  CategorizedExpense({
    required this.name,
    required this.budgetedAmount,
    required this.spentAmount,
    required this.categoryItems,
  });

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'budgetedAmount': budgetedAmount,
      'spentAmount': spentAmount,
      'categoryItems': categoryItems.map((e) => e.toJson()).toList(),
    };
  }

  // Create a factory constructor to create an object from JSON
  factory CategorizedExpense.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonCategoryItems = json['categoryItems'];
    List<CategoryItem> categoryItems = jsonCategoryItems.isEmpty
        ? []
        : jsonCategoryItems.map((e) => CategoryItem.fromJson(e)).toList();
    return CategorizedExpense(
        name: json['name'],
        budgetedAmount: json['budgetedAmount'],
        spentAmount: json['spentAmount'],
        categoryItems: categoryItems);
  }
}
