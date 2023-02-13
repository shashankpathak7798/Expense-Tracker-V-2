import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTransaction extends StatefulWidget {
  final Function _addTransaction;

  AddTransaction(this._addTransaction);

  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate = null;

  void _submitData() {
    final transactionTitle = _titleController.text;
    final transactionAmount = double.parse(_amountController.text);

    if (transactionTitle.isEmpty || transactionAmount <= 0 || _selectedDate == null) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error Occured'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    widget._addTransaction(transactionTitle, transactionAmount, _selectedDate);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Card(
          elevation: 5,
          child: Container(
//            height: MediaQuery.of(context).size.height * 0.5,
            padding: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: MediaQuery.of(context).viewInsets.bottom + 10,),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                  controller: _titleController,
                  onSubmitted: (_) => _submitData,
                ),
                SizedBox(
                  height: 4,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Amount'),
                  // onChanged: (value) => amountInput = value,
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => _submitData,
                ),
                Container(
                  height: 70,
                  child: Row(
                    children: [
                      Expanded(child: Text(_selectedDate == null ? 'No date chosen' : 'Picked Date: ${DateFormat.yMd().format(_selectedDate!)}')),
                      TextButton(onPressed: () {
                        showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2022), lastDate: DateTime.now(),).then((value) {
                          if(value == null) {
                            return;
                          }
                          setState(() {
                            _selectedDate = value;
                          });
                        });
                      }, child: Text('Pick a date'),),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: _submitData,
                  child: Text('Add'),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
