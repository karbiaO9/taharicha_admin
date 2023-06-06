import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taharicha_admin/palatte.dart';
import 'package:taharicha_admin/posts.dart';



import '../../models/post.dart';
import 'homePage.dart';


class SavedPage extends StatelessWidget {
  const SavedPage({Key? key}) : super(key: key);

  Stream<List<Post>> readPosts() => FirebaseFirestore.instance
      .collection('posts')
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
          automaticallyImplyLeading: false,
          leading: IconButton(icon:const Icon(Icons.arrow_back),
          onPressed: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>const PostsScreen()));

          },),
          centerTitle: true,
          title: const Text(
            'Saved Posts',
            textAlign: TextAlign.center,
            style: kBodyText3,
          ),
          backgroundColor: Colors.red[600],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                
                  Expanded(
                    child: StreamBuilder<List<Post>>(
                        stream: readPosts(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                                'Something went wrong! ${snapshot.error} ');
                          } else if (snapshot.hasData) {
                            final posts = snapshot.data!;
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: posts.length,
                              itemBuilder: (BuildContext context, int index) {
                                if(HomePage.admin.saved.contains(posts[index].id)){
                                
                                                                  return PostWidget(post:posts[index],user:PostsScreen.users.firstWhere((element) => element.userId==posts[index].userId));

                                }
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

