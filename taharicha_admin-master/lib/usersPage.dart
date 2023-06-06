import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taharicha_admin/palatte.dart';
import 'package:taharicha_admin/userProfile.dart';

import 'models/user.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Stream<List<LocalUser>> readUsers() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => LocalUser.fromJson(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color.fromRGBO(249, 50, 9, .2),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Users',
            textAlign: TextAlign.center,
            style: kBodyText3,
          ),
          backgroundColor: Colors.red[600],
        ),
        body: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Expanded(
                    child: StreamBuilder<List<LocalUser>>(
                        stream: readUsers(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                                'Something went wrong! ${snapshot.error} ');
                          } else if (snapshot.hasData) {
                            final users = snapshot.data!;
                            return ListView.separated(
                              shrinkWrap: true,
                              itemCount: users.length,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(),
                              itemBuilder: (BuildContext context, int index) {
                                return buildUser(users[index],
                                    context); // Pass the context argument
                              },
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildUser(LocalUser user, BuildContext context) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.white,
        height: 75,
        child: Row(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                ),
                SizedBox(width: 30, child: Text(user.name)),
                SizedBox(
                  width: 160,
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Text(user.email),
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserProfilePage(
                            user: user,
                          )),
                );
              },
              icon: const Icon(Icons.list_alt_sharp),
              color: const Color.fromRGBO(62, 62, 104, 100),
            ),
            IconButton(
              onPressed: () {
                _deleteUser(user.id, context); // Pass the context parameter
              },
              icon: const Icon(Icons.delete),
              color: const Color.fromRGBO(62, 62, 104, 100),
            ),
          ],
        ),
      ),
    );

void _deleteUser(String userId, BuildContext context) {
  // Add the context parameter
  final user = FirebaseFirestore.instance.collection('users').doc(userId);

  user.delete().then((value) {
    // User deletion successful
    print('User deleted successfully');
  }).catchError((error) {
    // Handle any error that occurred during deletion
    print('Error deleting user: $error');
  });
}
