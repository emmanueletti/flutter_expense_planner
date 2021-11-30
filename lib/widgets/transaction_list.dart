import 'package:flutter/material.dart';
import 'package:flutter_expense_planner/widgets/transaction_item.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  const TransactionList(this.userTransactions, this.deleteTransaction,
      {Key? key})
      : super(key: key);
  final List<Transaction> userTransactions;
  final void Function(String txId) deleteTransaction;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    // Another way of creating a sizeable "div" is to wrap Card / widgets in
    // a Container/SizedBox that has a clearly defined width. Card will adjust
    // its size dependent on a clearly defined parent. Apparently when Column
    // is the direct parent, it's size does not affect that of its children.
    // as its children needs. Personal preference thus far is for this format as
    // its seems to look cleaner.
    return SizedBox(
      width: double.infinity,
      // Here is an example of making a specific container WITH A DEFINED
      // HEIGHT (not just the entire app body ) scrollable. An alternate to
      // having a child be a SingleChildScrollView is to use ListView -
      // which is a Flutter shortcut for a a Column + SingleChildScrollView around
      // together with a bunch of additional optimizations. Only gotcha is that
      // it needs to be in a container with a defined height, as ListView has a
      // height of infinity (scrolling) so its container must bound it in a height.

      // Using the ListView builder named constructor is more performant than just
      // supplying the list of widgets to render to ListView children argument
      // via mapping.
      // Builder will lazy load/build the widgets as needed to render on screen
      // while children arguement will build out the entire list regardless of
      // whether they are currently showing up on screen or not.

      // Builder requires the max number of items (x) aka itemCount
      // and a function that will be called the x amount of times aka itemBuilder
      // the function will provide an index counter that can then be used to
      // reference an array/list
      child: userTransactions.isEmpty
          ? LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Column(
                  children: [
                    Text(
                      'No transactions added yet!',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      height: constraints.maxHeight * 0.6,
                      child: Image.asset(
                        'assets/images/waiting.png',
                        // same as doing image width/height as 100% in css
                        // will cover the parents dimensions
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                );
              },
            )
          : ListView.builder(
              itemCount: userTransactions.length,
              itemBuilder: (BuildContext context, int index) {
                return TransactionItem(
                    transaction: userTransactions[index],
                    deleteTransaction: deleteTransaction);
              },
            ),
    );
  }
}
