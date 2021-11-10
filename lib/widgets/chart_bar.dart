import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  const ChartBar(this.label, this.spendingAmount, this.spendingPercentOfTotal,
      {Key? key})
      : super(key: key);

  final String label;
  final double spendingAmount;
  final double spendingPercentOfTotal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FittedBox(
          child: Text('\$${spendingAmount.toStringAsFixed(0)}'),
        ),
        const SizedBox(
          height: 4,
        ),
        Container(
          height: 60,
          width: 12,
          // Stack starts with the bottom most widget
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0),
                  color: const Color.fromRGBO(220, 220, 220, 1),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              FractionallySizedBox(
                // needs a value between 0 and 1 to determine the percentage
                // of the next surrounding defined height to take up.
                // The next surrounding defined height is 60
                heightFactor: spendingPercentOfTotal,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}
