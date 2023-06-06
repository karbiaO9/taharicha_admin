import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taharicha_admin/models/report.dart';
import 'package:taharicha_admin/post_details.dart';
import 'package:taharicha_admin/posts.dart';

import 'models/post.dart';
import 'models/user.dart';

class ReportsScreen extends StatefulWidget {
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

 
class _ReportsScreenState extends State<ReportsScreen> {
  List<Post> posts=[];
  List<LocalUser> users=[];

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


  Stream<List<Report>> getReports() => FirebaseFirestore.instance
      .collection('reports')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Report.fromJson(doc.data())).toList());
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title:const Text('Reports'),
        backgroundColor: Colors.red[600],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<AggregateQuerySnapshot>(
              future: FirebaseFirestore.instance
      .collection('reports').count().get(),
              builder:(_,snap){
                if(snap.hasData){
                  return Text(
                'Number of reports: ${snap.data!.count}',
                style:const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              );
                } else {
                  return const Text(
                'Number of reports: 0',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              );
                }
              }
            ),

                        StreamBuilder(
                stream: readUser(),
                builder: (_,snap){
                  if(snap.hasData){
                    print('my data ${snap.data![0]}');
                                           users=snap.data!;

                  }
                   return Container();

              }),

StreamBuilder<List<Post>>(
                        stream: readPosts(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                                'Something went wrong! ${snapshot.error} ');
                          } else if (snapshot.hasData) {
                              posts = snapshot.data!;
                             return   Container();
                              
                          
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }),

              
           const SizedBox(height: 16.0),
            Expanded(
              child: StreamBuilder<List<Report>>(
                stream: getReports(),
                builder: (context, snapshot) {

                  if(snapshot.hasData){
                       return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: ()async{
                              print('posts $posts');
                              Post _p=posts.firstWhere((element) => element.id==snapshot.data![index].postId);
                             try {
                               String res=  await Navigator.of(context).push(MaterialPageRoute(builder: (_)=> PostDetails(post :_p,user: users.firstWhere((element) => element.userId==_p.userId),)));
                               FirebaseFirestore.instance
      .collection('reports')
      .doc(snapshot.data!.firstWhere((element) => element.postId==res).id)
      .delete();
                              
                             }catch(e){
                              print('error');
                             }
                            },
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(snapshot.data![index].photo),
                            ),
                            title: Text('${snapshot.data![index].name}'
                                ),
                                subtitle: Text('Post Id :   \n '
                                '${snapshot.data![index].postId}'),
                          ),
                        );
                      

                    
                    },
                  );
                  }else{
                    return  Center(child:  Container());
                  }
                 
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
