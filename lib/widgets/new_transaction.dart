import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  NewTransaction(this.setUserTxState, {Key? key}) : super(key: key);

  void Function(String, double, DateTime) setUserTxState;

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  DateTime? _selectedDate;

  // make methods in private classes private
  void _submitData() {
    // basic validation
    if (_amountController.text.isEmpty) {
      return;
    }

    final enteredTitle = _titleController.text;

    // basic validation
    final enteredAmount = double.parse(_amountController.text);
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    // "widget" property allows access to properties and methods of Widget
    // class inside of State class. Only accessible inside State classes
    widget.setUserTxState(enteredTitle, enteredAmount, _selectedDate!);

    Navigator.of(context).pop();
  }

  void _showDatePicker() {
    // Function built into flutter
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      // User pressed cancel
      if (pickedDate == null) {
        return;
      }
      // Set state is a trigger to tell flutter that a property / state has
      // changed and build should be run again.
      // If property / state is changed without setstate being called - it will
      // still change behind the scenes but the widget will not be re-rendered
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        // Could probably also have put in a Container or SizedBox widget.
        // They have an argument for padding.
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                controller: _titleController,
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
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                controller: _amountController,
                keyboardType:
                    // requests the numbers keyboard to show
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Amount'),
              ),
              SizedBox(
                height: 70,
                child: Row(
                  children: [
                    // REMEMBER: Flexible and Expanded widget are like CSS flexbox
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Chosen'
                            : 'Picked Date: ${DateFormat.yMd().format(_selectedDate as DateTime)}',
                      ),
                    ),
                    Platform.isIOS
                        ? CupertinoButton(
                            child: const Text(
                              'Choose Date',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onPressed: _showDatePicker)
                        : FlatButton(
                            textColor: Theme.of(context).primaryColor,
                            onPressed: _showDatePicker,
                            child: const Text(
                              'Choose Date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                  ],
                ),
              ),
              Platform.isIOS
                  ? CupertinoButton(
                      child: const Text(
                        'Add Transaction',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      color: Theme.of(context).primaryColor,
                      onPressed: _submitData)
                  : RaisedButton(
                      onPressed: _submitData,
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).textTheme.button?.color,
                      child: const Text(
                        'Add Transaction',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
