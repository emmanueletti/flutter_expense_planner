import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransactions;

  const TransactionList(this.userTransactions, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Alternative is to wrap Card in a Container/SizedBox that has a clearly
    // defined width. Card will adjust have its size dependent on a clearly defined
    // parent that apparently is not Column, whuch will only give as much space
    // as its children needs. Personal preference thus far is for this format as
    // its seems to look cleaner.
    return SizedBox(
      width: double.infinity,
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
    );
  }
}
