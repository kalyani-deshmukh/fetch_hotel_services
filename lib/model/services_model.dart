class ServicesModel {
  String? title;
  String? leading;
  bool? trailing;

  ServicesModel({
    required this.title,
    required this.leading,
    required this.trailing,
  });


  ServicesModel.fromJson(Map<String, dynamic> json){
    title = json['title'];
    leading = json['leading'];
    trailing = json['trailing'];
  }

  
}
