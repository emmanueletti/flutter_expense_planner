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
    // as its children needs. Personal preference thus far is for this format as
    // its seems to look cleaner.
    return SizedBox(
      width: double.infinity,
      height: 400,
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
      child: ListView.builder(
        itemCount: userTransactions.length,
        itemBuilder: (BuildContext context, int index) {
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
                      // toStringAsFixed is the way to get a number to a specified
                      // decimal place
                      "\$${userTransactions[index].amount.toStringAsFixed(2)}",
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
                        userTransactions[index].title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        // DateFormat package
                        DateFormat.yMMMd().format(userTransactions[index].date),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
