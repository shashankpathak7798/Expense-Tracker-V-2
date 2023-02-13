import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewTransactionsScreen extends StatefulWidget {
  static const routeName = '/view-transactions';

  @override
  State<ViewTransactionsScreen> createState() => _ViewTransactionsScreenState();
}

class _ViewTransactionsScreenState extends State<ViewTransactionsScreen> {
  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final deleteTransaction = routeArgs!['deleteTransactionFn'];
    final user_id = routeArgs['user_id'];


    return Scaffold(
      appBar: AppBar(
        title: Text('All Transactions'),
      ),
      body: StreamBuilder(stream: FirebaseFirestore.instance.collection('users').doc(user_id).collection('transactions').orderBy("time", descending: true).snapshots(), builder: (ctx, streamSnapshot) {
        final documents =streamSnapshot.data?.docs;
        if(streamSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(itemBuilder: ((context, index) {
          Timestamp timeStamp = documents![index]['time'];
          DateTime dateTime = timeStamp.toDate();
          String date = DateFormat.yMd().format(dateTime);
          return Card(
            elevation: 4,
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: CircleAvatar(
                child: Text('\$${documents?[index]['amount']}'),
                radius: 30,
              ),
              title: Text(documents?[index]['title']),
              subtitle: Text('$date'),
              trailing: IconButton(icon: Icon(Icons.dangerous_outlined, size: 25, color: Theme.of(context).errorColor,), onPressed: () => deleteTransaction(documents[index].id),),
            ),
          );
        }), itemCount: documents?.length,);
      },),
    );
  }
}
