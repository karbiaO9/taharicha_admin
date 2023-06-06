import 'package:flutter/material.dart';

class GoodWidget extends StatelessWidget {
  const GoodWidget({Key? key}) : super(key: key);

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
        Icon(Icons.thumb_up,color: Colors.orange,size: 16,),
        SizedBox(width: 3,),
        Text("GOOD",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w600,fontSize: 12),)
      ],),
    );
  }
}