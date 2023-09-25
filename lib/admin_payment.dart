import 'package:flutter/material.dart';

void main() {
  runApp(AdminPayment());
}

class AdminPayment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
              backgroundColor:Colors.pink,
              title: Text('Payment Detail')

          ),
          body:Center(
            child: Image.asset('images/table1.png'),
          )
      ),
    );
  }
}