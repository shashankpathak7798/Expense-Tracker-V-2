import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../models/transactions.dart';

class TransactionList extends StatefulWidget {
  final user_id;
  final Function removeTransaction;

  TransactionList(this.user_id, this.removeTransaction);

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user_id)
          .collection('transactions')
          .orderBy("time", descending: true)
          .limit(10)
          .snapshots(),
      builder: (ctx, streamSnapshot) {
        final documents = streamSnapshot.data?.docs;
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemBuilder: ((context, index) {
            Timestamp timeStamp = documents![index]['time'];
            DateTime dateTime = timeStamp.toDate();
            String date = DateFormat.yMd().format(dateTime);
            return Card(
              elevation: 4,
              margin: EdgeInsets.all(10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColorLight,
                  child: Text('\$${documents?[index]['amount']}', style: TextStyle(color: Colors.white),),
                  radius: 30,
                ),
                title: Text(
                  documents?[index]['title'],
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  '$date',
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 16,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor,
                  ),
                  onPressed: () =>
                      widget.removeTransaction(documents[index].id),
                ),
              ),
            );
          }),
          itemCount: documents?.length,
        );
      },
    );
  }
}
