import 'package:flutter/material.dart';

class BadWidget extends StatelessWidget {
  const BadWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 30,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),color: Colors.white),
      child: 
     const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Icon(Icons.thumb_down,color: Colors.orange,size: 16,),
        SizedBox(width: 3,),
        Text("BAD",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w600,fontSize: 12),)
      ],),
    );
  }
}