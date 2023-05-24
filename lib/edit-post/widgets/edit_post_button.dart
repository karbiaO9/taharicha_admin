import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/post.dart';
import '../../palatte.dart';

class EditPostButton extends StatelessWidget {
  final String food;
  final String description;
  final String location;
  final String restaurant;
  final String price;
  final String id;
  final String userId;

  const EditPostButton({
    Key? key,
    required this.buttonText,
    required this.food,
    required this.description,
    required this.location,
    required this.restaurant,
    required this.price,
    required this.id,
    required this.userId,
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
            editPost(
                food: food,
                description: description,
                location: location,
                restaurant: restaurant,
                price: price,
                id: id,
                userId: userId);
            Navigator.of(context).pushNamed('UserProfile');
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

  Future editPost(
      {required String food,
      required String description,
      required String location,
      required String restaurant,
      required String price,
      required String id,
      required String userId}) async {
    final docPost = FirebaseFirestore.instance.collection('posts').doc(id);

    final post = Post(
        id: docPost.id,
        food: food,
        description: description,
        location: location,
        price: price,
        restaurant: restaurant,
        userId: userId);
    final json = post.toJson();

    await docPost.update(json);
  }
}
