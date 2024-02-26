import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FacilityAppointmentPage extends StatefulWidget {
  final String uid;

  FacilityAppointmentPage({required this.uid});

  @override
  _FacilityAppointmentPageState createState() =>
      _FacilityAppointmentPageState(uid: uid);
}

class _FacilityAppointmentPageState extends State<FacilityAppointmentPage> {
  final String uid;

  _FacilityAppointmentPageState({required this.uid});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _nameController = TextEditingController();
  DateTime _checkInDate = DateTime.now();
  TimeOfDay _checkInTime = TimeOfDay(
    hour: TimeOfDay.now().hour,
    minute: 0,
  );
  TimeOfDay _checkOutTime = TimeOfDay(
    hour: TimeOfDay.now().hour + 1,
    minute: 0,
  );

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
//      initialTime: _checkInTime,
      initialTime: TimeOfDay(
          hour: _checkInTime.hour,
          minute: 0), // Set initial time with minutes as zero
    );

    if (picked != null) {
      setState(() {
        if (picked.hour < _checkOutTime.hour) {
          _checkInTime = TimeOfDay(hour: picked.hour, minute: 0);
        } else {
          _checkInTime = TimeOfDay(hour: _checkOutTime.hour - 1, minute: 0);
        }
//        _checkInTime = picked;
      });
    }
  }

  Future<void> _selectTimeOut(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
//      initialTime: _checkInTime,
      initialTime: TimeOfDay(
          hour: _checkInTime.hour + 1,
          minute: 0), // Set initial time with minutes as zero
    );

    if (picked != null) {
      setState(() {
        if (picked.hour > _checkInTime.hour) {
          _checkOutTime = TimeOfDay(hour: picked.hour, minute: 0);
        } else {
          _checkOutTime = TimeOfDay(hour: _checkInTime.hour + 1, minute: 0);
          AlertDialog(); ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        }
//        _checkInTime = picked;
      });
    }
  }

  bool timeOverlap(DateTime OtherCI, DateTime OtherCO, DateTime BookingCI,
      DateTime BookingCO) {
    bool A = BookingCI.isAfter(OtherCI) && BookingCI.isBefore(OtherCO);
    bool B = BookingCO.isAfter(OtherCI) && BookingCO.isBefore(OtherCO);
    bool C = BookingCI.isBefore(OtherCI) && BookingCO.isAfter(OtherCO);
    bool D = BookingCI == OtherCI && BookingCO == OtherCO;

    if (A || B || C || D) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _submitData() async {
    QuerySnapshot querySnapshot = await _firestore.collection('facility').get();
    bool noBooking = false;
    int totalGymPPL = 0;
    int totalPoolPPL = 0;

    if (_typeFacility == 'Please choose a type of facility') {
      noBooking = true;
    }

    for (var doc in querySnapshot.docs) {
      var OtherCheckIn = doc['checkindate'] + " " + doc['checkintime'];
      var OtherCheckOut = doc['checkindate'] + " " + doc['checkouttime'];
      var OtherFacility = doc['typefacility'];
      var OtherNum = int.parse(doc['numpeople']);
      OtherCheckIn = DateTime.parse(OtherCheckIn);
      OtherCheckOut = DateTime.parse(OtherCheckOut);
      var BookingInTime = DateTime(_checkInDate.year, _checkInDate.month,
          _checkInDate.day, _checkInTime.hour, _checkInTime.minute);
      var BookingOutTime = DateTime(_checkInDate.year, _checkInDate.month,
          _checkInDate.day, _checkOutTime.hour, _checkOutTime.minute);
      print(OtherCheckIn);
      print(BookingInTime);
      if (OtherFacility == "- Gym Room" &&
          timeOverlap(
              OtherCheckIn, OtherCheckOut, BookingInTime, BookingOutTime)) {
        totalGymPPL = totalGymPPL + OtherNum;
      }
      if (OtherFacility == "- Swimming Pool" &&
          timeOverlap(
              OtherCheckIn, OtherCheckOut, BookingInTime, BookingOutTime)) {
        totalPoolPPL = totalPoolPPL + OtherNum;
      }
      if (OtherFacility == "- Badminton" &&
          timeOverlap(
              OtherCheckIn, OtherCheckOut, BookingInTime, BookingOutTime)) {
        print("BOOKED,Choose another time");

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(
                  'This time is BOOKED, please choose another time. Thank You'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );

        noBooking = true;
        break;
      }
    }
    print(totalGymPPL);

    if (_typeFacility == "- Gym Room" && totalGymPPL >= 10) {
      print("FULL,Choose another time");

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('FULL, please choose another time. Thank You'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      noBooking = true;
    }

    if (_typeFacility == "- Swimming Pool" && totalPoolPPL >= 50) {
      print("FULL,Choose another time");

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('FULL, please choose another time. Thank You'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      noBooking = true;
    }

    if (!noBooking) {
      if (_nameController.text.isEmpty ||
          _numPeople.isEmpty ||
          _typeFacility.isEmpty) {
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
        'checkouttime': _formatTime(_checkOutTime),
        'numpeople': _numPeople,
        'typefacility': _typeFacility,
        'uid': uid,
      };

      try {
        await firestore.collection('facility').add(userData);

        // Data added successfully
        print('Data added to Firestore!');
        print(uid);
      } catch (e) {
        // Handle errors
        print('Error adding data to Firestore: $e');
      }
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

  // Initial Selected Value
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Pre-Register for Facility'),
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
                  labelText: 'Register Resident Name',
                ),
              ),
              SizedBox(height: 20.0),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  'Type of Facility:',
                  style: TextStyle(fontSize: 16),
                ),
                DropdownButton(
                  // Initial Value
                  value: dropdownvalue,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),
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
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Booking Date:',
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
                          'Booking Time (in):',
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
              SizedBox(height: 20.0),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Booking Time (out):',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        '${_checkOutTime.format(context)}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () => _selectTimeOut(context),
                    child: Text('Select Time'),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
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
                      icon: const Icon(Icons.keyboard_arrow_down),
                      // Hint text shown when no item is selected
                      hint: Text('Number of People'),
                      // Array list of items
                      items: numofpeople.map((String numofpeople) {
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
                  ],
                ),
              ]),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _submitData,
                child: Text('Submit'),
              ),
              SizedBox(height: 32.0),
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
                child: DisplayAppointments(uid: uid),
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
                child: DisplayAppointmentsPool(uid: uid),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DisplayAppointments extends StatefulWidget {
  final String uid;

  DisplayAppointments({required this.uid});

  @override
  _DisplayAppointmentsState createState() =>
      _DisplayAppointmentsState(uid: uid);
}

