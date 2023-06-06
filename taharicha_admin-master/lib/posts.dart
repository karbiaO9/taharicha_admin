import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:taharicha_admin/palatte.dart';
import 'package:taharicha_admin/saved.dart';
import 'package:taharicha_admin/widget/bad_widget.dart';
import 'package:taharicha_admin/widget/comment_widget.dart';
import 'package:taharicha_admin/widget/good_widget.dart';

import '../../../models/post.dart';
import 'homePage.dart';
import 'models/user.dart';

class PostsScreen extends StatefulWidget {
 static late List<LocalUser> users;
  static late List<Post> posts;

  const PostsScreen({Key? key}) : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
    Stream<List<LocalUser>> readUser() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => LocalUser.fromJson(doc.data())).toList());

        

  
  Stream<List<Post>> readPosts() => FirebaseFirestore.instance
      .collection('posts')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList());
          @override

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
            'Posts',
            textAlign: TextAlign.center,
            style: kBodyText3,
          ),
          backgroundColor: Colors.red[600],
          actions: [IconButton(onPressed: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>const SavedPage()));
          }, icon:const Icon(Icons.bookmark_border_outlined))],
        ),
        body: Container(
          child: Stack(
            children: [
             
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                        StreamBuilder(
                stream: readUser(),
                builder: (_,snap){
                  if(snap.hasData){
                    print('my data ${snap.data![0]}');
                                          PostsScreen.users=snap.data!;

                  }
                   return Container();

              }),
                 
                  Expanded(
                    child: StreamBuilder<List<Post>>(
                        stream: readPosts(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                                'Something went wrong! ${snapshot.error} ');
                          } else if (snapshot.hasData) {
                             final posts = snapshot.data!;
                             PostsScreen.posts=posts;
                            return ListView.separated(
                              shrinkWrap: true,
                              itemCount: posts.length,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(),
                              itemBuilder: (BuildContext context, int index) {
                                return PostWidget(post:posts[index],user:PostsScreen.users.firstWhere((element) => element.userId==posts[index].userId));
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

class PostWidget extends StatefulWidget {
  final Post post;
  final LocalUser user;
  const PostWidget({Key? key,required this.post,required this.user}) : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}



class _PostWidgetState extends State<PostWidget> {
  late bool reported;
late bool saved;
 late bool liked =false;
bool disliked =false;
Future<void> like_btn(Post post) async {
  List<dynamic> _likedPostes = HomePage.admin.likes;
  List<dynamic> _dislikedPostes = HomePage.admin.dislikes;


  if(!_likedPostes.contains(post.id) && !_dislikedPostes.contains(post.id)){
    post.likes++;
    HomePage.admin.likes.add(post.id);
    liked=true;
    disliked=false;
  }else if(!_likedPostes.contains(post.id) && _dislikedPostes.contains(post.id)){
      post.likes++;
      HomePage.admin.likes.add(post.id);
      post.dislikes--;
      HomePage.admin.dislikes.remove(post.id);
      liked=true;
      disliked=false;
  }
      final docPost = FirebaseFirestore.instance.collection('posts').doc(post.id);
       await docPost.update(post.toJson());
       final docUser = FirebaseFirestore.instance.collection('admin').doc('r0vUnSZ1KpETtrodO2px');
       await docUser.update(HomePage.admin.toJson());


}
Future<void> dislike_btn(Post post)async{
  List<dynamic> _likedPostes = HomePage.admin.likes;
  List<dynamic> _dislikedPostes = HomePage.admin.dislikes;


  if(!_likedPostes.contains(post.id) && !_dislikedPostes.contains(post.id)){
    post.dislikes++;
    HomePage.admin.dislikes.add(post.id);
    disliked=true;
    liked=false;
  }else if(!_dislikedPostes.contains(post.id) && _likedPostes.contains(post.id)){
      post.dislikes++;
      HomePage.admin.dislikes.add(post.id);
      post.likes--;
      HomePage.admin.likes.remove(post.id);
      disliked=true;
      liked=false;
  }
  final docPost = FirebaseFirestore.instance.collection('posts').doc(post.id);
       await docPost.update(post.toJson());
       final docUser = FirebaseFirestore.instance.collection('admin').doc('r0vUnSZ1KpETtrodO2px');
       await docUser.update(HomePage.admin.toJson());
}

    late ExpandableController contoller;
  bool toggel = false;

@override
  void initState() {
    contoller=ExpandableController();
    liked=HomePage.admin.likes.contains(widget.post.id);
    disliked=HomePage.admin.dislikes.contains(widget.post.id);
    saved=HomePage.admin.saved.contains(widget.post.id);
    reported=HomePage.admin.reports.contains(widget.post.id);

    super.initState();

  }
@override
  void dispose() {
    contoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

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
                        IconButton(
                            onPressed: ()async {
                              if(!HomePage.admin.saved.contains(widget.post.id)){
                                setState(() {
                                  HomePage.admin.saved.add(widget.post.id);

                                });
                              }else{
                                setState(() {
                                 HomePage.admin.saved.remove(widget.post.id);
                                });
                                
                              }
                              final docUser = FirebaseFirestore.instance.collection('admin').doc('r0vUnSZ1KpETtrodO2px');
       await docUser.update({'saved':HomePage.admin.saved});
       print(HomePage.admin.saved);
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
                      setState(() {
                      });
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
}
}