import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FacilityAppointmentPage extends StatefulWidget {
  final String uid;
  FacilityAppointmentPage({required this.uid});

  @override
  _FacilityAppointmentPageState createState() => _FacilityAppointmentPageState(uid: uid);
}

class _FacilityAppointmentPageState extends State<FacilityAppointmentPage> {
  final String uid;
  _FacilityAppointmentPageState({required this.uid});

  TextEditingController _nameController = TextEditingController();
  DateTime _checkInDate = DateTime.now();
  TimeOfDay _checkInTime = TimeOfDay.now();

  String _numPeople = '';
  String _typeFacility = '';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _checkInDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _checkInTime,
    );

    if (picked != null) {
      setState(() {
        _checkInTime = picked;
      });
    }
  }

  Future<void> _submitData() async {

    if (_nameController.text.isEmpty || _numPeople.isEmpty || _typeFacility.isEmpty) {
      // Notify the user if any required fields are empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Empty Fields'),
            content: Text('Please fill in all the required fields.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Stop execution if any field is empty
    }

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Map<String, dynamic> userData = {
      'name': _nameController.text,
      'checkindate': _formatDate(_checkInDate),
      'checkintime': _formatTime(_checkInTime),
      'numpeople': _numPeople,
      'typefacility' : _typeFacility,
      'uid':uid,

    };

    try {
      await firestore
          .collection('facility')
          .add(userData);

      // Data added successfully
      print('Data added to Firestore!');
      print(uid);
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
        title: Text('Pre-Register for Visitor'),
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
                  labelText: 'Visitor Name',
                ),
              ),

              SizedBox(height: 16.0),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Check-in Date:',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        '${_checkInDate.toLocal()}'.split(' ')[0],
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),

                  SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select Date'),
                  ),
                  SizedBox(width: 10.0),
                ]),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Check-in Time:',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          '${_checkInTime.format(context)}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),

                    SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: () => _selectTime(context),
                      child: Text('Select Time'),
                    ),
                  ],
                ),
              ]),
              SizedBox(height: 16.0),

              TextField(
                onChanged: (value) {
                  setState(() {
                    _typeFacility = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Type of Facility',
                ),
              ),

              TextField(
                onChanged: (value) {
                  setState(() {
                    _numPeople = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Number of People',
                ),
              ),

              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _submitData,
                child: Text('Submit'),
              ),
              SizedBox(height: 32.0),

              Text('Registered Facility & Time',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20.0),
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
          .collection('facility')
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

              void _deleteData() async {
                await FirebaseFirestore.instance
                    .collection('facility')
                    .doc(document.id)
                    .delete();
              }

              void _editData() {
                TextEditingController nameController = TextEditingController(text: data['name']);
                TextEditingController peopleController = TextEditingController(text: data['numpeople']);
                DateTime selectedDate = DateTime.parse(data['checkindate']);
                TimeOfDay selectedTime = TimeOfDay(
                  hour: int.parse(data['checkintime'].split(':')[0]),
                  minute: int.parse(data['checkintime'].split(':')[1]),
                );

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Edit Data'),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: nameController,
                              decoration:
                                  InputDecoration(labelText: 'User Name'),
                            ),

                            SizedBox(height: 16.0),

                            TextField(
                              controller: peopleController,
                              decoration: InputDecoration(
                                  labelText: 'Number of people'),
                            ),
                            SizedBox(height: 16.0),

                            TextField(
                              controller: peopleController,
                              decoration: InputDecoration(
                                  labelText: 'Type of Facility'),
                            ),
                            SizedBox(height: 16.0),

//////////////////////////////////////////////////////////////////////////////////
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Selected Date: '),
                                        Text('${_formatDate(selectedDate)}'),
                                        SizedBox(width: 10.0),
                                      ]),

//////////////////////////////////////////////////////////////////////////////////
                                  Spacer(),

                                  TextButton(
                                    onPressed: () async {
                                      final DateTime? picked =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: selectedDate,
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2101),
                                      );
                                      if (picked != null) {
                                        selectedDate = picked;
                                      }
                                    },
                                    child: Text('Select Date'),
                                  ),
                                ]),
                              ],
                            ),
                            SizedBox(height: 16.0),

//////////////////////////////////////////////////////////////////////////////////
                            Row(
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Selected Time: '),
                                      Text('${selectedTime.format(context)}'),
                                      SizedBox(width: 10.0),
                                    ]),
///////////////////////////////////////////////////////////////////////////////////////////////
                                Spacer(),
                                TextButton(
                                  onPressed: () async {
                                    final TimeOfDay? picked =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: selectedTime,
                                    );
                                    if (picked != null) {
                                      selectedTime = picked;
                                    }
                                  },
                                  child: Text('Select Time'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            // Update data in Firestore
                            await FirebaseFirestore.instance
                                .collection('facility')
                                .doc(document.id)
                                .update({
                              'name': nameController.text,
                              'numpeople': peopleController.text,
                              'checkindate': _formatDate(selectedDate),
                              'checkintime': _formatTime(selectedTime),

                            });
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              }

              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Name: ${data['name']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Check-in: ${_formatDate(DateTime.parse(data['checkindate']))} ${data['checkintime']}'),
                      Text('Num of People: ${data['numpeople']}'),
                      Text('UID:  ${data['uid']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Call the edit function when edit icon is pressed
                          _editData();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Call the delete function when delete icon is pressed
                          _deleteData();
                        },
                      ),
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