class PostCategoryModel {
  int? id;
  String? name;
  String? imageUrl;
  String? status;
  String? createdAt;

  PostCategoryModel({
    this.id,
    this.name,
    this.imageUrl,
    this.status,
    this.createdAt,
  });

  factory PostCategoryModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) return PostCategoryModel();
    return PostCategoryModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      imageUrl: json['imageUrl'] as String?,
      status: json['status'] as String?,
      createdAt: json['createAt']?.toString() ?? json['createdAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'status': status,
    };
  }
}
