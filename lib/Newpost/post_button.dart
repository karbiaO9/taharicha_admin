import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taharicha_admin/palatte.dart';

import '../../models/post.dart';

class PostButton extends StatelessWidget {
  final String food;
  final String description;
  final String location;
  final String restaurant;
  final String price;

  const PostButton({
    Key? key,
    required this.buttonText,
    required this.food,
    required this.description,
    required this.location,
    required this.restaurant,
    required this.price,
  }) : super(key: key);
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: const Color(0xFF5663FE).withOpacity(0.5),
          border: Border.all(color: Colors.black, width: 5),
          borderRadius: BorderRadius.circular(30)),
      child: TextButton(
          onPressed: () {
            createPost(
              food: food,
              description: description,
              location: location,
              restaurant: restaurant,
              price: price,
            );
            Navigator.of(context).pushNamed('HomePage');
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              buttonText,
              style: kBodyText1,
            ),
          )),
    );
  }

  Future createPost(
      {required String food,
      required String description,
      required String location,
      required String restaurant,
      required String price}) async {
    final docPost = FirebaseFirestore.instance.collection('posts').doc();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String userId = prefs.getString("userId") ?? '';
    final post = Post(
        id: docPost.id,
        food: food,
        description: description,
        location: location,
        price: price,
        restaurant: restaurant,
        userId: userId);
    final json = post.toJson();

    await docPost.set(json);
  }
}