class _DisplayAppointmentsState extends State<DisplayAppointments> {
  final String uid;

  _DisplayAppointmentsState({required this.uid});

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
                      Text(
                          'Check-out: ${_formatDate(DateTime.parse(data['checkindate']))} ${data['checkouttime']}'),

                      Text('Num of People: ${data['numpeople']}'),
                      Text('UID:  ${data['uid']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(
                        visible: data['uid'] == uid,
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Call the edit function when edit icon is pressed
                            _editData();
                          },
                        ),
                      ),
                      Visibility(
                        visible: data['uid'] == uid,
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Call the edit function when edit icon is pressed
                            _deleteData();
                          },
                        ),
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

class DisplayAppointmentsPool extends StatefulWidget {
  final String uid;

  DisplayAppointmentsPool({required this.uid});

  @override
  _DisplayAppointmentsStatePool createState() =>
      _DisplayAppointmentsStatePool(uid: uid);
}

class _DisplayAppointmentsStatePool extends State<DisplayAppointmentsPool> {
  final String uid;

  _DisplayAppointmentsStatePool({required this.uid});

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

                              SizedBox(height: 16.0),
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
                      Text(
                          'Check-out: ${_formatDate(DateTime.parse(data['checkindate']))} ${data['checkouttime']}'),

                      Text('Num of People: ${data['numpeople']}'),
                      Text('UID:  ${data['uid']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(
                        visible: data['uid'] == uid,
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Call the edit function when edit icon is pressed
                            _editData();
                          },
                        ),
                      ),
                      Visibility(
                        visible: data['uid'] == uid,
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Call the edit function when edit icon is pressed
                            _deleteData();
                          },
                        ),
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
