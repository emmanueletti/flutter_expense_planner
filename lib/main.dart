import 'package:flutter/material.dart';
import 'package:flutter_expense_planner/widgets/new_transaction.dart';
import 'package:flutter_expense_planner/widgets/transaction_list.dart';
import 'models/transaction.dart';

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

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
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

  void _addNewTransaction(String txTitle, double txAmount) {
    final newTx = Transaction(
      // work around to get a unique id string
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: DateTime.now(),
    );

    // setState called inside a handler function _addNewTransaction . If
    // created outside, it will be a class method overriding the original
    // implementation vs. a functional useage of its implementation.
    // Final setState call at the end of _addNewTransaction triggers a
    // Flutter re-render
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startProcessAddingTransaction(BuildContext context, setUserTxState) {
    showModalBottomSheet(
      context: context,
      builder: (bctx) {
        return NewTransaction(setUserTxState);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // showModalBottomSheet is a function built into flutter
              showModalBottomSheet(
                context: context,
                builder: (bctx) => NewTransaction(_addNewTransaction),
              );
            },
          ),
        ],
      ),
      // You can make any container WITH A DEFINED HEIGHT scrollable by making
      // its child a SingleChildScrollView.
      // Here we are making the entire app body scrollable, and the
      // SingleChildScrollView widget is getting its height from the scaffold
      // widget, which is a top level widget with a height equaling the
      // device's height
      // Making the whole app body scrollable can solve the problem of overflow
      // errors when the keyboard pops up
      body: SingleChildScrollView(
        child: Column(
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
                // the scenes number. "double.infinity" tells Flutter to give
                // the widget as much width as possible.
                width: double.infinity,
                child: const Text('CHART!'),
              ),
              elevation: 5,
            ),
            TransactionList(_userTransactions),
          ],
        ),
      ),

      // both named arguements to body
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () =>
            _startProcessAddingTransaction(context, _addNewTransaction),
      ),
    );
  }
}
