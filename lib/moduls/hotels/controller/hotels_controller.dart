import 'package:flutter/foundation.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/hotel/category_hotel_model.dart';
import 'package:flutter_mobile_app_2026/core/remote/models/hotel/hotel_model.dart';
import 'package:flutter_mobile_app_2026/core/remote/services/api_service.dart';
import 'package:get/get.dart';

class HotelsController extends GetxController {
  final ApiService apiService;

  HotelsController({required this.apiService});

  var hotels = <HotelModel>[].obs;
  var categories = <CategoryHotelModel>[].obs;
  var selectedCategoryId = 0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    await fetchCategories();
    await fetchHotels();
  }

  Future<void> fetchCategories() async {
    try {
      final list = await apiService.getHotelCategories();
      if (list.isNotEmpty) {
        categories.assignAll(list);
      } else {
        categories.assignAll(_fallbackCategories());
      }
    } catch (e) {
      debugPrint("Error fetching hotel categories: $e");
      if (categories.isEmpty) {
        categories.assignAll(_fallbackCategories());
      }
    }
  }

  Future<void> fetchHotels() async {
    isLoading.value = true;
    try {
      final list = await apiService.getHotels(
        type: selectedCategoryId.value == 0 ? "ALL" : "BY_CATEGORY",
        categoryHotelId: selectedCategoryId.value > 0 ? selectedCategoryId.value : null,
      );
      if (list.isNotEmpty) {
        hotels.assignAll(list);
      } else {
        final all = _fallbackHotels();
        if (selectedCategoryId.value == 0) {
          hotels.assignAll(all);
        } else {
          hotels.assignAll(all.where((h) => h.categoryHotel?.id == selectedCategoryId.value).toList());
        }
      }
    } catch (e) {
      debugPrint("Error fetching hotels: $e");
      if (hotels.isEmpty) {
        final all = _fallbackHotels();
        if (selectedCategoryId.value == 0) {
          hotels.assignAll(all);
        } else {
          hotels.assignAll(all.where((h) => h.categoryHotel?.id == selectedCategoryId.value).toList());
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  void selectCategory(int id) {
    if (selectedCategoryId.value == id) return;
    selectedCategoryId.value = id;
    fetchHotels();
  }

  Future<HotelModel?> getHotelDetails(int id) async {
    return await apiService.getHotelById(id);
  }

  List<CategoryHotelModel> _fallbackCategories() {
    return [
      CategoryHotelModel(id: 1, name: "Luxury Resort", status: "ACT"),
      CategoryHotelModel(id: 2, name: "Boutique Hotel", status: "ACT"),
      CategoryHotelModel(id: 3, name: "Business Hotel", status: "ACT"),
      CategoryHotelModel(id: 4, name: "Eco Eco-Lodge", status: "ACT"),
    ];
  }

  List<HotelModel> _fallbackHotels() {
    final cats = _fallbackCategories();
    return [
      HotelModel(
        id: 1,
        name: "The Royal Grand Palace Resort",
        imageUrl: "https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=800&q=80",
        description: "Experience world-class hospitality with panoramic riverfront views, rooftop infinity pool, and luxury dining.",
        phone: "023 888 999",
        email: "booking@royalgrand.kh",
        categoryHotel: cats[0],
        status: "ACT",
      ),
      HotelModel(
        id: 2,
        name: "Angkor Heritage Sanctuary",
        imageUrl: "https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=800&q=80",
        description: "Tranquil tropical sanctuary nestled amidst lush private gardens, traditional Khmer architecture, and a rejuvenating wellness spa.",
        phone: "063 777 888",
        email: "reservations@angkorheritage.kh",
        categoryHotel: cats[1],
        status: "ACT",
      ),
      HotelModel(
        id: 3,
        name: "Skyline Central Executive Hotel",
        imageUrl: "https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=800&q=80",
        description: "Modern high-rise executive suites in the heart of the capital with business conference facilities and panoramic sky bar.",
        phone: "023 999 111",
        email: "stay@skylinephnompenh.kh",
        categoryHotel: cats[2],
        status: "ACT",
      ),
      HotelModel(
        id: 4,
        name: "Riverside Eco Villa & Retreat",
        imageUrl: "https://images.unsplash.com/photo-1571896349842-33c89424de2d?auto=format&fit=crop&w=800&q=80",
        description: "Peaceful nature-inspired wooden chalets with organic farm dining, yoga pavilion, and sunset river cruise.",
        phone: "097 333 444",
        email: "retreat@riverside.kh",
        categoryHotel: cats[3],
        status: "ACT",
      ),
    ];
  }
}
