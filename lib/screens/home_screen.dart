import 'package:expense_tracker_v2/screens/view_transactions_screen.dart';
import 'package:expense_tracker_v2/widgets/charts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/transaction_list.dart';
import '../models/transactions.dart';
import '../widgets/add_transaction.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Transactions> _userTransactions = [];
  bool _showChart = false;
  var routeArgs;

  void _addNewTransaction(String title, double amount, DateTime chosenTime) {
    if (title.isEmpty || amount <= 0 || chosenTime == null) {
      return;
    }

    final newTransaction = Transactions(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      dateTime: chosenTime,
    );

    setState(() {
      _userTransactions.add(newTransaction);
    });
    var collection = newTransaction.id;
    FirebaseFirestore.instance
        .collection('users')
        .doc('$routeArgs')
        .collection('transactions')
        .doc(collection)
        .set({
      'title': newTransaction.title,
      'amount': newTransaction.amount,
      'time': newTransaction.dateTime,
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: AddTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
      isDismissible: false,
    );
  }

  List<Transactions> get _recentTransactions {
    return _userTransactions.where((element) {
      return element.dateTime
          .isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _deleteTransaction(String id) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(routeArgs)
        .collection('transactions')
        .doc(id)
        .delete();
    _userTransactions.removeWhere((element) => element.id == id);
  }

  @override
  Widget build(BuildContext context) {
    routeArgs = ModalRoute.of(context)?.settings.arguments.toString();
    print(routeArgs);
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(ViewTransactionsScreen.routeName,
                  arguments: {
                    'deleteTransactionFn': _deleteTransaction,
                    'user_id': routeArgs,
                  },);
            },
            icon: Icon(Icons.view_list_outlined),
          ),
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Show Chart'),
                  Switch.adaptive(
                      value: _showChart,
                      onChanged: (val) => setState(() {
                            _showChart = val;
                          })),
                ],
              ),
            if (isLandscape && _showChart)
              Container(
                height: mediaQuery.size.height * 0.55,
                width: double.infinity,
                child: Charts(_recentTransactions),
              ),
            if (isLandscape && !_showChart)
              Container(
                margin: EdgeInsets.only(bottom: 10),
                height: mediaQuery.size.height * 0.7,
                width: double.infinity,
                child: TransactionList(_userTransactions, _deleteTransaction),
              ),
            if (!isLandscape)
              Container(
                height: mediaQuery.size.height * 0.3,
                width: double.infinity,
                child: Charts(_recentTransactions),
              ),
            if (!isLandscape)
              Container(
                margin: EdgeInsets.only(bottom: 10),
                height: mediaQuery.size.height * 0.7,
                width: double.infinity,
                child: TransactionList(routeArgs, _deleteTransaction),
              )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
