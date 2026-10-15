class ReactionsModel {
  int likes;
  int dislikes;

  ReactionsModel({
    this.likes = 0,
    this.dislikes = 0,
  });

  factory ReactionsModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) return ReactionsModel();
    return ReactionsModel(
      likes: json['likes'] as int? ?? 0,
      dislikes: json['dislikes'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'likes': likes,
      'dislikes': dislikes,
    };
  }
}
