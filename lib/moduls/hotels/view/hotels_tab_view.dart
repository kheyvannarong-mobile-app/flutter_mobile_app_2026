import 'package:flutter/material.dart';
import 'package:flutter_mobile_app_2026/constants/app_colors.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/hotel/hotel_model.dart';
import 'package:flutter_mobile_app_2026/moduls/hotels/controller/hotels_controller.dart';
import 'package:flutter_mobile_app_2026/routes/app_route_name.dart';
import 'package:flutter_mobile_app_2026/widgets/category_chip_widget.dart';
import 'package:flutter_mobile_app_2026/widgets/empty_state_widget.dart';
import 'package:flutter_mobile_app_2026/widgets/frosted_glass_container.dart';
import 'package:get/get.dart';

class HotelsTabView extends StatefulWidget {
  const HotelsTabView({super.key});

  @override
  State<HotelsTabView> createState() => _HotelsTabViewState();
}

class _HotelsTabViewState extends State<HotelsTabView> {
  final HotelsController controller = Get.find<HotelsController>();
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = "".obs;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Top App Bar & Header
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
                                "Hotels & Stays",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              Text(
                                "Accommodations, floor plans & room booking",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.refresh_rounded, color: AppColors.primary, size: 24),
                          onPressed: () {
                            controller.fetchCategories();
                            controller.fetchHotels();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Search Pill Container
                    FrostedGlassContainer(
                      borderRadius: BorderRadius.circular(30),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: TextField(
                        controller: searchController,
                        onChanged: (val) => searchQuery.value = val.trim().toLowerCase(),
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: "Search hotels by name, location, or contact...",
                          hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 22),
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textMuted),
                                  onPressed: () {
                                    searchController.clear();
                                    searchQuery.value = "";
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Hotel Categories Horizontal Bar
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
                                label: "All Stays",
                                isSelected: isSelected,
                                icon: Icons.all_inclusive_rounded,
                                onTap: () => controller.selectCategory(0),
                              );
                            }
                            final cat = categories[index - 1];
                            final isSelected = controller.selectedCategoryId.value == cat.id;
                            return CategoryChipWidget(
                              label: cat.name ?? "Resort",
                              isSelected: isSelected,
                              icon: Icons.hotel_rounded,
                              onTap: () => controller.selectCategory(cat.id ?? 0),
                            );
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Hotel Listings
            Obx(() {
              if (controller.isLoading.value && controller.hotels.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                );
              }

              final query = searchQuery.value;
              final list = controller.hotels.where((h) {
                if (query.isEmpty) return true;
                final nameMatch = (h.name ?? "").toLowerCase().contains(query);
                final descMatch = (h.description ?? "").toLowerCase().contains(query);
                final phoneMatch = (h.phone ?? "").toLowerCase().contains(query);
                return nameMatch || descMatch || phoneMatch;
              }).toList();

              if (list.isEmpty) {
                return SliverFillRemaining(
                  child: EmptyStateWidget(
                    icon: Icons.hotel_outlined,
                    title: "No Accommodations Found",
                    subtitle: "No hotel listings match your current search or category filter.",
                    buttonText: "Reload Hotels",
                    onRetry: () => controller.fetchHotels(),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final hotel = list[index];
                      return _buildHotelCard(context, hotel);
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

  Widget _buildHotelCard(BuildContext context, HotelModel hotel) {
    final catName = hotel.categoryHotel?.name ?? "Accommodation";
    final floorsCount = hotel.floors.length;
    final int roomsCount = hotel.floors.fold(0, (sum, f) => sum + f.rooms.length);

    return AnimatedGlassCard(
      margin: const EdgeInsets.only(bottom: 18),
      borderRadius: BorderRadius.circular(24),
      onTap: () => Get.toNamed(AppRouteName.hotelDetail, arguments: hotel),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hotel Hero Image with Category Badge & Star Rating
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: Image.network(
                  hotel.imageUrl ?? 'https://picsum.photos/seed/hotel${hotel.id ?? 1}/800/450',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    color: AppColors.badgeGreenBg,
                    child: const Center(
                      child: Icon(Icons.hotel_rounded, size: 54, color: AppColors.primary),
                    ),
                  ),
                ),
              ),
              // Category Badge
              Positioned(
                top: 14,
                left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.88),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, size: 16, color: Color(0xFFFFA000)),
                      const SizedBox(width: 4),
                      Text(
                        catName,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Status Badge
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("●", style: TextStyle(fontSize: 8, color: Colors.white)),
                      SizedBox(width: 4),
                      Text(
                        "ACTIVE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Hotel Info Area
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        hotel.name ?? "Luxury Hotel & Suites",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                if (hotel.description != null && hotel.description!.isNotEmpty) ...[
                  Text(
                    hotel.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Amenities & Specifications Row
                Row(
                  children: [
                    _buildSpecChip(Icons.layers_rounded, "$floorsCount Floors"),
                    const SizedBox(width: 8),
                    _buildSpecChip(Icons.meeting_room_rounded, "$roomsCount Rooms"),
                    const SizedBox(width: 8),
                    if (hotel.phone != null && hotel.phone!.isNotEmpty)
                      _buildSpecChip(Icons.phone_rounded, hotel.phone!),
                  ],
                ),
                const SizedBox(height: 14),

                // Footer with Explore Button
                Row(
                  children: [
                    if (hotel.email != null && hotel.email!.isNotEmpty)
                      Expanded(
                        child: Text(
                          hotel.email!,
                          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    else
                      const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "View Rooms",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
