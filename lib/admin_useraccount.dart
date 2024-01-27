import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: UsersAccountPage(),
  ));
}

class UsersAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users Account'),
      ),
      body: Column(
        children: [
          Expanded(
            child: UsersAccountTable(),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterPage(),
                ),
              );
            },
            child: Text('Register New Account'),
          ),
        ],
      ),
    );
  }
}

class UsersAccountTable extends StatefulWidget {
  @override
  _UsersAccountTableState createState() => _UsersAccountTableState();
}

class _UsersAccountTableState extends State<UsersAccountTable> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController memberController = TextEditingController();
  bool _isMember = false;



  void _saveUserData(BuildContext context, DocumentSnapshot user) {
    FirebaseFirestore.instance.collection('users').doc(user.id).update({
      'name': nameController.text,
      'address': addressController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'phone': phoneController.text,
      'member': memberController.text,

    }).then((_) {
      Navigator.pop(context);
    }).catchError((error) {
      print('Error: $error');
    });
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .orderBy('uid', descending: false)
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

        var users = snapshot.data?.docs;

        users?.sort((a, b) => a['uid'].compareTo(b['uid']));

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('UID')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Address')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Password')),
                DataColumn(label: Text('Phone')),
                DataColumn(label: Text('Member')),
              ],

              rows: users!.map<DataRow>((user) {
                return DataRow(
                  cells: [
                    DataCell(InkWell(
                      onTap: () {
                        nameController.text = user['name'];
                        addressController.text = user['address'];
                        emailController.text = user['email'];
                        passwordController.text = user['password'];
                        phoneController.text = user['phone'];
                        memberController.text = user['member'];

                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text('Edit User'),
                            content:

                            StatefulBuilder(builder:(BuildContext context,void Function(void Function()) setState) {

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(labelText: 'Name'),
                                ),
                                TextField(
                                  controller: addressController,
                                  decoration: InputDecoration(labelText: 'Address'),
                                ),
                                TextField(
                                  controller: emailController,
                                  decoration: InputDecoration(labelText: 'Email'),
                                ),
                                TextField(
                                  controller: passwordController,
                                  decoration: InputDecoration(labelText: 'Password'),
                                ),
                                TextField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(labelText: 'Phone'),
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                      children: [
                                        Text('Member'),
                                        Checkbox(
                                          value: memberController.text == '1',
                                          onChanged: (value) {
                                            setState(() {
                                              memberController.text = value! ? '1' : '0';
                                              print(_isMember);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  _saveUserData(context, user);
                                },
                                child: Text('Save'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text(user['uid'].toString()),
                    )),


                    DataCell(InkWell(
                      onTap: () {
                        nameController.text = user['name'];
                        addressController.text = user['address'];
                        emailController.text = user['email'];
                        passwordController.text = user['password'];
                        phoneController.text = user['phone'];
                        memberController.text = user['member'];

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Edit User'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(labelText: 'Name'),
                                ),
                                TextField(
                                  controller: addressController,
                                  decoration: InputDecoration(labelText: 'Address'),
                                ),
                                TextField(
                                  controller: emailController,
                                  decoration: InputDecoration(labelText: 'Email'),
                                ),
                                TextField(
                                  controller: passwordController,
                                  decoration: InputDecoration(labelText: 'Password'),
                                ),
                                TextField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(labelText: 'Phone'),
                                ),
                                Row(
                                  children: [
                                    Text(user['member']),
                                    Checkbox(
                                      value: user['member'] == '1',
                                      onChanged: null,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  _saveUserData(context, user);
                                },
                                child: Text('Save'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text(user['name']),
                    )),


                    DataCell(InkWell(
                      onTap: () {
                        nameController.text = user['name'];
                        addressController.text = user['address'];
                        emailController.text = user['email'];
                        passwordController.text = user['password'];
                        phoneController.text = user['phone'];
                        memberController.text = user['member'];


                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Edit User'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(labelText: 'Name'),
                                ),
                                TextField(
                                  controller: addressController,
                                  decoration: InputDecoration(labelText: 'Address'),
                                ),
                                TextField(
                                  controller: emailController,
                                  decoration: InputDecoration(labelText: 'Email'),
                                ),
                                TextField(
                                  controller: passwordController,
                                  decoration: InputDecoration(labelText: 'Password'),
                                ),
                                TextField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(labelText: 'Phone'),
                                ),
                                Row(
                                  children: [
                                    Text('Member'),
                                    Checkbox(
                                      value: memberController.text == '1',
                                      onChanged: (value) {
                                        Navigator.of(context).pop();
                                        _saveUserData(context, user);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  _saveUserData(context, user);
                                },
                                child: Text('Save'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text(user['address']),
                    )),


                    DataCell(InkWell(
                      onTap: () {
                        nameController.text = user['name'];
                        addressController.text = user['address'];
                        emailController.text = user['email'];
                        passwordController.text = user['password'];
                        phoneController.text = user['phone'];
                        memberController.text = user['member'];

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Edit User'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(labelText: 'Name'),
                                ),
                                TextField(
                                  controller: addressController,
                                  decoration: InputDecoration(labelText: 'Address'),
                                ),
                                TextField(
                                  controller: emailController,
                                  decoration: InputDecoration(labelText: 'Email'),
                                ),
                                TextField(
                                  controller: passwordController,
                                  decoration: InputDecoration(labelText: 'Password'),
                                ),
                                TextField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(labelText: 'Phone'),
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  children: [
                                    Text('Member'),
                                    Checkbox(
                                      value: memberController.text == '1',
                                      onChanged: (value) {
                                        Navigator.of(context).pop();
                                        _saveUserData(context, user);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  _saveUserData(context, user);
                                },
                                child: Text('Save'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text(user['email']),
                    )),


                    DataCell(InkWell(
                      onTap: () {
                        nameController.text = user['name'];
                        addressController.text = user['address'];
                        emailController.text = user['email'];
                        passwordController.text = user['password'];
                        phoneController.text = user['phone'];
                        memberController.text = user['member'];

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Edit User'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(labelText: 'Name'),
                                ),
                                TextField(
                                  controller: addressController,
                                  decoration: InputDecoration(labelText: 'Address'),
                                ),
                                TextField(
                                  controller: emailController,
                                  decoration: InputDecoration(labelText: 'Email'),
                                ),
                                TextField(
                                  controller: passwordController,
                                  decoration: InputDecoration(labelText: 'Password'),
                                ),
                                TextField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(labelText: 'Phone'),
                                ),
                                Row(
                                  children: [
                                    Text('Member'),
                                    Checkbox(
                                      value: memberController.text == '1',
                                      onChanged: (value) {
                                        Navigator.of(context).pop();
                                        _saveUserData(context, user);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  _saveUserData(context, user);
                                },
                                child: Text('Save'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text(user['password']),
                    )),


                    DataCell(InkWell(
                      onTap: () {
                        nameController.text = user['name'];
                        addressController.text = user['address'];
                        emailController.text = user['email'];
                        passwordController.text = user['password'];
                        phoneController.text = user['phone'];
                        memberController.text = user['member'];

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Edit User'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(labelText: 'Name'),
                                ),
                                TextField(
                                  controller: addressController,
                                  decoration: InputDecoration(labelText: 'Address'),
                                ),
                                TextField(
                                  controller: emailController,
                                  decoration: InputDecoration(labelText: 'Email'),
                                ),
                                TextField(
                                  controller: passwordController,
                                  decoration: InputDecoration(labelText: 'Password'),
                                ),
                                TextField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(labelText: 'Phone'),
                                ),
                                Row(
                                  children: [
                                    Text('Member'),
                                    Checkbox(
                                      value: memberController.text == '1',
                                      onChanged: (value) {
                                        Navigator.of(context).pop();
                                        _saveUserData(context, user);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  _saveUserData(context, user);
                                },
                                child: Text('Save'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text(user['phone']),
                    )),


                    DataCell(InkWell(
                      onTap: () {
                        nameController.text = user['name'];
                        addressController.text = user['address'];
                        emailController.text = user['email'];
                        passwordController.text = user['password'];
                        phoneController.text = user['phone'];
                        memberController.text = user['member'];

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Edit User'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(labelText: 'Name'),
                                ),
                                TextField(
                                  controller: addressController,
                                  decoration: InputDecoration(labelText: 'Address'),
                                ),
                                TextField(
                                  controller: emailController,
                                  decoration: InputDecoration(labelText: 'Email'),
                                ),
                                TextField(
                                  controller: passwordController,
                                  decoration: InputDecoration(labelText: 'Password'),
                                ),
                                TextField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(labelText: 'Phone'),
                                ),
                                SizedBox(height: 16.0),
                                Row(
                                  children: [
                                    Text('Member'),
                                    Checkbox(
                                      value: _isMember,
                                      onChanged: (value) {
                                        setState(() {
                                          print(value);
                                          _isMember = value!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  _saveUserData(context, user);
                                },
                                child: Text('Save'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text(user['member'] == '1'? "YES":"NO"),
                    )),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _uidController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
//  TextEditingController _memberController = TextEditingController();
  bool _isMember = false;

  bool _isPasswordVisible = false;

  void _registerUser() async {
    int? uid = int.tryParse(_uidController.text);
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String address = _addressController.text;
    String phone = _phoneController.text;
//    String member = _memberController.text;
    String member = _isMember ? '1' : '0';

    if (uid == null ||
        name.isEmpty ||
//        email.isEmpty ||
        password.isEmpty ||
        address.isEmpty ||
        member.isEmpty
//    ||
//        phone.isEmpty
        ) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'Please fill in all fields and ensure UID is a valid integer.'),
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
    } else {
      try {
        CollectionReference users =
        FirebaseFirestore.instance.collection('users');
        await users.doc(uid.toString()).set({
          'uid': uid,
          'name': name,
          'email': email,
          'password': password,
          'address': address,
          'phone': phone,
          'member' : member,
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('User registered successfully.'),
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
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('An error occurred while registering user.'),
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
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 200.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/apartment.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Card(
                  color: Colors.white.withOpacity(0.8),
                  elevation: 8.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Create an Account',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Enter resident simple details to register.',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[60],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _uidController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'UID',
                  prefixIcon: Icon(Icons.account_circle),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    child: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Text('Member'),
                  Checkbox(
                    value: _isMember,
                    onChanged: (value) {
                      setState(() {
                        _isMember = value!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _registerUser,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
