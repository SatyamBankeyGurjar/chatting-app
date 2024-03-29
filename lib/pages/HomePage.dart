import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messanger_app/services/auth/AuthService.dart';
import 'package:provider/provider.dart';

import 'ChatPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //sign out
  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          //sign out button
          IconButton(onPressed: signOut, icon: Icon(Icons.logout))
        ],
      ),
      body: _userList(),
    );
  }

  // build a list of users for the current logged user
  Widget _userList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('loading...');
          }

          return ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildUserListItem(doc))
                .toList(),
          );
        });
  }

  // build individual user list items
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    // display all users expect current user
    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
        title: Text(
          data['email'],
        ),
        onTap: () {
          // pass the clicked user's UID to the chat page
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                      receivedUserEmail: data['email'],
                      receivedUserID: data['uid'],
                    )),
          );
        },
      );
    } else {
      // return empty container
      return Container();
    }
  }
}
