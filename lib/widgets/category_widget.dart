import 'package:expense_tracker_2/database/local_database.dart';
import 'package:expense_tracker_2/model/categorized_expenses.dart';
import 'package:expense_tracker_2/views/category_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CategoryWidget extends StatefulWidget {
  final ExpenseData value;
  final Function(BuildContext, int) onPressed;

  const CategoryWidget({
    super.key,
    required this.value,
    required this.onPressed,
  });

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  late int indexToUpdate = 0;
  late CategorizedExpense expenseItemToDelete;

  double calculateWidth(
      double totalWidth, double currentAmount, double totalAmount) {
    return currentAmount / totalAmount * totalWidth;
  }

  void delete() {
    widget.value.deleteExpense(expenseItemToDelete);
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
        title: const Text('Deleting'),
        content: Text("Are you sure?. This process is irreversible"),
        actions: [
          MaterialButton(
            onPressed: delete,
            child: const Text("Delete"),
          ),
          MaterialButton(
            onPressed: discard,
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 60;
    var category = widget.value.overallExpenseList;
    return Column(
      children: [
        for (int index = 0; index < category.length; index++)
          GestureDetector(
            onTap: () {
              widget.value.selectedIndex =
                  widget.value.overallExpenseList.indexOf(category[index]);
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const CategoryView();
              }));
            },
            child: Slidable(
              endActionPane: ActionPane(
                motion: const StretchMotion(),
                children: [
                  // edit button
                  SlidableAction(
                    onPressed: (context) {
                      indexToUpdate = index;
                      // itemNameController.text = category[index].itemName;
                      // amountController.text =
                      //     category[index].itemPrice.toString();
                      widget.onPressed(context, index);
                    },
                    icon: Icons.edit,
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  // delete button
                  SlidableAction(
                    onPressed: (p0) {
                      expenseItemToDelete = category[index];
                      showDialogue();
                    },
                    icon: Icons.delete,
                    backgroundColor: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 2),
                        blurRadius: 6),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          category[index].name,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₦${widget.value.getSpentAmount(category[index].categoryItems).toStringAsFixed(0)} / ₦${category[index].budgetedAmount.toStringAsFixed(0)}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Stack(
                      children: [
                        Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        Container(
                          height: 20,
                          width: calculateWidth(
                              width,
                              widget.value.getSpentAmount(
                                  category[index].categoryItems),
                              category[index].budgetedAmount),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
      ],
    );
  }
}
