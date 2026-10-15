class PostCreateReq {
  String title;
  String? description;
  String? body;
  String? image;
  int categoryId;
  List<String> tags;

  PostCreateReq({
    required this.title,
    this.description,
    this.body,
    this.image,
    required this.categoryId,
    List<String>? tags,
  }) : tags = tags ?? [];

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'body': body,
      'image': image,
      'categoryId': categoryId,
      'tags': tags,
    };
  }
}
