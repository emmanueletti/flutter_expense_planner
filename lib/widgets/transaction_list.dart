import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  const TransactionList(this.userTransactions, {Key? key}) : super(key: key);
  final List<Transaction> userTransactions;

  @override
  Widget build(BuildContext context) {
    // Another way of creating a sizeable "div" is to wrap Card / widgets in
    // a Container/SizedBox that has a clearly defined width. Card will adjust
    // its size dependent on a clearly defined parent. Apparently when Column
    // is the direct parent, it's size does not affect that of its children.
    // as its children needs. Personal preference thus far is for this format as its seems to look cleaner.
    return SizedBox(
      width: double.infinity,
      height: 400,
      // Here is an example of making a specific container WITH A DEFINED
      // HEIGHT (not just the entire app body ) scrollable by having its child
      // be a SingleChildScrollView
      child: SingleChildScrollView(
        child: Column(
          children: userTransactions.map((transaction) {
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
                          color: Colors.purple,
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "\$${transaction.amount}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          transaction.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          // DateFormat package
                          DateFormat.yMMMd().format(transaction.date),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
