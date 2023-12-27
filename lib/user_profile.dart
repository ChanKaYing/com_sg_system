import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfilePage extends StatefulWidget {
  final String uid;

  UserProfilePage({required this.uid});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();

    fetchUserData();
  }

  Future<void> fetchUserData() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();

    if (snapshot.exists) {
      setState(() {
        _nameController.text = snapshot.data()!['name'] ?? 'Your Name';
        _addressController.text = snapshot.data()!['address'] ?? 'Your Address';
        _emailController.text = snapshot.data()!['email'] ?? 'youremail@example.com';
        _phoneController.text = snapshot.data()!['phone'] ?? '+1234567890';
      });
    }
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildEditableField('Name', _nameController),
                _buildEditableField('Address', _addressController),
                _buildEditableField('Email', _emailController),
                _buildEditableField('Phone', _phoneController),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                _updateUserDataInFirestore();
                _updateProfileData(); // Update the profile data on the page
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }

  Future<void> _updateUserDataInFirestore() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
        'name': _nameController.text,
        'address': _addressController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated')));
    } catch (e) {
      print('Error updating data: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile')));
    }
  }

  void _updateProfileData() {
    setState(() {
      _nameController.text = _nameController.text;
      _addressController.text = _addressController.text;
      _emailController.text = _emailController.text;
      _phoneController.text = _phoneController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            _buildNonEditableField('Name', _nameController, Icons.person),
            SizedBox(height: 16.0),

            _buildNonEditableField('Address', _addressController, Icons.location_on),
            SizedBox(height: 16.0),

            _buildNonEditableField('Email', _emailController, Icons.email),
            SizedBox(height: 16.0),

            _buildNonEditableField("Phone", _phoneController, Icons.phone),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showEditDialog();
              },
              child: Text('Edit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNonEditableField(String label, TextEditingController controller, IconData icon) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        enabled: false,
        border: OutlineInputBorder(),
      ),
      child: Text(
        controller.text,
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
