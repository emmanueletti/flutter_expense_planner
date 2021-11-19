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
    // Layout builder gives access to constraints object, which contains info
    // about external constraints aka heights and width being applied to the
    // widget. This can be used to help calculate relative constraints (heights
    // and widths) for responsiveness
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Column(
          children: [
            // Fittedbox makes widgets within then shrink instead of wrap when they
            // get to big for the container
            Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                child: Text('\$${spendingAmount.toStringAsFixed(0)}'),
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            Container(
              height: constraints.maxHeight * 0.6,
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
            SizedBox(height: constraints.maxHeight * 0.05),
            Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                child: Text(label),
              ),
            )
          ],
        );
      },
    );
  }
}
