class ProductCategoryModel {
  int? id;
  String? name;

  ProductCategoryModel({
    this.id,
    this.name,
  });

  factory ProductCategoryModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) return ProductCategoryModel();
    return ProductCategoryModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
    };
  }
}
