import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:taharicha_admin/palatte.dart';
import 'package:taharicha_admin/posts.dart';
import 'package:taharicha_admin/widget/bad_widget.dart';
import 'package:taharicha_admin/widget/comment_widget.dart';
import 'package:taharicha_admin/widget/good_widget.dart';

import 'models/post.dart';
import 'models/user.dart';

class PostDetails extends StatefulWidget {
   final Post post;
  final LocalUser user;

  const PostDetails({super.key, required this.post, required this.user});

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
 late bool reported;

late bool saved;

 late bool liked =false;

bool disliked =false;

Future<void> like_btn(Post post) async {
  List<dynamic> _likedPostes = PostsScreen.admin.likes;
  List<dynamic> _dislikedPostes = PostsScreen.admin.dislikes;


  if(!_likedPostes.contains(post.id) && !_dislikedPostes.contains(post.id)){
    post.likes++;
    PostsScreen.admin.likes.add(post.id);
    liked=true;
    disliked=false;
  }else if(!_likedPostes.contains(post.id) && _dislikedPostes.contains(post.id)){
      post.likes++;
      PostsScreen.admin.likes.add(post.id);
      post.dislikes--;
      PostsScreen.admin.dislikes.remove(post.id);
      liked=true;
      disliked=false;
  }
      final docPost = FirebaseFirestore.instance.collection('posts').doc(post.id);
       await docPost.update(post.toJson());
       final docUser = FirebaseFirestore.instance.collection('admin').doc('r0vUnSZ1KpETtrodO2px');
       await docUser.update(PostsScreen.admin.toJson());


}

Future<void> dislike_btn(Post post)async{
  List<dynamic> _likedPostes = PostsScreen.admin.likes;
  List<dynamic> _dislikedPostes = PostsScreen.admin.dislikes;


  if(!_likedPostes.contains(post.id) && !_dislikedPostes.contains(post.id)){
    post.dislikes++;
    PostsScreen.admin.dislikes.add(post.id);
    disliked=true;
    liked=false;
  }else if(!_dislikedPostes.contains(post.id) && _likedPostes.contains(post.id)){
      post.dislikes++;
      PostsScreen.admin.dislikes.add(post.id);
      post.likes--;
      PostsScreen.admin.likes.remove(post.id);
      disliked=true;
      liked=false;
  }
  final docPost = FirebaseFirestore.instance.collection('posts').doc(post.id);
       await docPost.update(post.toJson());
       final docUser = FirebaseFirestore.instance.collection('admin').doc('r0vUnSZ1KpETtrodO2px');
       await docUser.update(PostsScreen.admin.toJson());
}

    late ExpandableController contoller;

  bool toggel = false;

@override
  void initState() {
    contoller=ExpandableController();
    contoller.expanded=true;
  
    liked=PostsScreen.admin.likes.contains(widget.post.id);
    disliked=PostsScreen.admin.dislikes.contains(widget.post.id);
    saved=PostsScreen.admin.saved.contains(widget.post.id);
    reported=PostsScreen.admin.reports.contains(widget.post.id);

    super.initState();

  }

@override
  void dispose() {
    contoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

  return Scaffold(
    body: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Container(
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
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                    Row(children: [
                                       CircleAvatar(backgroundImage: NetworkImage(widget.user.pdp),),
                                    const SizedBox(width: 5,),
                                    Text(widget.user.name,style:const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                                    ],),
                                   
                                   widget.post.good? const GoodWidget(): const BadWidget()
                                  ],),
                                )
                              ]
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                          
                         IconButton(onPressed: ()async{
                    await like_btn(widget.post);
                  }, icon: Icon(Icons.thumb_up,color: liked?Colors.blue:Colors.grey,)),
                          Text(
                            widget.post.likes.toString(),
                            style: kBodyText001,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                            IconButton(onPressed: ()async{
                    await dislike_btn(widget.post);
                  }, icon: Icon(Icons.thumb_down,color: disliked?Colors.blue:Colors.grey,)),
                          Text(
                            widget.post.dislikes.toString(),
                            style: kBodyText001,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          IconButton(
                              onPressed: () {
                                 contoller.expanded=true;
                       
                              },
                              icon:  Icon(Icons.comment,color: toggel?Colors.blue:Colors.grey,),
                              color: const Color.fromRGBO(62, 62, 104, 100)),
                          const SizedBox(
                            width: 10,
                          ),
                          IconButton(
                              onPressed: ()async {
                                if(!PostsScreen.admin.saved.contains(widget.post.id)){
                                  setState(() {
                                    PostsScreen.admin.saved.add(widget.post.id);
  
                                  });
                                }else{
                                  setState(() {
                                   PostsScreen.admin.saved.remove(widget.post.id);
                                  });
                                  
                                }
                                final docUser = FirebaseFirestore.instance.collection('admin').doc('r0vUnSZ1KpETtrodO2px');
         await docUser.update({'saved':PostsScreen.admin.saved});
         print(PostsScreen.admin.saved);
                                setState(() {
                                  saved=!saved;
                                });
                              },
                              icon:  Icon(Icons.bookmark_add_outlined,color:saved?Colors.blue:Colors.grey),
                              color: Colors.grey),
                          const SizedBox(
                            width: 10,
                          ),
                           IconButton(
                      onPressed: () {
                        _deletePost(widget.post.id);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.delete),
                      color: const Color.fromRGBO(62, 62, 104, 100)),
                        ]),
                        Row(
                          children: [
                           const Text(
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
                           const Text(
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
                          const  Text(
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
                            const Text(
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
    
      ),
  );}

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
}