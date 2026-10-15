import 'package:flutter/material.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/product/product_category_model.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/product/product_model.dart';
import 'package:flutter_mobile_app_2026/core/remote/services/api_service.dart';
import 'package:get/get.dart';

class ProductsController extends GetxController {
  final ApiService apiService;

  ProductsController({required this.apiService});

  var products = <ProductModel>[].obs;
  var categories = <ProductCategoryModel>[].obs;
  var selectedCategoryId = 0.obs; // 0 means all
  var searchKeyword = ''.obs;
  var isLoading = false.obs;

  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> loadData() async {
    await fetchCategories();
    await fetchProducts();
  }

  Future<void> fetchCategories() async {
    try {
      final list = await apiService.getProductCategories();
      if (list.isNotEmpty) {
        categories.assignAll(list);
      } else {
        categories.assignAll(_fallbackCategories());
      }
    } catch (e) {
      debugPrint("Error fetching product categories: $e");
      if (categories.isEmpty) {
        categories.assignAll(_fallbackCategories());
      }
    }
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    try {
      final list = await apiService.getProducts(status: "ALL");
      if (list.isNotEmpty) {
        products.assignAll(list);
      } else {
        products.assignAll(_fallbackProducts());
      }
    } catch (e) {
      debugPrint("Error fetching products: $e");
      if (products.isEmpty) {
        products.assignAll(_fallbackProducts());
      }
    } finally {
      isLoading.value = false;
    }
  }

  List<ProductModel> get filteredProducts {
    return products.where((p) {
      final matchesSearch = searchKeyword.value.isEmpty ||
          (p.name?.toLowerCase().contains(searchKeyword.value.toLowerCase()) ?? false) ||
          (p.productCode?.toLowerCase().contains(searchKeyword.value.toLowerCase()) ?? false);

      final matchesCategory = selectedCategoryId.value == 0 ||
          (p.category != null && p.category!.id == selectedCategoryId.value);

      return matchesSearch && matchesCategory;
    }).toList();
  }

  void selectCategory(int id) {
    selectedCategoryId.value = id;
  }

  void onSearch(String query) {
    searchKeyword.value = query.trim();
  }

  Future<bool> createProduct(ProductModel product) async {
    final success = await apiService.createProduct(product);
    if (success) {
      Get.snackbar("Success", "Product added successfully!",
          backgroundColor: Colors.green.shade100, colorText: Colors.green.shade900);
      await fetchProducts();
      return true;
    } else {
      Get.snackbar("Error", "Failed to create product",
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
      return false;
    }
  }

  Future<bool> updateProduct(ProductModel product) async {
    final success = await apiService.updateProduct(product);
    if (success) {
      Get.snackbar("Success", "Product updated successfully!",
          backgroundColor: Colors.green.shade100, colorText: Colors.green.shade900);
      await fetchProducts();
      return true;
    } else {
      Get.snackbar("Error", "Failed to update product",
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
      return false;
    }
  }

  Future<bool> deleteProduct(ProductModel product) async {
    final success = await apiService.deleteProduct(product);
    if (success) {
      products.removeWhere((p) => p.id == product.id);
      Get.snackbar("Success", "Product deleted successfully!",
          backgroundColor: Colors.green.shade100, colorText: Colors.green.shade900);
      return true;
    } else {
      Get.snackbar("Error", "Failed to delete product",
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
      return false;
    }
  }

  Future<bool> createCategory(String name) async {
    final success = await apiService.createProductCategory(name);
    if (success) {
      await fetchCategories();
      Get.snackbar("Success", "Category created",
          backgroundColor: Colors.green.shade100, colorText: Colors.green.shade900);
      return true;
    }
    return false;
  }

  List<ProductCategoryModel> _fallbackCategories() {
    return [
      ProductCategoryModel(id: 1, name: "Electronics"),
      ProductCategoryModel(id: 2, name: "Fashion & Apparel"),
      ProductCategoryModel(id: 3, name: "Home & Kitchen"),
      ProductCategoryModel(id: 4, name: "Sports & Outdoors"),
      ProductCategoryModel(id: 5, name: "Beauty & Personal Care"),
    ];
  }

  List<ProductModel> _fallbackProducts() {
    final cats = _fallbackCategories();
    return [
      ProductModel(
        id: 1,
        name: "iPhone 15 Pro Max 256GB",
        productCode: "PROD-IPHONE15",
        category: cats[0],
        price: 1199.00,
        cost: 950.00,
        stockQuantity: 45.0,
        description: "Natural Titanium finish with A17 Pro chip, Super Retina XDR OLED display, and advanced 48MP triple camera system.",
        status: "ACT",
      ),
      ProductModel(
        id: 2,
        name: "MacBook Pro 14\" M3 Max",
        productCode: "PROD-MBP14M3",
        category: cats[0],
        price: 2399.00,
        cost: 1950.00,
        stockQuantity: 20.0,
        description: "Space Black finish, 36GB Unified Memory, 1TB SSD, 14-core CPU and 30-core GPU for extreme professional workflows.",
        status: "ACT",
      ),
      ProductModel(
        id: 3,
        name: "Sony WH-1000XM5 Headphones",
        productCode: "PROD-SONYXM5",
        category: cats[0],
        price: 399.00,
        cost: 280.00,
        stockQuantity: 60.0,
        description: "Industry-leading wireless noise-canceling headphones with dual processors, 8 microphones, and 30-hour battery life.",
        status: "ACT",
      ),
      ProductModel(
        id: 4,
        name: "Nike Air Jordan 1 Retro High",
        productCode: "PROD-JORDAN1",
        category: cats[1],
        price: 180.00,
        cost: 95.00,
        stockQuantity: 35.0,
        description: "Iconic high-top basketball sneaker in premium leather with Chicago color blocking and encapsulated Nike Air cushioning.",
        status: "ACT",
      ),
      ProductModel(
        id: 5,
        name: "De'Longhi Magnifica S Espresso",
        productCode: "PROD-ESPRESSO",
        category: cats[2],
        price: 549.00,
        cost: 380.00,
        stockQuantity: 15.0,
        description: "Automatic bean-to-cup coffee and espresso machine with manual cappuccino milk frother and 15-bar pump pressure.",
        status: "ACT",
      ),
      ProductModel(
        id: 6,
        name: "Apple Watch Ultra 2 (49mm Titanium)",
        productCode: "PROD-WATCHU2",
        category: cats[3],
        price: 799.00,
        cost: 620.00,
        stockQuantity: 28.0,
        description: "Rugged 49mm titanium case with sapphire crystal, precision dual-frequency GPS, 3000-nit display, and Oceanic+ dive computer.",
        status: "ACT",
      ),
      ProductModel(
        id: 7,
        name: "Herman Miller Aeron Ergonomic Chair",
        productCode: "PROD-AERON",
        category: cats[2],
        price: 1495.00,
        cost: 980.00,
        stockQuantity: 12.0,
        description: "The benchmark for ergonomic office seating with breathable Pellicle mesh, PostureFit SL lumbar support, and fully adjustable arms.",
        status: "ACT",
      ),
      ProductModel(
        id: 8,
        name: "Dyson Supersonic Hair Dryer",
        productCode: "PROD-DYSONHD",
        category: cats[4],
        price: 429.00,
        cost: 290.00,
        stockQuantity: 30.0,
        description: "Intelligent heat control to protect natural shine, engineered for different hair types with 5 magnetic styling attachments.",
        status: "ACT",
      ),
    ];
  }
}
