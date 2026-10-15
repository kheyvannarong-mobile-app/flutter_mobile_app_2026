import 'package:flutter/material.dart';
import 'package:flutter_mobile_app_2026/constants/app_colors.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/product/product_category_model.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/product/product_model.dart';
import 'package:flutter_mobile_app_2026/moduls/products/controller/products_controller.dart';
import 'package:flutter_mobile_app_2026/widgets/botanical_background_widget.dart';
import 'package:flutter_mobile_app_2026/widgets/button_custom_widget.dart';
import 'package:flutter_mobile_app_2026/widgets/frosted_glass_container.dart';
import 'package:flutter_mobile_app_2026/widgets/input_custom_widget.dart';
import 'package:get/get.dart';

class ProductCreateEditView extends StatefulWidget {
  const ProductCreateEditView({super.key});

  @override
  State<ProductCreateEditView> createState() => _ProductCreateEditViewState();
}

class _ProductCreateEditViewState extends State<ProductCreateEditView> {
  final ProductsController controller = Get.find<ProductsController>();

  ProductModel? existingProduct;
  bool isEditing = false;
  bool loading = false;

  final nameController = TextEditingController();
  final codeController = TextEditingController();
  final priceController = TextEditingController();
  final costController = TextEditingController();
  final stockController = TextEditingController();
  final descController = TextEditingController();

  ProductCategoryModel? selectedCategory;

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null && Get.arguments is ProductModel) {
      existingProduct = Get.arguments as ProductModel;
      isEditing = true;
      nameController.text = existingProduct!.name ?? '';
      codeController.text = existingProduct!.productCode ?? '';
      priceController.text = existingProduct!.price.toString();
      costController.text = existingProduct!.cost.toString();
      stockController.text = existingProduct!.stockQuantity.toString();
      descController.text = existingProduct!.description ?? '';
      selectedCategory = existingProduct!.category;
    } else {
      if (controller.categories.isNotEmpty) {
        selectedCategory = controller.categories.first;
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    codeController.dispose();
    priceController.dispose();
    costController.dispose();
    stockController.dispose();
    descController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final name = nameController.text.trim();
    final code = codeController.text.trim();
    final price = double.tryParse(priceController.text.trim()) ?? 0.0;
    final cost = double.tryParse(costController.text.trim()) ?? 0.0;
    final stock = double.tryParse(stockController.text.trim()) ?? 0.0;
    final desc = descController.text.trim();

    if (name.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Product name is required",
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        colorText: AppColors.error,
      );
      return;
    }

    setState(() => loading = true);

    final product = ProductModel(
      id: isEditing ? existingProduct!.id : null,
      name: name,
      productCode: code.isNotEmpty ? code : "SKU-${DateTime.now().millisecondsSinceEpoch % 10000}",
      category: selectedCategory,
      price: price,
      cost: cost,
      stockQuantity: stock,
      description: desc,
      status: "ACT",
    );

    bool success;
    if (isEditing) {
      success = await controller.updateProduct(product);
    } else {
      success = await controller.createProduct(product);
    }

    setState(() => loading = false);

    if (success) {
      Get.back(result: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BotanicalBackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Container(
            margin: const EdgeInsets.all(8),
            child: FrostedGlassContainer(
              borderRadius: BorderRadius.circular(20),
              padding: EdgeInsets.zero,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 18),
                onPressed: () => Get.back(),
              ),
            ),
          ),
          title: Text(
            isEditing ? "Edit Product" : "Register New Product",
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: -0.4,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FrostedGlassContainer(
                  borderRadius: BorderRadius.circular(28),
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      InputCustomWidgets(
                        controller: nameController,
                        labelText: "Product Name *",
                        hintText: "e.g. Wireless Noise-Cancelling Headphones",
                        prefixIcon: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary),
                      ),
                      const SizedBox(height: 16),

                      InputCustomWidgets(
                        controller: codeController,
                        labelText: "Catalog Code / SKU",
                        hintText: "e.g. SKU-1001",
                        prefixIcon: const Icon(Icons.qr_code_rounded, color: AppColors.primary),
                      ),
                      const SizedBox(height: 16),

                      // Category Selector
                      Obx(() {
                        final categories = controller.categories;
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white, width: 1.2),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              dropdownColor: Colors.white,
                              isExpanded: true,
                              value: selectedCategory?.id,
                              hint: const Text("Select Category", style: TextStyle(color: AppColors.textMuted)),
                              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                              items: categories.map((c) {
                                return DropdownMenuItem<int>(
                                  value: c.id,
                                  child: Text(c.name ?? "General"),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  selectedCategory = categories.firstWhereOrNull((c) => c.id == val);
                                });
                              },
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: InputCustomWidgets(
                              controller: priceController,
                              labelText: "Retail Price (\$)",
                              hintText: "0.00",
                              prefixIcon: const Icon(Icons.attach_money_rounded, color: AppColors.primary),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InputCustomWidgets(
                              controller: costController,
                              labelText: "Cost (\$)",
                              hintText: "0.00",
                              prefixIcon: const Icon(Icons.money_off_rounded, color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      InputCustomWidgets(
                        controller: stockController,
                        labelText: "Stock Quantity",
                        hintText: "e.g. 50",
                        prefixIcon: const Icon(Icons.inventory_2_outlined, color: AppColors.primary),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: descController,
                        maxLines: 3,
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                        decoration: InputDecoration(
                          labelText: "Product Description",
                          labelStyle: const TextStyle(color: AppColors.textSecondary),
                          hintText: "Specifications, warranty, package details...",
                          hintStyle: const TextStyle(color: AppColors.textMuted),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 26),

                      ButtonCustomWidget(
                        label: isEditing ? "Save Changes" : "Register Product",
                        backgroundColor: AppColors.primary,
                        textColor: Colors.white,
                        loading: loading,
                        onPressed: _onSubmit,
                        icon: Icons.check_circle_rounded,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
