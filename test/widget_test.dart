import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/post/post_model.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/product/product_model.dart';

void main() {
  test('PostModel serialization test', () {
    final post = PostModel(
      id: 1,
      title: "Test Post",
      description: "Test Description",
      views: 10,
    );

    expect(post.id, 1);
    expect(post.title, "Test Post");
    expect(post.views, 10);
  });

  test('ProductModel serialization test', () {
    final product = ProductModel(
      id: 1,
      name: "Test Laptop",
      price: 999.99,
      stockQuantity: 15,
    );

    expect(product.name, "Test Laptop");
    expect(product.price, 999.99);
    expect(product.stockQuantity, 15);
  });
}
