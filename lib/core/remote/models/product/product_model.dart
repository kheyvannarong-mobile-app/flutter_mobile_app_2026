import 'product_category_model.dart';

class ProductModel {
  int? id;
  String? name;
  String? productCode;
  ProductCategoryModel? category;
  double price;
  double cost;
  double stockQuantity;
  String? description;
  String? status;

  ProductModel({
    this.id,
    this.name,
    this.productCode,
    this.category,
    this.price = 0.0,
    this.cost = 0.0,
    this.stockQuantity = 0.0,
    this.description,
    this.status = "ACT",
  });

  factory ProductModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) return ProductModel();

    ProductCategoryModel? cat;
    if (json['category'] != null) {
      cat = ProductCategoryModel.fromJson(json['category']);
    }

    return ProductModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      productCode: json['productCode'] as String?,
      category: cat,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
      stockQuantity: (json['stockQuantity'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String?,
      status: json['status'] as String? ?? "ACT",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'productCode': productCode,
      if (category != null) 'category': category!.toJson(),
      'price': price,
      'cost': cost,
      'stockQuantity': stockQuantity,
      'description': description,
      'status': status,
    };
  }
}
