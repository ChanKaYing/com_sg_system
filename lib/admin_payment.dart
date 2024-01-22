import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(AdminPaymentPage());
}

class AdminPaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firestore Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: UserPaymentPage(),
    );
  }
}

class UserPaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Payment Detail'),
      ),
      body: UserPaymentList(),
    );
  }
}

class UserPaymentList extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
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

        var users = snapshot.data?.docs;
        return ListView.builder(
          itemCount: users?.length,
          itemBuilder: (context, index) {
            var user = users![index];
            var uid = user['uid'].toString(); // Convert uid to a string

            return ListTile(
              title: Text(uid), // Using the uid as the title
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentDetailsPage(uid: user.id),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class PaymentDetailsPage extends StatelessWidget {
  final String uid;

  PaymentDetailsPage({required this.uid});

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
                keyboardType: TextInputType.numberWithOptions(decimal: true), // Allow decimal input
                onChanged: (value) {
                  try {
                    amount = double.parse(value);
                  } catch (e) {
                    // Handle parsing error here if necessary
                    print('Error parsing amount: $e');
                  }
                },
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

  void editPaymentDetail(BuildContext context, String paymentId,
      String initialName, double initialAmount, String initialMethod) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = initialName;
        double amount = initialAmount;
        String method = initialMethod;

        return AlertDialog(
          title: Text('Edit Payment Detail'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) => name = value,
                controller: TextEditingController(text: initialName),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount: RM'),
                keyboardType:
                TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  try {
                    amount = double.parse(value);
                  } catch (e) {
                    print('Error parsing amount: $e');
                  }
                },
                controller:
                TextEditingController(text: initialAmount.toString()),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Method'),
                onChanged: (value) => method = value,
                controller: TextEditingController(text: initialMethod),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('payments')
                      .doc(paymentId)
                      .update({
                    'name': name,
                    'amount': amount,
                    'method': method,
                  });

                  Navigator.of(context).pop();
                },
                child: Text('Save Changes'),
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
              return GestureDetector(
                onTap: () {
                  // Fetch initial values for editing
                  String name = payment['name'];
                  double amount = payment['amount'];
                  String method = payment['method'];
                  String paymentId = payment.id;

                  // Call the editPaymentDetail function
                  editPaymentDetail(
                    context,
                    paymentId,
                    name,
                    amount,
                    method,
                  );
                },

                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(payment['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Amount: RM ${payment['amount']}'),
                            Text('Method: ${payment['method']}'),
                            Text('Time: ${payment['timestamp']}'),
                            SizedBox(height: 8,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => addPaymentDetail(context),
        child: Icon(Icons.add),
      ),
    );
  }
}