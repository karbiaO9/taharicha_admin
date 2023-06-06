import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/post.dart';
import '../../models/user.dart';
import '../homePage.dart';
import '../models/comment.dart';
import '../posts.dart';

class CommentWidget extends StatefulWidget {
  final Post post;
  final LocalUser user;
   CommentWidget({Key? key,required this.user,required this.post}) : super(key: key);

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
 final TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<CommentModel> comments= widget.post.comments.map((e) => CommentModel.fromJson(e)).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       const Divider(thickness: 2.0,indent: 20.0,endIndent: 20.0,),
       const Text('Comments'),
        SizedBox(
          height: 150,
          child: ListView.builder(
            itemCount: comments.length,
            itemBuilder: (_,index)=>ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(comments[index].pdp),),
            title: Text(comments[index].name),
            subtitle: Text(comments[index].comment),
            trailing: Text(comments[index].date,style:const TextStyle(color: Colors.grey),),
            ),
            
          )),
             
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: editingController,
            decoration: InputDecoration(hintText: "write your comment",suffixIcon: IconButton(onPressed: (){
                    if(editingController.text.isNotEmpty){
                      final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(now);
           setState(() {
                           widget.post.comments.add(CommentModel(comment: editingController.text, pdp: HomePage.admin.pdp, date: formatted, name: HomePage.admin.name).toJson());

           });
            FirebaseFirestore.instance.collection('posts').doc(widget.post.id).update({'comments': widget.post.comments}).then((value) => editingController.clear());
                    }


            
            }, icon:const Icon(Icons.send))),),
        ),
      ],
    );
  }
}