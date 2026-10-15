import 'package:flutter/material.dart';
import 'package:flutter_mobile_app_2026/constants/app_colors.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/product/product_model.dart';
import 'package:flutter_mobile_app_2026/moduls/products/controller/products_controller.dart';
import 'package:flutter_mobile_app_2026/routes/app_route_name.dart';
import 'package:flutter_mobile_app_2026/widgets/category_chip_widget.dart';
import 'package:flutter_mobile_app_2026/widgets/empty_state_widget.dart';
import 'package:flutter_mobile_app_2026/widgets/frosted_glass_container.dart';
import 'package:get/get.dart';

class ProductsTabView extends StatelessWidget {
  const ProductsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header: Products & Inventory
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Products",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              Text(
                                "E-Commerce catalog, stock & pricing",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        FrostedGlassContainer(
                          borderRadius: BorderRadius.circular(20),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          child: InkWell(
                            onTap: () async {
                              final res = await Get.toNamed(AppRouteName.productCreate);
                              if (res == true) {
                                controller.fetchProducts();
                              }
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.add_rounded, size: 18, color: AppColors.primary),
                                SizedBox(width: 4),
                                Text(
                                  "Add Product",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Search Pill
                    FrostedGlassContainer(
                      borderRadius: BorderRadius.circular(30),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: TextField(
                        controller: controller.searchController,
                        onChanged: controller.onSearch,
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: "Search products by name or SKU...",
                          hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 22),
                          suffixIcon: controller.searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textMuted),
                                  onPressed: () {
                                    controller.searchController.clear();
                                    controller.onSearch('');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Featured Horizontal Product Carousel
                    Obx(() {
                      final list = controller.products;
                      if (list.isEmpty) return const SizedBox.shrink();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Featured & Best Sellers",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                "Total ${list.length}",
                                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 205,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: list.length > 5 ? 5 : list.length,
                              itemBuilder: (context, index) {
                                final product = list[index];
                                return _build3DProductCard(context, product);
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    }),

                    // Categories Horizontal Bar
                    SizedBox(
                      height: 44,
                      child: Obx(() {
                        final categories = controller.categories;
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: categories.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              final isSelected = controller.selectedCategoryId.value == 0;
                              return CategoryChipWidget(
                                label: "All Products",
                                isSelected: isSelected,
                                icon: Icons.all_inclusive_rounded,
                                onTap: () => controller.selectCategory(0),
                              );
                            }
                            final cat = categories[index - 1];
                            final isSelected = controller.selectedCategoryId.value == cat.id;
                            return CategoryChipWidget(
                              label: cat.name ?? '',
                              isSelected: isSelected,
                              onTap: () => controller.selectCategory(cat.id ?? 0),
                            );
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // Products Catalog List
            Obx(() {
              if (controller.isLoading.value && controller.products.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                );
              }

              final list = controller.filteredProducts;

              if (list.isEmpty) {
                return SliverFillRemaining(
                  child: EmptyStateWidget(
                    icon: Icons.inventory_2_outlined,
                    title: "No Products Found",
                    subtitle: "Tap 'Add Product' to register items into the catalog.",
                    buttonText: "Reload Catalog",
                    onRetry: () => controller.fetchProducts(),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = list[index];
                      return _buildCatalogRowCard(context, product, controller);
                    },
                    childCount: list.length,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // 3D Frosted Vertical Card
  Widget _build3DProductCard(BuildContext context, ProductModel product) {
    final inStock = product.stockQuantity > 0;

    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 14),
      child: AnimatedGlassCard(
        borderRadius: BorderRadius.circular(24),
        padding: const EdgeInsets.all(12),
        onTap: () => Get.toNamed(AppRouteName.productDetail, arguments: product),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 3D Icon container
            Container(
              height: 95,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white),
              ),
              child: const Center(
                child: Icon(Icons.inventory_2_rounded, size: 44, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.name ?? "Product",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            // Stock badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: inStock ? AppColors.badgeGreenBg : Colors.red.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("●",
                      style: TextStyle(
                          fontSize: 8,
                          color: inStock ? AppColors.badgeGreenText : Colors.red)),
                  const SizedBox(width: 4),
                  Text(
                    inStock ? "Qty: ${product.stockQuantity.toInt()}" : "Out of Stock",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: inStock ? AppColors.badgeGreenText : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              "\$${product.price.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Catalog Detailed Row Card
  Widget _buildCatalogRowCard(BuildContext context, ProductModel product, ProductsController controller) {
    final bool inStock = product.stockQuantity > 0;

    return AnimatedGlassCard(
      margin: const EdgeInsets.only(bottom: 14),
      borderRadius: BorderRadius.circular(22),
      padding: const EdgeInsets.all(14),
      onTap: () => Get.toNamed(AppRouteName.productDetail, arguments: product),
      child: Row(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white),
            ),
            child: const Center(
              child: Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: 30),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? "Product",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "SKU: ${product.productCode ?? 'N/A'}",
                        style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      inStock ? "Stock: ${product.stockQuantity.toInt()}" : "Out of Stock",
                      style: TextStyle(
                        fontSize: 11,
                        color: inStock ? AppColors.badgeGreenText : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      "\$${product.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Cost: \$${product.cost.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.textMuted),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            onSelected: (val) async {
              if (val == 'edit') {
                final res = await Get.toNamed(AppRouteName.productCreate, arguments: product);
                if (res == true) controller.fetchProducts();
              } else if (val == 'delete') {
                Get.defaultDialog(
                  title: "Delete Product",
                  middleText: "Are you sure you want to delete ${product.name}?",
                  textConfirm: "Delete",
                  textCancel: "Cancel",
                  confirmTextColor: Colors.white,
                  cancelTextColor: AppColors.textSecondary,
                  buttonColor: AppColors.error,
                  onConfirm: () async {
                    Get.back();
                    await controller.deleteProduct(product);
                  },
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 18, color: AppColors.textPrimary),
                    SizedBox(width: 8),
                    Text("Edit"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                    SizedBox(width: 8),
                    Text("Delete", style: TextStyle(color: AppColors.error)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
