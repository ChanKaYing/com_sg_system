import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAppointmentPage extends StatefulWidget {
  final String uid;
  UserAppointmentPage({required this.uid});

  @override
  _UserAppointmentPageState createState() => _UserAppointmentPageState(uid: uid);
}

class _UserAppointmentPageState extends State<UserAppointmentPage> {
  final String uid;
  _UserAppointmentPageState({required this.uid});

  TextEditingController _nameController = TextEditingController();
  DateTime _checkInDate = DateTime.now();
  TimeOfDay _checkInTime = TimeOfDay.now();
  DateTime _checkOutDate = DateTime.now();
  TimeOfDay _checkOutTime = TimeOfDay.now();
  String _address = '';
  String _licensePlate = '';


  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    DateTime initialDate = isCheckIn ? _checkInDate : _checkOutDate;
    initialDate = initialDate.isBefore(DateTime.now()) ? DateTime.now() : initialDate;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: isCheckIn ? DateTime.now() : _checkInDate, // Set the minimum selectable date
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
          // Ensure checkout date is after check-in date
          if (_checkOutDate.isBefore(_checkInDate)) {
            _checkOutDate = _checkInDate.add(Duration(days: 1)); // Set checkout date to the next day by default
          }
        } else {
          // Check if selected checkout date is before check-in date, if so, set it to check-in date
          if (picked.isBefore(_checkInDate)) {
            _checkOutDate = _checkInDate.add(Duration(days: 1)); // Set checkout date to the next day by default
          } else {
            _checkOutDate = picked;
          }
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isCheckIn) async {
    final TimeOfDay now = TimeOfDay.now();

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isCheckIn ? _checkInTime : _checkOutTime,
    );

    if (picked != null) {
      final DateTime currentTime = DateTime.now();
      final DateTime selectedTime = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        picked.hour,
        picked.minute,
      );

      setState(() {
        if (isCheckIn) {
          _checkInTime = picked;
          if (selectedTime.isBefore(currentTime)) {
            // If selected time is before current time, adjust date
            _checkInDate = currentTime.add(Duration(days: 1));
          }
        } else {
          _checkOutTime = picked;
          if (selectedTime.isBefore(currentTime)) {
            // If selected time is before current time, adjust date
            _checkOutDate = currentTime.add(Duration(days: 1));
          }
        }
      });
    }
  }




  Future<void> _submitData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Map<String, dynamic> userData = {
      'name': _nameController.text,
      'checkindate': _formatDate(_checkInDate),
      'checkintime': _formatTime(_checkInTime),
      'checkoutdate': _formatDate(_checkOutDate),
      'checkouttime': _formatTime(_checkOutTime),
      'address': _address,
      'plate': _licensePlate,

    };

    try {
      await firestore
          .collection('users')
          .doc(uid) // Replace 'uid' with the actual user ID
          .collection('carregister')
          .add(userData);

      // Data added successfully
      print('Data added to Firestore!');
    } catch (e) {
      // Handle errors
      print('Error adding data to Firestore: $e');
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}';
  }

  String _formatTime(TimeOfDay time) {
    return '${_twoDigits(time.hour)}:${_twoDigits(time.minute)}';
  }

  String _twoDigits(int n) {
    if (n >= 10) {
      return '$n';
    }
    return '0$n';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pre-Register Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Your Name',
                ),
              ),
              SizedBox(height: 16.0),

              Text('Check-in Date:'),
              Row(
                children: [
                  Text(
                    '${_checkInDate.toLocal()}'.split(' ')[0],
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () => _selectDate(context, true),
                    child: Text('Select Date'),
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    '${_checkInTime.format(context)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () => _selectTime(context, true),
                    child: Text('Select Time'),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Text('Check-out Date:'),
              Row(
                children: [
                  Text(
                    '${_checkOutDate.toLocal()}'.split(' ')[0],
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () => _selectDate(context, false),
                    child: Text('Select Date'),
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    '${_checkOutTime.format(context)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () => _selectTime(context, false),
                    child: Text('Select Time'),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _address = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Address',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _licensePlate = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Car License Plate',
                ),
              ),
              SizedBox(height: 32.0),

              ElevatedButton(
                onPressed: _submitData,
                child: Text('Submit'),
              ),

              SizedBox(height: 32.0),

              Container(
                height: 300, // Example height constraint, adjust as needed
                child: DisplayAppointments(uid: uid),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class DisplayAppointments extends StatelessWidget {
  final String uid;

  DisplayAppointments({required this.uid});

  String _formatDate(DateTime date) {
    return '${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}';
  }

  String _formatTime(TimeOfDay time) {
    return '${_twoDigits(time.hour)}:${_twoDigits(time.minute)}';
  }

  String _twoDigits(int n) {
    if (n >= 10) {
      return '$n';
    }
    return '0$n';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('carregister')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Container(
          height: 300,
          child: ListView(
            children: snapshot.data!.docs.map((document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Name: ${data['name']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Check-in: ${_formatDate(DateTime.parse(data['checkindate']))} ${data['checkintime']}'),
                      Text('Check-out: ${_formatDate(DateTime.parse(data['checkoutdate']))} ${data['checkouttime']}'),
                      Text('Address: ${data['address']}'),
                      Text('License Plate: ${data['plate']}'),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}