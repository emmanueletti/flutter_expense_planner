import 'dart:developer';
import 'package:flutter/material.dart';

import './transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<Transaction> transactions = [
    Transaction(
      id: 't1',
      title: 'New Shoes',
      amount: 79.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Groceries',
      amount: 89.99,
      date: DateTime.now(),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter App'),
      ),
      body: Column(
        children: <Widget>[
          // Reason to use Container as a middle widget to control the size is
          // b/c "Card" widget dimensions is dependent on the size of its children.
          // And "Text" widget dimensions is dependent on the size of its text
          // content and it's parent size. So with both dependent on each other
          // Container acts as the middle widget to control the size, which
          // subsequently controls the size of Card and Text as the sizeable
          // Container now serves as the direct child of Card and direct parent of Text
          Card(
            child: Container(
              // A width of double.infinity is a enum representation of a behind
              // the scenes number. "double.infinity" is tells Flutter to give
              // the widget as much width as possible.
              width: double.infinity,
              child: Text('CHART!'),
            ),
            elevation: 5,
          ),
          // alternative is to wrap Card in a Container that has a clearly defined
          // width. Card will adjust have its size dependent on a clearly defined
          // parent that apparently is not Column, whuch will only give as much
          // space as its children needs.
          // Personal preference thus far is for this format as its seems to look cleaner.
          Container(
            width: double.infinity,
            child: Column(
              children: transactions.map((transaction) {
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
                            transaction.amount.toString(),
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
                              transaction.title.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              transaction.formattedDate,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
