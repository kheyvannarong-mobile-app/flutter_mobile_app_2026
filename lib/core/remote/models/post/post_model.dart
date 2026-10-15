import 'post_category_model.dart';
import 'reactions_model.dart';
import '../login/User.dart';

class PostModel {
  int? id;
  String? title;
  String? description;
  String? body;
  int views;
  String? status;
  String? image;
  List<String> tags;
  ReactionsModel reactions;
  PostCategoryModel? postCategory;
  User? user;
  String? createdAt;

  PostModel({
    this.id,
    this.title,
    this.description,
    this.body,
    this.views = 0,
    this.status,
    this.image,
    List<String>? tags,
    ReactionsModel? reactions,
    this.postCategory,
    this.user,
    this.createdAt,
  })  : tags = tags ?? [],
        reactions = reactions ?? ReactionsModel();

  factory PostModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) return PostModel();

    List<String> parsedTags = [];
    if (json['tags'] != null && json['tags'] is List) {
      parsedTags = List<String>.from(json['tags']);
    }

    ReactionsModel parsedReactions = ReactionsModel();
    if (json['reactions'] != null) {
      parsedReactions = ReactionsModel.fromJson(json['reactions']);
    } else {
      // Direct likes/dislikes on root object fallback
      parsedReactions = ReactionsModel(
        likes: json['likes'] as int? ?? 0,
        dislikes: json['dislikes'] as int? ?? 0,
      );
    }

    PostCategoryModel? parsedCategory;
    if (json['postCategory'] != null) {
      parsedCategory = PostCategoryModel.fromJson(json['postCategory']);
    } else if (json['category'] != null) {
      parsedCategory = PostCategoryModel.fromJson(json['category']);
    }

    User? parsedUser;
    if (json['user'] != null) {
      parsedUser = User.fromJson(json['user']);
    }

    return PostModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      body: json['body'] as String?,
      views: json['views'] as int? ?? json['total_view'] as int? ?? 0,
      status: json['status'] as String?,
      image: json['image'] as String?,
      tags: parsedTags,
      reactions: parsedReactions,
      postCategory: parsedCategory,
      user: parsedUser,
      createdAt: json['createAt']?.toString() ?? json['createdAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'body': body,
      'views': views,
      'status': status,
      'image': image,
      'tags': tags,
      'reactions': reactions.toJson(),
      'categoryId': postCategory?.id,
    };
  }
}
