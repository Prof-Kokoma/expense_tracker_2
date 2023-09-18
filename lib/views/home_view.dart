import 'package:expense_tracker_2/components/labelled_input.dart';
import 'package:expense_tracker_2/database/local_database.dart';
import 'package:expense_tracker_2/widgets/bar_chart.dart';
import 'package:expense_tracker_2/widgets/category_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late ExpenseData expenseData;
  late int indexToUpdate;
  final TextEditingController catNameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    expenseData = Provider.of<ExpenseData>(context, listen: false);
    expenseData.loadDataFromLocalDB();
    super.initState();
    // Prepare data on startup

    // expenseData.prepareData();
  }

  Widget buildSheet({bool create = true}) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    void saveNewCategory() {
      if (create) {
        expenseData.addNewExpense(
          catNameController.text,
          double.parse(amountController.text),
        );
        Navigator.of(context).pop();
      } else {
        //
        expenseData.updateExpense(
          indexToUpdate,
          catNameController.text,
          double.parse(amountController.text),
        );
        Navigator.of(context).pop();
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      padding: mediaQueryData.viewInsets,
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            children: [
              Text(
                'Category Detail',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 25,
              ),
              LabelledInput(
                controller: catNameController,
                labelledName: "Name",
                keyboardType: TextInputType.name,
                hintText: "Category Name",
              ),
              SizedBox(
                height: 20,
              ),
              LabelledInput(
                controller: amountController,
                labelledName: "Amount",
                keyboardType: TextInputType.number,
                hintText: "Budgeted Amount",
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      saveNewCategory();
                    },
                    child: Text(
                      create ? "Save" : 'Update',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 100,
              forceElevated: true,
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text("My Expense Tracker"),
                centerTitle: true,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      isDismissible: false,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) => buildSheet(),
                    );
                  },
                  icon: Icon(
                    Icons.add,
                    size: 30,
                  ),
                )
              ],
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: 2,
                (BuildContext context, int index) {
                  if (index == 0) {
                    return Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 2),
                              blurRadius: 6)
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: BarChart(
                        value: value,
                      ),
                    );
                  }
                  return CategoryWidget(
                    value: value,
                    onPressed: (p0, p1) {
                      indexToUpdate = p1;
                      var item = value.overallExpenseList[p1];
                      catNameController.text = item.name;
                      amountController.text = item.budgetedAmount.toString();

                      showModalBottomSheet(
                        isScrollControlled: true,
                        isDismissible: false,
                        backgroundColor: Colors.transparent,
                        context: p0,
                        builder: (p0) => buildSheet(create: false),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
