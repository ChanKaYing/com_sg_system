import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  TextEditingController _nameController = TextEditingController();
  DateTime _checkInDate = DateTime.now();
  TimeOfDay _checkInTime = TimeOfDay.now();
  DateTime _checkOutDate = DateTime.now();
  TimeOfDay _checkOutTime = TimeOfDay.now();
  String _address = '';
  String _licensePlate = '';

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? _checkInDate : _checkOutDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
        } else {
          _checkOutDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isCheckIn) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isCheckIn ? _checkInTime : _checkOutTime,
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInTime = picked;
        } else {
          _checkOutTime = picked;
        }
      });
    }
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
                onPressed: () {
                  // Process the appointment details (e.g., send to server)
                  print('Name: ${_nameController.text}');
                  print('Check-in Date: $_checkInDate');
                  print('Check-in Time: $_checkInTime');
                  print('Check-out Date: $_checkOutDate');
                  print('Check-out Time: $_checkOutTime');
                  print('Address: $_address');
                  print('License Plate: $_licensePlate');
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: AppointmentPage()));