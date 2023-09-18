import 'package:expense_tracker_2/components/labelled_input.dart';
import 'package:expense_tracker_2/database/local_database.dart';
import 'package:expense_tracker_2/model/category_item.dart';
import 'package:expense_tracker_2/widgets/radial_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({
    super.key,
  });

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  late ExpenseData expenseData;
  late CategoryItem expenseItemToDelete;
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  late int indexToUpdate = 0;
  @override
  void initState() {
    super.initState();
    // Prepare data on startup
    expenseData = Provider.of<ExpenseData>(context, listen: false);
    expenseData.prepareCategoryItems();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void delete() {
    expenseData.deleteExpenseItem(expenseItemToDelete);
    dismiss();
    dismiss();
  }

  void discard() {
    dismiss();
  }

  void dismiss() {
    Navigator.of(context).pop();
  }

  void showDialogue() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text("The delete action is irreversible"),
        actions: [
          MaterialButton(
            onPressed: delete,
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
          MaterialButton(
            onPressed: discard,
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  Widget buildSheet({bool create = true}) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    void saveNewCategory() {
      if (itemNameController.text.isNotEmpty &&
          amountController.text.isNotEmpty) {
        expenseData.addExpenseItem(
          itemNameController.text,
          amountController.text,
        );
      }
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }

    void updateExpenseItem() {
      if (itemNameController.text.isNotEmpty &&
          amountController.text.isNotEmpty) {
        expenseData.updateExpenseItem(
          index: indexToUpdate,
          name: itemNameController.text,
          amount: amountController.text,
        );
      }
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      padding: mediaQueryData.viewInsets,
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            children: [
              const Text(
                'Expense Item Detail',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 25,
              ),
              LabelledInput(
                controller: itemNameController,
                labelledName: "Name",
                keyboardType: TextInputType.name,
                hintText: "Expense Name",
              ),
              const SizedBox(
                height: 20,
              ),
              LabelledInput(
                controller: amountController,
                labelledName: "Amount",
                keyboardType: TextInputType.number,
                hintText: "Spent Amount",
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      if (create) {
                        saveNewCategory();
                      } else {
                        updateExpenseItem();
                      }
                    },
                    child: Text(
                      create ? "Save" : "Update",
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
                    child: const Text(
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
              const SizedBox(
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
    final selectedExpenseItem =
        expenseData.overallExpenseList[expenseData.selectedIndex];
    final double spentAmount =
        expenseData.getSpentAmount(selectedExpenseItem.categoryItems);
    final double totalAmount = selectedExpenseItem.budgetedAmount;
    final double radialBarPercent = spentAmount / totalAmount;
    final String displayAmount =
        "₦${spentAmount.toStringAsFixed(0)} / ₦${totalAmount.toStringAsFixed(0)}";
    var expenseItem = expenseData.getAllExpenseList();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            forceElevated: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(selectedExpenseItem.name),
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
                icon: const Icon(
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
                    margin: const EdgeInsets.all(
                      20,
                    ),
                    padding: const EdgeInsets.all(20),
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(
                            0,
                            2,
                          ),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: CustomPaint(
                      foregroundPainter: RadialPainter(
                          bgColor: Colors.grey[200],
                          lineColor: Colors.green,
                          percent: radialBarPercent,
                          widget: 15),
                      child: Center(
                        child: Text(
                          displayAmount,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                }
                return Column(
                  children: [
                    for (var index = 0; index < expenseItem.length; index++)
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        height: 80,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Slidable(
                          endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              // edit button
                              SlidableAction(
                                onPressed: (context) {
                                  indexToUpdate = index;
                                  itemNameController.text =
                                      expenseItem[index].itemName;
                                  amountController.text =
                                      expenseItem[index].itemPrice.toString();
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    isDismissible: false,
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (context) =>
                                        buildSheet(create: false),
                                  );
                                },
                                icon: Icons.edit,
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              // delete button
                              SlidableAction(
                                onPressed: (p0) {
                                  expenseItemToDelete = expenseItem[index];
                                  showDialogue();
                                },
                                icon: Icons.delete,
                                backgroundColor: Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  expenseItem[index].itemName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '₦${expenseItem[index].itemPrice}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
