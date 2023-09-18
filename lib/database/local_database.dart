/*

  List of Category
  categories: => [
    CategoryList: => {
      name: => food
      budgetedAmount: => 2000
      spentAmount: => 0
    }
  ]

    Create Category
name: => food
budgetedAmount: => 2000
spentAmount: => 0
items: => [
expense_item: {
  item_name: => tiger_nut
item_price: => 1200
dateTime: => 17/09/2023
}
]
*/
import 'dart:convert';

import 'package:expense_tracker_2/model/categorized_expenses.dart';
import 'package:expense_tracker_2/model/category_item.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseData extends ChangeNotifier {
  // list of all expenses
  List<CategorizedExpense> overallExpenseList = [];
  late List<CategorizedExpense> data;
  // late CategorizedExpense selectedExpenseItem;
  int selectedIndex = 0;
  List<CategoryItem> categoryItems = [];
  Map<String, double> graphData = {};

  // add new expense
  void addNewExpense(String name, double amount) {
    CategorizedExpense newExpense = CategorizedExpense(
      name: name,
      budgetedAmount: amount,
      spentAmount: 0,
      categoryItems: [],
    );

    overallExpenseList.add(newExpense);
    saveDataToLocalDB();
    // db.saveData(overallExpenseList);
    notifyListeners();
  }

  // update expense
  void updateExpense(int index, String name, double amount) {
    CategorizedExpense newExpense = CategorizedExpense(
      name: name,
      budgetedAmount: amount,
      spentAmount: 0,
      categoryItems: [],
    );
    overallExpenseList[index] = newExpense;
    // overallExpenseList.add(newExpense);
    saveDataToLocalDB();
    // db.saveData(overallExpenseList);
    notifyListeners();
  }

  List<CategoryItem> getAllExpenseList() {
    return categoryItems;
  }

  void loadDataFromLocalDB() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var dataString = prefs.getStringList('CategorizedExpense');
    if (dataString != null) {
      // var json = jsonDecode(dataString);
      print('I am Here is the data: ${dataString.map((e) => jsonDecode(e))}');
      data = dataString
          .map((e) => CategorizedExpense.fromJson(jsonDecode(e)))
          .toList();

      overallExpenseList = data;
      notifyListeners();
      print('Here is the data: ${data.toString()}');
      // data = [];
    } else {
      print('Here is the data: []');
      data = [];
    }
  }

  void saveDataToLocalDB() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var encodedData =
        overallExpenseList.map((e) => jsonEncode(e.toJson())).toList();
    // var encodedData = jsonEncode(dataString);
    // prefs.setString('CategorizedExpense', encodedData);

    prefs.setStringList('CategorizedExpense', encodedData);
  }

  // add expense item
  void addExpenseItem(String name, String amount) {
    final expenseItem = CategoryItem(
      itemName: name,
      itemPrice: amount,
      dateTime: DateTime.now().toString(),
    );
    overallExpenseList[selectedIndex].categoryItems.add(expenseItem);
    categoryItems = overallExpenseList[selectedIndex].categoryItems;
    // categoryItems.add(expenseItem);
    notifyListeners();
    saveDataToLocalDB();
    // prepareCategoryItems();
  }

  void deleteExpenseItem(CategoryItem expenseItem) {
    overallExpenseList[selectedIndex].categoryItems.remove(expenseItem);
    notifyListeners();
    saveDataToLocalDB();
  }

  void deleteExpense(CategorizedExpense expenseItem) {
    overallExpenseList.remove(expenseItem);
    notifyListeners();
    saveDataToLocalDB();
  }

  void prepareCategoryItems() {
    categoryItems = overallExpenseList[selectedIndex].categoryItems;
    notifyListeners();
  }

  void updateExpenseItem({
    required int index,
    required String name,
    required String amount,
  }) {
    final expenseItem = CategoryItem(
      itemName: name,
      itemPrice: amount,
      dateTime: DateTime.now().toString(),
    );
    overallExpenseList[selectedIndex].categoryItems[index] = expenseItem;
    notifyListeners();
    saveDataToLocalDB();
  }

  double getSpentAmount(List<CategoryItem> categoryItem) {
    return categoryItem.isEmpty
        ? 0
        : categoryItem
            .map((e) => double.parse(e.itemPrice))
            .reduce((value, element) => value + element);
  }

  void prepareData() {}

  // get weekday (mon, tues, etc) from a dateTime object
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return "Mon";
      case 2:
        return "Tues";
      case 3:
        return "Wed";
      case 4:
        return "Thurs";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
        return "Sun";
      default:
        return "";
    }
  }

  // get month (Jan, Feb, etc) from a dateTime object
  String getMonthName(DateTime dateTime) {
    switch (dateTime.month) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "Jun";
      case 7:
        return "Jul";
      case 8:
        return "Aug";
      case 9:
        return "Sept";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";
      default:
        return "";
    }
  }

  String weekTitle() {
    DateTime startOfWeekDays = startOfWeekDate();
    String startOfWeekMonth = getMonthName(startOfWeekDays);
    String startOfWeekDay = startOfWeekDays.day.toString();
    String startOfWeekYear = startOfWeekDays.year.toString();
    DateTime endOfWeekDate = startOfWeekDays.add(
      const Duration(
        days: 6,
      ),
    );
    String endOfWeekMonth = getMonthName(endOfWeekDate);
    String endOfWeekDay = endOfWeekDate.day.toString();
    String endOfWeekYear = endOfWeekDate.year.toString();
    return '$startOfWeekMonth $startOfWeekDay, $startOfWeekYear - $endOfWeekMonth $endOfWeekDay, $endOfWeekYear';
  }

  // get the date for the start of the week ( sunday )
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;

    // get today's date
    DateTime today = DateTime.now();

    // go backwards from today to find sunday

    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }

    return startOfWeek ?? DateTime.now();
  }

  List<double> weeklyAmount() {
    final startOfWeek = startOfWeekDate();
    String sunday = convertDateTimeToString(
      startOfWeek.add(
        const Duration(
          days: 0,
        ),
      ),
    );
    double sunAmount = calculateDailyExpenseSummary()[sunday] ?? 0;
    String monday = convertDateTimeToString(
      startOfWeek.add(
        const Duration(
          days: 1,
        ),
      ),
    );
    double monAmount = calculateDailyExpenseSummary()[monday] ?? 0;
    String tuesday = convertDateTimeToString(
      startOfWeek.add(
        const Duration(
          days: 2,
        ),
      ),
    );
    double tueAmount = calculateDailyExpenseSummary()[tuesday] ?? 0;
    String wednesday = convertDateTimeToString(
      startOfWeek.add(
        const Duration(
          days: 3,
        ),
      ),
    );
    double wedAmount = calculateDailyExpenseSummary()[wednesday] ?? 0;
    String thursday = convertDateTimeToString(
      startOfWeek.add(
        const Duration(
          days: 4,
        ),
      ),
    );
    double thurAmount = calculateDailyExpenseSummary()[thursday] ?? 0;
    String friday = convertDateTimeToString(
      startOfWeek.add(
        const Duration(
          days: 5,
        ),
      ),
    );
    double friAmount = calculateDailyExpenseSummary()[friday] ?? 0;
    String saturday = convertDateTimeToString(
      startOfWeek.add(
        const Duration(
          days: 6,
        ),
      ),
    );
    double satAmount = calculateDailyExpenseSummary()[saturday] ?? 0;
    return [
      sunAmount,
      monAmount,
      tueAmount,
      wedAmount,
      thurAmount,
      friAmount,
      satAmount
    ];
  }

  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {
      // date (yyyymmdd) : amountTotalForDay
    };
    for (var expense in overallExpenseList) {
      for (var item in expense.categoryItems) {
        String date = convertDateTimeToString(DateTime.parse(item.dateTime));
        double amount = double.parse(item.itemPrice);
        dailyExpenseSummary[date] = (dailyExpenseSummary[date] ?? 0) + amount;
      }
    }
    return dailyExpenseSummary;
  }

  String convertDateTimeToString(DateTime dateTime) {
    // year in the format -> yyyy
    String year = dateTime.year.toString();

    // month in the format -> mm
    String month = dateTime.month.toString();
    if (month.length == 1) {
      month = '0$month';
    }

    // day in the format -> dd
    String day = dateTime.day.toString();
    if (day.length == 1) {
      day = '0$day';
    }

    // final format -> yyyymmdd
    String yyyymmdd = year + month + day;

    return yyyymmdd;
  }
}
