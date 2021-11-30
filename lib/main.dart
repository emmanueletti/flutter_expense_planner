import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import 'models/transaction.dart';

void main() {
  // System chrome allows the setting of application / systems wide settings for
  // the app. Such as removing landscape mode.
  // !IMPORTANT: Before setting systems things make sure to first call
  // WidgetsFlutterBinding.ensureInitialized()

  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        errorColor: Colors.red,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: const TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              button: const TextStyle(color: Colors.white),
            ),

        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: const TextStyle(
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

// Using mixin with "with" keyword
// mixins allow us to use aspects of another class without having to directly
// extend/inherit from it.
// This is useful is getting around limitation of only being able to extend/inherit
// from 1 class.

// in this case, WidgetsBindingObserver allows us to listen to overall app
// lifecyle - inactive, paused, resumed, suspending
class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  // Called whenever APP lifecycle changes. Important to call this in a State
  // object in order to handle disposing of this listener when widget is removed
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  dispose() {
    super.dispose();
  }

  bool _showChart = false;
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
        DateTime.now().subtract(const Duration(days: 7)),
      );
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime txDate) {
    final newTx = Transaction(
      // work around to get a unique id string
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: txDate,
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

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  // by convention, methods and fields in private state are themselves
  // made private
  void _openNewTransactionForm(BuildContext context, setUserTxState) {
    // showModalBottomSheet is a function built into flutter
    showModalBottomSheet(
      context: context,
      // bctx is a seperate context object from "context" passed to showmodal
      // bctx is automatically passed in by Flutter
      builder: (bctx) => NewTransaction(setUserTxState),
    );
  }

  // Moved into special widget builder functions for improved code readability
  // This functions help us build parts of widget tree but not so independent
  // enough to make them thier own widget files
  List<Widget> _buildLandscapeContent(
    MediaQueryData mediaQuery,
    ObstructingPreferredSizeWidget appBar,
    Widget txListWidget,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.headline6,
          ),
          // Certain widgets have an adaptive custom constructor which
          // will create platform specific versions of themselves (iOS
          // vs android)
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? SizedBox(
              // A width of double.infinity is a enum representation of a behind
              // the scenes number. "double.infinity" tells Flutter to give
              // the widget as much width as possible.
              width: double.infinity,
              child: Chart(_recentTransactions),
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.6,
            )
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
    MediaQueryData mediaQuery,
    ObstructingPreferredSizeWidget appBar,
    Widget txListWidget,
  ) {
    return [
      SizedBox(
        // A width of double.infinity is a enum representation of a behind
        // the scenes number. "double.infinity" tells Flutter to give
        // the widget as much width as possible.
        width: double.infinity,
        child: Chart(_recentTransactions),
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
      ),
      txListWidget,
    ];
  }

  @override
  // context is an object with ALOT of metadata about the widget and its position
  // in the widget tree. It is "passed" around automatically throughout the widget
  // tree
  Widget build(BuildContext context) {
    // Don't create the context object repeatedly. Potentially a performance hit
    // to do that. Instead store it in a variable and use it where needed
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    // Moved app bar into its own variable so that we have access to "preferredSize"
    // property for responsive sizing
    final appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text('Personal Expenses'),
            trailing: Row(
              // Main axis size set to min tells the Row or Column widget to
              // shrink to be only as large as its children need it to be
              mainAxisSize: MainAxisSize.min,
              children: [
                // IconButton is a material button and can't be used in a cupertino
                // environment. We have to make a custom icon button ourselves
                GestureDetector(
                  child: const Icon(CupertinoIcons.add),
                  onTap: () =>
                      _openNewTransactionForm(context, _addNewTransaction),
                )
              ],
            ),
          )
        : AppBar(
            title: const Text('Personal Expenses'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () =>
                    _openNewTransactionForm(context, _addNewTransaction),
              ),
            ],
          );

    final txListWidget = SizedBox(
      // MediaQuery.of(context).padding.top gives the height that the
      // system allocates for icons and such at the very top of the device
      height: (mediaQuery.size.height -
              (appBar as ObstructingPreferredSizeWidget).preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    // SafeArea is a widget built into flutter to make sure every thing is
    // rendered within the bounderies alloted by the device system
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Special syntax in new verison of Flutter
            // for using an if conditional inside of a list
            // this is similiar to Reacts {boolean ?? component} pattern of
            // only rendering a component if the first expression is truthy
            // with this special syntax DO NOT use curly braces
            if (isLandscape)
              ..._buildLandscapeContent(mediaQuery, appBar, txListWidget),
            if (!isLandscape)
              ..._buildPortraitContent(mediaQuery, appBar, txListWidget),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            // You can make any container WITH A DEFINED HEIGHT scrollable by making
            // its child a SingleChildScrollView.
            // Here we are making the entire app body scrollable, and the
            // SingleChildScrollView widget is getting its height from the scaffold
            // widget, which is a top level widget with a height equaling the
            // device's height
            // Making the whole app body scrollable can solve the problem of overflow
            // errors when the keyboard pops up
            body: pageBody,

            // both named arguements to Scaffold widget
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () =>
                        _openNewTransactionForm(context, _addNewTransaction),
                  ),
          );
  }
}
