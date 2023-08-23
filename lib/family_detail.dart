import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Authentication

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FamilyPage());
}

class FamilyMember {
  String name;
  String role;
  String age;

  FamilyMember({
    required this.name,
    required this.role,
    required this.age,
  });
}

class FamilyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Family Detail Page',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FamilyDetailPage(),
    );
  }
}

class FamilyDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser; // Get the authenticated user
    final userUID = user?.uid; // Get the UID of the authenticated user

    return Scaffold(
      appBar: AppBar(title: Text('Family Detail')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('familyMembers')
            .where('userUID', isEqualTo: userUID) // Filter by the current user's UID
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          final familyMembers = (snapshot.data?.docs ?? []).map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return FamilyMember(
              name: data['name'] ?? '',
              role: data['role'] ?? '',
              age: data['age'] ?? '',
            );
          }).toList();
          return ListView.builder(
            itemCount: familyMembers.length,
            itemBuilder: (context, index) {
              final member = familyMembers[index];
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditFamilyMemberPage(
                        familyMember: member,
                      ),
                    ),
                  );
                },
                leading: Icon(Icons.person),
                title: Text(member.name),
                subtitle: Text('${member.role} - ${member.age} years old'),
              );
            },
          );
        },

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddFamilyMemberPage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddFamilyMemberPage extends StatefulWidget {
  @override
  _AddFamilyMemberPageState createState() => _AddFamilyMemberPageState();
}

class _AddFamilyMemberPageState extends State<AddFamilyMemberPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Family Member')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _roleController,
              decoration: InputDecoration(labelText: 'Role'),
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final newMember = FamilyMember(
                  name: _nameController.text,
                  role: _roleController.text,
                  age: _ageController.text,
                );
                await FirebaseFirestore.instance.collection('familyMembers').add({
                  'name': newMember.name,
                  'role': newMember.role,
                  'age': newMember.age,
                });
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditFamilyMemberPage extends StatefulWidget {
  final FamilyMember familyMember;

  EditFamilyMemberPage({required this.familyMember});

  @override
  _EditFamilyMemberPageState createState() => _EditFamilyMemberPageState();
}

class _EditFamilyMemberPageState extends State<EditFamilyMemberPage> {
  late TextEditingController _nameController;
  late TextEditingController _roleController;
  late TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.familyMember.name);
    _roleController = TextEditingController(text: widget.familyMember.role);
    _ageController = TextEditingController(text: widget.familyMember.age);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Family Member')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _roleController,
              decoration: InputDecoration(labelText: 'Role'),
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final editedMember = FamilyMember(
                  name: _nameController.text,
                  role: _roleController.text,
                  age: _ageController.text,
                );
                final querySnapshot = await FirebaseFirestore.instance
                    .collection('familyMembers')
                    .where('name', isEqualTo: widget.familyMember.name)
                    .where('role', isEqualTo: widget.familyMember.role)
                    .where('age', isEqualTo: widget.familyMember.age)
                    .get();

                if (querySnapshot.docs.isNotEmpty) {
                  final docId = querySnapshot.docs.first.id;
                  await FirebaseFirestore.instance
                      .collection('familyMembers')
                      .doc(docId)
                      .update({
                    'name': editedMember.name,
                    'role': editedMember.role,
                    'age': editedMember.age,
                  });
                }

                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
