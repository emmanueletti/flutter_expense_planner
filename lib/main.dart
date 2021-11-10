import 'package:flutter/material.dart';
import 'package:flutter_expense_planner/widgets/chart.dart';
import 'package:flutter_expense_planner/widgets/new_transaction.dart';
import 'package:flutter_expense_planner/widgets/transaction_list.dart';
import 'models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      home: MyHomePage(),
      // theme configures colors and fonts and other values for the app
      // can directly access these set global values anywhere throughout the app
      // using the context object
      theme: ThemeData(
        // primary swatch with automatically pull out the different shades
        // of the primary color for the app widgets to access
        primarySwatch: Colors.purple,
        // no swatch setting for accent color
        accentColor: Colors.amber,
        // font name needs to match exactly as that in pubspec
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: const TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
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

  List<Transaction> get _recentTransactions {
    // Darts filter function
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

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

  // by convention, methods and fields in private state are themselves
  // made private
  void _openNewTransactionForm(BuildContext context, setUserTxState) {
    // showModalBottomSheet is a function built into flutter
    showModalBottomSheet(
      context: context,
      builder: (bctx) => NewTransaction(setUserTxState),
    );
  }

  @override
  // context is an object with ALOT of metadata about the widget and its position
  // in the widget tree. It is "passed" around automatically throughout the widget
  // tree
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Expenses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                _openNewTransactionForm(context, _addNewTransaction),
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
            SizedBox(
              // A width of double.infinity is a enum representation of a behind
              // the scenes number. "double.infinity" tells Flutter to give
              // the widget as much width as possible.
              width: double.infinity,
              child: Chart(_recentTransactions),
            ),
            TransactionList(_userTransactions),
          ],
        ),
      ),

      // both named arguements to Scaffold widget
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _openNewTransactionForm(context, _addNewTransaction),
      ),
    );
  }
}
