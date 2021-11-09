import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  NewTransaction(this.setUserTxState, {Key? key}) : super(key: key);
  void Function(String, double) setUserTxState;

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final amountController = TextEditingController();
  final titleController = TextEditingController();

  void submitData() {
    final enteredTitle = titleController.text;
    // basic validation
    final enteredAmount = double.parse(amountController.text);
    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }
    // "widget" property allows access to properties and methods of Widget
    // class inside of State class. Only accessible inside State classes
    widget.setUserTxState(enteredTitle, enteredAmount);

    Navigator.of(context).pop();
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
              decoration: const InputDecoration(labelText: 'Title'),

              // (_) is a convention to signal that the function recieves an
              // arguement, but we don't care about it. We just need a placeholder
              // to accept it, but we don't plan on using it.
              // To get around the requirements of onSubmitted without changing
              // the submitData type, we wrap the function we want to call
              // in an anonymous handler that we can make specific to onSubmitted's
              // requirements.
              // onsubmitted wants a function of type void Function(String)?
              // while flat button's onpressed wants a function of type
              // void Function()
              onSubmitted: (_) => submitData(),
            ),
            TextField(
              controller: amountController,
              keyboardType:
                  // requests the numbers keyboard to show
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            FlatButton(
              onPressed: submitData,
              textColor: Colors.purple,
              child: const Text('Add Transaction'),
            )
          ],
        ),
      ),
    );
  }
}
