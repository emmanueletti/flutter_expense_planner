import 'package:flutter/material.dart';
import 'package:flutter_expense_planner/models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.deleteTransaction,
  }) : super(key: key);

  final Transaction transaction;
  final void Function(String txId) deleteTransaction;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              padding: const EdgeInsets.all(10),
              child: Text(
                // toStringAsFixed is the way to get a number to a specified
                // decimal place
                "\$${transaction.amount.toStringAsFixed(2)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  transaction.title,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  // DateFormat package
                  DateFormat.yMMMd().format(transaction.date),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                )
              ],
            ),
            const Expanded(
              child: SizedBox(
                width: 10,
              ),
            ),
            mediaQuery.size.width < 360
                ? IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteTransaction(transaction.id),
                    color: Theme.of(context).errorColor,
                  )
                : FlatButton.icon(
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    textColor: Theme.of(context).errorColor,
                    onPressed: () => deleteTransaction(transaction.id),
                  )
          ],
        ),
      ),
    );
  }
}
