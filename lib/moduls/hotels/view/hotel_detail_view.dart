import 'package:flutter/material.dart';
import 'package:flutter_mobile_app_2026/constants/app_colors.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/hotel/floor_model.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/hotel/hotel_model.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/hotel/room_model.dart';
import 'package:flutter_mobile_app_2026/moduls/hotels/controller/hotels_controller.dart';
import 'package:flutter_mobile_app_2026/widgets/botanical_background_widget.dart';
import 'package:flutter_mobile_app_2026/widgets/frosted_glass_container.dart';
import 'package:get/get.dart';

class HotelDetailView extends StatefulWidget {
  const HotelDetailView({super.key});

  @override
  State<HotelDetailView> createState() => _HotelDetailViewState();
}

class _HotelDetailViewState extends State<HotelDetailView> {
  late HotelModel hotel;
  final HotelsController controller = Get.find<HotelsController>();

  bool loading = true;
  HotelModel? detailedHotel;

  @override
  void initState() {
    super.initState();
    hotel = Get.arguments as HotelModel;
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    final res = await controller.getHotelDetails(hotel.id ?? 0);
    if (mounted) {
      setState(() {
        detailedHotel = res ?? hotel;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentHotel = detailedHotel ?? hotel;

    return BotanicalBackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Banner with Hotel Image
            SliverAppBar(
              expandedHeight: 260,
              pinned: true,
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
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      currentHotel.imageUrl ?? 'https://picsum.photos/seed/hotel${currentHotel.id ?? 1}/800/600',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.badgeGreenBg,
                        child: const Center(
                          child: Icon(Icons.hotel_rounded, size: 72, color: AppColors.primary),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.15),
                            Colors.transparent,
                            AppColors.background.withValues(alpha: 0.85),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Hotel Details & Rooms
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category & Status
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.badgeGreenBg,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            currentHotel.categoryHotel?.name ?? "Eco Resort",
                            style: const TextStyle(
                              color: AppColors.badgeGreenText,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.verified_rounded, size: 14, color: AppColors.primary),
                              SizedBox(width: 4),
                              Text(
                                "Verified Eco Stay",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Name
                    Text(
                      currentHotel.name ?? "Luxury Botanical Stay",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Contact Card (Frosted Glass)
                    FrostedGlassContainer(
                      borderRadius: BorderRadius.circular(20),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          if (currentHotel.phone != null && currentHotel.phone!.isNotEmpty) ...[
                            Row(
                              children: [
                                const Icon(Icons.phone_outlined, size: 18, color: AppColors.primary),
                                const SizedBox(width: 10),
                                Text(
                                  currentHotel.phone!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                          if (currentHotel.email != null && currentHotel.email!.isNotEmpty) ...[
                            Row(
                              children: [
                                const Icon(Icons.email_outlined, size: 18, color: AppColors.primary),
                                const SizedBox(width: 10),
                                Text(
                                  currentHotel.email!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Description
                    if (currentHotel.description != null && currentHotel.description!.isNotEmpty) ...[
                      const Text(
                        "About This Resort",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentHotel.description!,
                        style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Floors and Rooms Section
                    const Row(
                      children: [
                        Icon(Icons.meeting_room_outlined, color: AppColors.primary),
                        SizedBox(width: 8),
                        Text(
                          "Accommodations & Rooms",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    if (loading) ...[
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(color: AppColors.primary),
                        ),
                      ),
                    ] else if (currentHotel.floors.isEmpty) ...[
                      FrostedGlassContainer(
                        borderRadius: BorderRadius.circular(20),
                        padding: const EdgeInsets.all(24),
                        child: const Center(
                          child: Column(
                            children: [
                              Icon(Icons.bed_outlined, size: 40, color: AppColors.textMuted),
                              SizedBox(height: 8),
                              Text(
                                "No room details listed currently.",
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      ...currentHotel.floors.map((floor) => _buildFloorItem(floor)),
                    ],

                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloorItem(FloorModel floor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: FrostedGlassContainer(
        borderRadius: BorderRadius.circular(20),
        padding: EdgeInsets.zero,
        child: ExpansionTile(
          shape: const Border(),
          initiallyExpanded: true,
          iconColor: AppColors.primary,
          collapsedIconColor: AppColors.textMuted,
          leading: const Icon(Icons.layers_outlined, color: AppColors.primary),
          title: Text(
            floor.numberNo != null ? "Floor ${floor.numberNo}" : "Floor Level",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
          ),
          subtitle: Text(
            floor.decription ?? "${floor.rooms.length} Rooms Available",
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          children: [
            if (floor.rooms.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text("No rooms on this floor", style: TextStyle(color: AppColors.textMuted)),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: floor.rooms.length,
                separatorBuilder: (ctx, index) => const Divider(height: 1, color: AppColors.divider),
                itemBuilder: (context, index) {
                  final room = floor.rooms[index];
                  return _buildRoomTile(room);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomTile(RoomModel room) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.badgeGreenBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.single_bed_rounded, color: AppColors.primary, size: 22),
      ),
      title: Text(
        "Room ${room.numberNo ?? 'N/A'}",
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
      ),
      subtitle: Text(
        room.decription ?? "Standard Bedroom",
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "\$${room.price.toStringAsFixed(2)}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: room.status == "ACT" ? AppColors.badgeGreenBg : const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              room.status == "ACT" ? "Available" : "Booked",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: room.status == "ACT" ? AppColors.badgeGreenText : AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
