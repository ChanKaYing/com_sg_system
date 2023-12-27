import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(AdminFamilyPage());
}

class AdminFamilyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firestore Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: UserFamilyPage(),
    );
  }
}

class UserFamilyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Family Members'),
      ),
      body: UserFamilyList(),
    );
  }
}

class UserFamilyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
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
        return ListView.builder(
          itemCount: users?.length,
          itemBuilder: (context, index) {
            var user = users![index];
            var uid = user['uid'].toString(); // Convert uid to a string

            return ListTile(
              title: Text(uid), // Using the uid as the title
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FamilyMemberDetailsPage(uid: user.id),
                  ),
                );
              },
            );
          },
        );

      },
    );
  }
}

class FamilyMemberDetailsPage extends StatelessWidget {
  final String uid;

  FamilyMemberDetailsPage({required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Family Member Details'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('members')
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

          var members = snapshot.data?.docs;
          return ListView.builder(
            itemCount: members?.length,
            itemBuilder: (context, index) {
              var member = members![index];
              return ListTile(
                title: Text(member['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Age: ${member['age']}'),
                    Text('Role: ${member['role']}'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
