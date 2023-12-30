import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


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
  final String uid;
  FamilyPage({required this.uid});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Family Detail Page',
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}

class FamilyDetailPage extends StatelessWidget {

  final String uid;
  FamilyDetailPage({required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Family Detail')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('members')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final members = (snapshot.data?.docs ?? []).map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return FamilyMember(
              name: data['name'] ?? '',
              role: data['role'] ?? '',
              age: data['age'] ?? '',
            );
          }).toList();
          return ListView.builder(
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditFamilyMemberPage(
                        familyMember: member,
                        uid: uid,
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
              builder: (context) => AddFamilyMemberPage(uid: uid),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddFamilyMemberPage extends StatefulWidget {
  String uid;
  AddFamilyMemberPage({required this.uid});

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
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.uid)
                    .collection('members')
                    .add({
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
  final String uid;

  EditFamilyMemberPage({
    required this.familyMember,
    required this.uid,
  });

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
                    .collection('users')
                    .doc(widget.uid)
                    .collection('members')
                    .where('name', isEqualTo: widget.familyMember.name)
                    .where('role', isEqualTo: widget.familyMember.role)
                    .where('age', isEqualTo: widget.familyMember.age)
                    .get();

                if (querySnapshot.docs.isNotEmpty) {
                  final docId = querySnapshot.docs.first.id;
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.uid)
                      .collection('members')
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

