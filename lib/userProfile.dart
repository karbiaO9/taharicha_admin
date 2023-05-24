import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taharicha_admin/edit-post/edit_post_page.dart';
import 'package:taharicha_admin/palatte.dart';

import '../../../models/post.dart';
import 'models/user.dart';

class UserProfilePage extends StatefulWidget {
  final LocalUser user;

  const UserProfilePage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String userId = '';

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    loadUserId();
  }

  loadUserId() async {
    setState(() {
      userId = widget.user.userId;
    });
  }

  Stream<List<Post>> readPosts() => FirebaseFirestore.instance
      .collection('posts')
      .where(
        'userId',
        isEqualTo: userId,
      )
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList());

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
            'User Profile',
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
                  Container(
                    child: buildUser(widget.user),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(context, 'NewPost'),
                      child: Text(
                        'What did you eat Last time ?!',
                        style: kBodyTextNEW,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Expanded(
                    child: StreamBuilder<List<Post>>(
                        stream: readPosts(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                                'Something went wrong! ${snapshot.error} ');
                          } else if (snapshot.hasData) {
                            final posts = snapshot.data!;
                            return ListView.separated(
                              shrinkWrap: true,
                              itemCount: posts.length,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(),
                              itemBuilder: (BuildContext context, int index) {
                                return _Post(posts[index], context);
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
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.blueGrey, width: 1),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0))),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () => Navigator.pushNamed(context, 'HomePage'),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.home,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const Text('Home'),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/'),
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.favorite_outline_rounded,
                        color: Colors.red,
                      ),
                      Text('Favorite'),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => Navigator.pushNamed(context, 'NewPost'),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                        heightFactor: 0,
                        child: Icon(
                          Icons.add_circle_outlined,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 75.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/'),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.notifications,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const Text('Notifications'),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => Navigator.pushNamed(context, 'MyProfile'),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.person_outline_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const Text('Profile'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _Post(Post post, BuildContext context) => Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        height: 200,
        width: 300,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: Colors.white70),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const SizedBox(
                  width: 30,
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.thumb_up),
                    color: const Color.fromRGBO(62, 62, 104, 100)),
                const Text(
                  '10',
                  style: kBodyText001,
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.thumb_down),
                    color: const Color.fromRGBO(62, 62, 104, 100)),
                const Text(
                  '4',
                  style: kBodyText001,
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.comment),
                    color: const Color.fromRGBO(62, 62, 104, 100)),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditPostPage(post: post)),
                      );
                    },
                    icon: const Icon(Icons.update),
                    color: const Color.fromRGBO(62, 62, 104, 100)),
                IconButton(
                    onPressed: () {
                      _deletePost(post.id);
                    },
                    icon: const Icon(Icons.delete),
                    color: const Color.fromRGBO(62, 62, 104, 100)),
              ]),
              Row(
                children: [
                  Text(
                    'Food :  ',
                    style: kBodyText1,
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    post.food,
                    style: kBodyText1,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Description :  ',
                    style: kBodyText1,
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    post.description,
                    style: kBodyText1,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Location :  ',
                    style: kBodyText1,
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    post.location,
                    style: kBodyText1,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Restaurant :  ',
                    style: kBodyText1,
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    post.restaurant,
                    style: kBodyText1,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Price:  ',
                    style: kBodyText1,
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    post.price,
                    style: kBodyText1,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

void _deletePost(String postId) {
  FirebaseFirestore.instance
      .collection('posts')
      .doc(postId)
      .delete()
      .then((value) {
    // Post deletion successful
    print('Post deleted successfully');
  }).catchError((error) {
    // Handle any error that occurred during deletion
    print('Error deleting post: $error');
  });
}

Widget buildUser(LocalUser user) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Center(
            child: Text(
              user.name,
              style: kBodyTextP,
            ),
          ),
        ],
      ),
    );
