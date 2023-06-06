class CommentModel{
  final String comment;
  final String name;
  final String date;
  final String pdp;

  CommentModel({required this.comment,required this.pdp,required this.date, required this.name});

  factory CommentModel.fromJson(Map<String,dynamic> json)=>CommentModel(
    comment: json['comment']??"",
    name: json['name']??"",
    pdp:json['pdp']??"",
    date: json['date']??"");

  Map<String,dynamic> toJson(){
    return {
      'pdp':pdp,
      'comment':comment,
      'name':name,
      'date':date
    };
  }
  
}