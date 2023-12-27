import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class UserPaymentDetailsPage extends StatelessWidget {
  final String uid;

  UserPaymentDetailsPage({required this.uid});

  void addPaymentDetail(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        double amount = 0.0;
        String method = '';
        DateTime now = DateTime.now();
        String timestamp = '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}:${now.second}' ;

        return AlertDialog(
          title: Text('Add Payment Detail'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount: RM'),
                keyboardType: TextInputType.number,
                onChanged: (value) => amount = double.parse(value),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Method'),
                onChanged: (value) => method = value,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('payments')
                      .add({
                    'name': name,
                    'amount': amount,
                    'method': method,
                    'timestamp': timestamp,
                  });

                  Navigator.of(context).pop();
                },
                child: Text('Add Payment'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Details'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('payments')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          var payments = snapshot.data?.docs;
          return ListView.builder(
            itemCount: payments?.length,
            itemBuilder: (context, index) {
              var payment = payments![index];
              return ListTile(
                  title: Text(payment['name']),
                  subtitle:
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Amount: RM ${payment['amount']}'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Method: ${payment['method']}'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Time: ${payment['timestamp']}'),
                        ),
                      ],
                    ),
                  )
              );
            },
          );
        },
      ),
    );
  }
}