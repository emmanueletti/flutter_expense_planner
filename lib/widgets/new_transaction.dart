import 'package:flutter/material.dart';

class NewTransaction extends StatelessWidget {
  NewTransaction(this.setUserTxState, {Key? key}) : super(key: key);
  void Function(String, double) setUserTxState;
  final amountController = TextEditingController();
  // Controller technique allows for a stateless widget to have instance fields
  // that change without the widget being stateful.
  final titleController = TextEditingController();
  void handleButtonPress() {
    setUserTxState(titleController.text, double.parse(amountController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      // Could probably also have put in a Container or SizedBox widget.
      // They have an argument for padding.
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
            FlatButton(
              onPressed: handleButtonPress,
              textColor: Colors.purple,
              child: Text('Add Transaction'),
            )
          ],
        ),
      ),
    );
  }
}
