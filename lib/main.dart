import 'package:flutter/material.dart';
import 'widgets/user_transactions.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter App'),
      ),
      // You can make any widget scrollable as long as the
      // SingleChildScrollView
      // is the child of a container with a defined height
      // Here we are making the entire app body scrollable, and the
      // SingleChildScrollView widget is getting its height from the scaffold
      // widget, which is a top level widget with a height equaling the
      // device's height
      // Making the whole app body scrollable solves the problem of overflow
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
                child: Text('CHART!'),
              ),
              elevation: 5,
            ),
            UserTransactions(),
          ],
        ),
      ),
    );
  }
}
