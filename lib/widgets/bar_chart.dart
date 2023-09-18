import 'package:expense_tracker_2/database/local_database.dart';
import 'package:flutter/material.dart';

class BarChart extends StatelessWidget {
  final ExpenseData value;
  const BarChart({
    super.key,
    required this.value,
  });

  double getMaxData(List<double> weekData) {
    final sortedData = weekData;
    sortedData.sort();
    final maxData = sortedData.last;
    return maxData;
  }

  double calculateHeight(double currentData, double maxData) =>
      currentData / maxData * 200;

  @override
  Widget build(BuildContext context) {
    // final double maxBarHeigt = 220;
    final List<double> weeklyData = value.weeklyAmount();
    final List<double> weekData = value.weeklyAmount();
    final double maxData = getMaxData(weeklyData);
    final List<String> weekDays = [
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
    ];
    return Column(
      children: [
        Text(
          "Weekly Expenses",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // IconButton(
            //   onPressed: () {},
            //   icon: Icon(
            //     Icons.arrow_back,
            //     size: 30,
            //   ),
            // ),
            Text(
              value.weekTitle(),
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),
            // IconButton(
            //   onPressed: () {},
            //   icon: Icon(
            //     Icons.arrow_forward,
            //     size: 30,
            //   ),
            // ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (int i = 0; i < 7; i++)
              Column(
                children: [
                  Text(
                    '₦${weekData[i].toStringAsFixed(0)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: calculateHeight(weekData[i], maxData),
                    width: 18,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    weekDays[i],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
          ],
        )
      ],
    );
  }
}
