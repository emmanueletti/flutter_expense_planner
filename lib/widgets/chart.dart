import 'package:flutter/material.dart';
import 'package:flutter_expense_planner/models/transaction.dart';
import 'package:flutter_expense_planner/widgets/chart_bar.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  const Chart(this.recentTransctions, {Key? key}) : super(key: key);

  final List<Transaction> recentTransctions;

  // We could make our own custom class / type
  // Takes recent transactions (which is defined as transactions within the
  // past week) and groups them by day
  List<Map<String, dynamic>> get groupedTransactionValues {
    // Lesson 100 to review

    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;
      // Loop within a loop - not a great scalable algorithm
      // if recentTranscations is a very long list, could be a perfomance hit
      for (var i = 0; i < recentTransctions.length; i++) {
        bool sameDay = recentTransctions[i].date.day == weekDay.day;
        bool sameMonth = recentTransctions[i].date.month == weekDay.month;
        bool sameYear = recentTransctions[i].date.year == weekDay.year;

        // if transactions all occured on the same day
        // isolating day, month, and year b/c datetime object has timestamp
        // value while would make direct comparison always return false
        // due to timestamp
        if (sameDay && sameMonth && sameYear) {
          totalSum += recentTransctions[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  // calculates the total spending of the whole period of grouped transaction
  // here defined as the last 7 days
  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (acc, tx) {
      return acc += tx['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            var spendingPercentOfTotal =
                totalSpending == 0.0 ? 0.0 : data['amount'] / totalSpending;
            // Flexible widget and its fit/Flexfit is used distribute available space
            // think of it like css flexbox. Flex set to flexfit.loose is the default
            // Lesson 106 to review
            // Expanded widget is a shortcut for a Flexible widget with fit set
            // to Fletfit.tight
            return Flexible(
              fit: FlexFit.tight,
              child:
                  ChartBar(data['day'], data['amount'], spendingPercentOfTotal),
            );
          }).toList(),
        ),
      ),
    );
  }
}
