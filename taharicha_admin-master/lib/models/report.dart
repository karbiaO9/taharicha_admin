class Report{
 final String id;
 final String name;
 final String photo;
 final String postId;

  Report({required this.id,required this.name,required this.photo,required this.postId});

  factory Report.fromJson(Map<String,dynamic> json)=>Report(
    id: json['id'],
     name: json['name'],
     photo: json['photo'],
     postId: json['postId']);

  Map<String,dynamic> toJson()=>{
      'id':id,
      'name':name,
      'photo':photo,
      'postId':postId
  }; 

 
}