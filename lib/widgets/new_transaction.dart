import 'package:flutter/material.dart';

class NewTransaction extends StatelessWidget {
  void Function(String, double) setUserTxState;
  // late String titleInput;
  // late String amountInput;

  // Controller technique allows for a stateless widget to have instance fields
  // that change without the widget being stateful. Rare use-case and presented
  // here as reference for future. Would normally just create a stateful widget
  // and use the controlled text input pattern like in React.
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  NewTransaction(this.setUserTxState, {Key? key}) : super(key: key);

  void handleButtonPress() {
    setUserTxState(titleController.text, double.parse(amountController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              // onChanged: (value) => titleInput = value,
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              // onChanged: (value) => amountInput = value,
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
