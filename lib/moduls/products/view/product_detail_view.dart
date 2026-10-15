import 'package:flutter/material.dart';
import 'package:flutter_mobile_app_2026/constants/app_colors.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/product/product_model.dart';
import 'package:flutter_mobile_app_2026/routes/app_route_name.dart';
import 'package:flutter_mobile_app_2026/widgets/botanical_background_widget.dart';
import 'package:flutter_mobile_app_2026/widgets/frosted_glass_container.dart';
import 'package:get/get.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Get.arguments as ProductModel?;

    if (product == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: const Center(
          child: Text("Product not found", style: TextStyle(color: AppColors.textSecondary)),
        ),
      );
    }

    final isFavorite = false.obs;
    final inStock = product.stockQuantity > 0;

    return BotanicalBackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FrostedGlassContainer(
                            borderRadius: BorderRadius.circular(16),
                            padding: const EdgeInsets.all(8),
                            child: InkWell(
                              onTap: () => Get.back(),
                              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.textPrimary),
                            ),
                          ),
                          Row(
                            children: [
                              Obx(() => FrostedGlassContainer(
                                    borderRadius: BorderRadius.circular(16),
                                    padding: const EdgeInsets.all(8),
                                    child: InkWell(
                                      onTap: () => isFavorite.toggle(),
                                      child: Icon(
                                        isFavorite.value ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                        size: 20,
                                        color: isFavorite.value ? AppColors.accent : AppColors.textPrimary,
                                      ),
                                    ),
                                  )),
                              const SizedBox(width: 10),
                              FrostedGlassContainer(
                                borderRadius: BorderRadius.circular(16),
                                padding: const EdgeInsets.all(8),
                                child: InkWell(
                                  onTap: () async {
                                    final res = await Get.toNamed(AppRouteName.productCreate, arguments: product);
                                    if (res == true) {
                                      Get.back(result: true);
                                    }
                                  },
                                  child: const Icon(Icons.edit_outlined, size: 20, color: AppColors.textPrimary),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Title & Stock Status Badge
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name ?? "Product Details",
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: inStock ? AppColors.badgeGreenBg : Colors.red.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("●",
                                        style: TextStyle(
                                            fontSize: 8,
                                            color: inStock ? AppColors.badgeGreenText : Colors.red)),
                                    const SizedBox(width: 5),
                                    Text(
                                      inStock ? "In Stock: ${product.stockQuantity.toInt()} Units" : "Out of Stock",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: inStock ? AppColors.badgeGreenText : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (product.category?.name != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    product.category!.name!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Large 3D Product Presentation
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1B3D28).withValues(alpha: 0.1),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.inventory_2_rounded,
                            size: 96,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),

                    // Frosted Glass Bottom Container
                    FrostedGlassContainer(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Product Specifications",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // 4 Frosted Square Tiles Grid
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildGlassInfoTile(
                                icon: Icons.attach_money_rounded,
                                title: "Retail Price",
                                value: "\$${product.price.toStringAsFixed(2)}",
                              ),
                              _buildGlassInfoTile(
                                icon: Icons.receipt_long_rounded,
                                title: "Cost Price",
                                value: "\$${product.cost.toStringAsFixed(2)}",
                              ),
                              _buildGlassInfoTile(
                                icon: Icons.layers_rounded,
                                title: "Inventory",
                                value: "${product.stockQuantity.toInt()} Units",
                              ),
                              _buildGlassInfoTile(
                                icon: Icons.qr_code_rounded,
                                title: "SKU Code",
                                value: product.productCode ?? "N/A",
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Description Section
                          const Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.description != null && product.description!.isNotEmpty
                                ? product.description!
                                : "No detailed description registered for this product item in the Spring Boot database.",
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Backend API details card
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.white),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 22),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Spring Boot Entity Info",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "ID: ${product.id ?? 'New'} • Status: ${product.status ?? 'ACT'} • Controller: ProductController",
                                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Fixed Bottom Floating Action Bar
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: FrostedGlassContainer(
                  borderRadius: BorderRadius.circular(30),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Price", style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                              Text(
                                "\$${product.price.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final res = await Get.toNamed(AppRouteName.productCreate, arguments: product);
                          if (res == true) Get.back(result: true);
                        },
                        icon: const Icon(Icons.edit_rounded, size: 18, color: Colors.white),
                        label: const Text(
                          "Edit Product",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 4,
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
