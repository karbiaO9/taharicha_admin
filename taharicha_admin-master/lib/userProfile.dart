import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taharicha_admin/palatte.dart';
import 'package:taharicha_admin/widget/bad_widget.dart';
import 'package:taharicha_admin/widget/comment_widget.dart';
import 'package:taharicha_admin/widget/good_widget.dart';

import '../../../models/post.dart';
import 'models/report.dart';
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
  }


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
          centerTitle: true,
          title: const Text(
            'My Profile',
            textAlign: TextAlign.center,
            style: kBodyText3,
          ),
          actions: [
          /*  IconButton(
              icon:const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_)=>EditProfilePage(user:HomePage.currentUser)));
              },
            ),*/

          ],
          backgroundColor: Colors.red[600],
        ),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildUser(widget.user),
               const SizedBox(
                  height: 2,
                ),
             
               const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: StreamBuilder<List<Post>>(
                      stream: readPosts(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(
                              'Something went wrong! ${snapshot.error} ');
                        } else if (snapshot.hasData) {
                          final posts = snapshot.data!.where((e)=>e.userId==widget.user.userId).toList();
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: posts.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ProfilePost(post:posts[index],user:widget.user);
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
    );
  }
Widget buildUser(LocalUser user) => Padding(
  padding: const EdgeInsets.all(18.0),
  child:   SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
               CircleAvatar(backgroundImage: NetworkImage(user.pdp),radius: 60,),
  
            Text(
              user.name,
              style: kBodyTextP,
            ),
          ],
        ),
      ),
);
}
  bool liked =false;
bool disliked =false;
Future<void> like_btn(Post post,LocalUser user) async {
  List<dynamic> _likedPostes = user.likes;
  List<dynamic> _dislikedPostes = user.dislikes;


  if(!_likedPostes.contains(post.id) && !_dislikedPostes.contains(post.id)){
    post.likes++;
    user.likes.add(post.id);
    liked=true;
    disliked=false;
  }else if(!_likedPostes.contains(post.id) && _dislikedPostes.contains(post.id)){
      post.likes++;
      user.likes.add(post.id);
      post.dislikes--;
      user.dislikes.remove(post.id);
      liked=true;
      disliked=false;
  }
      final docPost = FirebaseFirestore.instance.collection('posts').doc(post.id);
       await docPost.update(post.toJson());
       final docUser = FirebaseFirestore.instance.collection('users').doc(user.id);
       await docUser.update(user.toJson());


}
Future<void> dislike_btn(Post post,LocalUser user)async{
  List<dynamic> _likedPostes = user.likes;
  List<dynamic> _dislikedPostes = user.dislikes;


  if(!_likedPostes.contains(post.id) && !_dislikedPostes.contains(post.id)){
    post.dislikes++;
    user.dislikes.add(post.id);
    disliked=true;
    liked=false;
  }else if(!_dislikedPostes.contains(post.id) && _likedPostes.contains(post.id)){
      post.dislikes++;
      user.dislikes.add(post.id);
      post.likes--;
      user.likes.remove(post.id);
      disliked=true;
      liked=false;
  }
  final docPost = FirebaseFirestore.instance.collection('posts').doc(post.id);
       await docPost.update(post.toJson());
       final docUser = FirebaseFirestore.instance.collection('users').doc(user.id);
       await docUser.update(user.toJson());
}



  

class ProfilePost extends StatefulWidget {
 final Post post;
 final LocalUser user;
  const ProfilePost({Key? key,required this.post,required this.user}) : super(key: key);
  @override
  State<ProfilePost> createState() => _ProfilePostState();
}

