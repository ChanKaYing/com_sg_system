import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_core/firebase_core.dart';

class AdminAppointFacility extends StatefulWidget {
  @override
  _AdminAppointFacilityState createState() => _AdminAppointFacilityState();
}

class _AdminAppointFacilityState extends State<AdminAppointFacility> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Appoint Facility'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Registered Facility & Time',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                '- Gym Room',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Container(
                height: 300, // Example height constraint, adjust as needed
                child: DisplayAppointments(),
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                '- Swimming Pool',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Container(
                height: 300, // Example height constraint, adjust as needed
                child: DisplayAppointmentsPool(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DisplayAppointments extends StatefulWidget {


  @override
  _DisplayAppointmentsState createState() =>
      _DisplayAppointmentsState();
}

class _DisplayAppointmentsState extends State<DisplayAppointments> {


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  String dropdownvalue = 'Please choose a type of facility';

  // List of items in our dropdown menu
  var items = [
    'Please choose a type of facility',
    '- Gym Room',
    '- Swimming Pool',
  ];

  // Initial Selected Value
  String dropdownvaluepeople = 'Number of People';

  // List of items in our dropdown menu
  var numofpeople = [
    'Number of People',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('facility')
          .where('typefacility', isEqualTo: '- Gym Room')
          //         .orderBy('checkintime', descending: false)
          //         .startAfter()
          //         .limit(10)
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
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              void _deleteData() async {
                await FirebaseFirestore.instance
                    .collection('facility')
                    .doc(document.id)
                    .delete();
              }

              void _editData() {
                TextEditingController nameController =
                    TextEditingController(text: data['name']);
                TextEditingController peopleController =
                    TextEditingController(text: data['numpeople']);
                TextEditingController facilityController =
                    TextEditingController(text: data['typefacility']);
                DateTime selectedDate = DateTime.parse(data['checkindate']);
                TimeOfDay selectedTime = TimeOfDay(
                  hour: int.parse(data['checkintime'].split(':')[0]),
                  minute: int.parse(data['checkintime'].split(':')[1]),
                );
                String _numPeople = '';
                String _typeFacility = '';

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Edit Data'),
                      content: StatefulBuilder(builder: (BuildContext context,
                          void Function(void Function()) setState) {
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: nameController,
                                decoration: InputDecoration(
                                    labelText: 'Register Resident Name'),
                              ),

                              SizedBox(height: 16.0),

                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Type of Facility:',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    DropdownButton(
                                      // Initial Value
                                      value: dropdownvalue,

                                      // Down Arrow Icon
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      // Hint text shown when no item is selected
                                      hint: Text(
                                        'Please choose a type of facility',
                                      ),
                                      // Array list of items
                                      items: items.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                        );
                                      }).toList(),
                                      // After selecting the desired option,it will
                                      // change button value to selected value
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownvalue = newValue!;
                                          _typeFacility = newValue;
                                        });
                                      },
                                    ),
                                  ]),

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

                              SizedBox(
                                height: 16.0,
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Number of people:',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(
                                      width: 16.0,
                                    ),
                                    DropdownButton(
                                      // Initial Value
                                      value: dropdownvaluepeople,

                                      // Down Arrow Icon
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      // Hint text shown when no item is selected
                                      hint: Text('Number of People'),
                                      // Array list of items
                                      items:
                                          numofpeople.map((String numofpeople) {
                                        return DropdownMenuItem(
                                          value: numofpeople,
                                          child: Text(numofpeople),
                                        );
                                      }).toList(),
                                      // After selecting the desired option,it will
                                      // change button value to selected value
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownvaluepeople = newValue!;
                                          _numPeople = newValue;
                                        });
                                      },
                                    ),
                                  ]),
                            ],
                          ),
                        );
                      }),
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
                              'typefacility': facilityController.text,
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
                      Text(
                          'Check-in: ${_formatDate(DateTime.parse(data['checkindate']))} ${data['checkintime']}'),
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

class DisplayAppointmentsPool extends StatelessWidget {

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
          .where('typefacility', isEqualTo: '- Swimming Pool')
          //         .orderBy('checkintime', descending: false)
          //         .startAfter()
          //         .limit(10)
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
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              void _deleteData() async {
                await FirebaseFirestore.instance
                    .collection('facility')
                    .doc(document.id)
                    .delete();
              }

              void _editData() {
                TextEditingController nameController =
                    TextEditingController(text: data['name']);
                TextEditingController peopleController =
                    TextEditingController(text: data['numpeople']);
                TextEditingController facilityController =
                    TextEditingController(text: data['typefacility']);
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
                              decoration: InputDecoration(
                                  labelText: 'Register Resident Name'),
                            ),

                            SizedBox(height: 16.0),

                            TextField(
                              controller: peopleController,
                              decoration: InputDecoration(
                                  labelText: 'Number of People'),
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
                              'typefacility': facilityController.text,
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
                      Text(
                          'Check-in: ${_formatDate(DateTime.parse(data['checkindate']))} ${data['checkintime']}'),
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