class _ProfilePostState extends State<ProfilePost> {
  late ExpandableController contoller;
  bool toggel = false;
  @override
  void initState() {
    super.initState();
    contoller=ExpandableController();
    liked=widget.user.likes.contains(widget.post.id);
  disliked=widget.user.dislikes.contains(widget.post.id);
  
  }
  @override
  void dispose() {
    super.dispose();
    contoller.dispose();
  }
  @override
  Widget build(BuildContext context) {
        CollectionReference reports = FirebaseFirestore.instance.collection('reports');
        final querySnapshot=reports.get();

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        width: 300,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: Colors.white70),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children:[
                     ClipRRect(
                      borderRadius:const BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                      child: ColorFiltered(
                            colorFilter: const ColorFilter.mode(Color.fromARGB(34, 4, 4, 4), BlendMode.darken), 
                        child: Image.network(widget.post.image ,  width: 400,height: 200,fit: BoxFit.cover,))),
                        Positioned(
                          right:0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: widget.post.good? const GoodWidget(): const BadWidget(),
                          ),
                        )
                      ]
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                IconButton(onPressed: ()async{
                  await like_btn(widget.post,widget.user);
                }, icon: Icon(Icons.thumb_up,color: liked?Colors.blue:Colors.grey,)),
                Text(
                  widget.post.likes.toString(),
                  style: kBodyText001,
                ),
                const SizedBox(
                  width: 10,
                ),
                  IconButton(onPressed: ()async{
                  await dislike_btn(widget.post,widget.user);
                }, icon: Icon(Icons.thumb_down,color: disliked?Colors.blue:Colors.grey,)),
                Text(
                  widget.post.dislikes.toString(),
                  style: kBodyText001,
                ),
                const SizedBox(
                  width: 15,
                ),
                IconButton(
                    onPressed: () {
                      contoller.toggle();
                      setState(() {
                        toggel=!toggel;
                      });
                    },
                    icon:  Icon(Icons.comment,color: toggel?Colors.blue:Colors.grey,),
                    color: const Color.fromRGBO(62, 62, 104, 100)),
                const SizedBox(
                  width: 10,
                ),
               
             /*   IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditPostPage(post: widget.post)),
                      );
                    },
                    icon: const Icon(Icons.update),
                    color: const Color.fromRGBO(62, 62, 104, 100)),*/
                    
                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance.collection('reports').get(),
                  builder:(_,data) {
                    if(data.hasData){
               final List<DocumentSnapshot> documents = data.data!.docs;
                  print('rep data ${documents[0]['id']}');
                List<Report> rp = documents.map((doc) => Report.fromJson(doc.data() as Map<String,dynamic>)).toList();
return IconButton(
                      onPressed: () {
                        _deletePost(widget.post.id);
                                     FirebaseFirestore.instance
                        .collection('reports')
                        .doc(rp.firstWhere((element) => element.postId==widget.post.id).id)
                        .delete();
                      },
                      icon: const Icon(Icons.delete),
                      color: const Color.fromRGBO(62, 62, 104, 100));

                    }
                 return Container();

//                    print('repppp ${data.data.}');
                    
                  },
                ),
              ]),
              Row(
                children: [
               const   Text(
                    'Food :  ',
                    style: kBodyText1,
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    widget.post.food,
                    style: kBodyText1,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
              Row(
                children: [
                const  Text(
                    'Description :  ',
                    style: kBodyText1,
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    widget.post.description,
                    style: kBodyText1,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
              Row(
                children: [
                 const Text(
                    'Location :  ',
                    style: kBodyText1,
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    widget.post.location,
                    style: kBodyText1,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
              Row(
                children: [
                const  Text(
                    'Restaurant :  ',
                    style: kBodyText1,
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    widget.post.restaurant,
                    style: kBodyText1,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
              Row(
                children: [
                const  Text(
                    'Price:  ',
                    style: kBodyText1,
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    widget.post.price,
                    style: kBodyText1,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
         ExpandablePanel(
          controller: contoller,
          collapsed: Container(),
           expanded: CommentWidget(user: widget.user, post: widget.post,))
            ],
          ),
        ),
      ),
    );
}

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
}}