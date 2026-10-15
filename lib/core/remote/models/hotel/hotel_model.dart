import 'category_hotel_model.dart';
import 'floor_model.dart';

class HotelModel {
  int? id;
  int? userId;
  String? imageUrl;
  String? name;
  String? description;
  String? phone;
  String? email;
  String? status;
  CategoryHotelModel? categoryHotel;
  List<FloorModel> floors;

  HotelModel({
    this.id,
    this.userId,
    this.imageUrl,
    this.name,
    this.description,
    this.phone,
    this.email,
    this.status = "ACT",
    this.categoryHotel,
    List<FloorModel>? floors,
  }) : floors = floors ?? [];

  factory HotelModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) return HotelModel();

    CategoryHotelModel? cat;
    if (json['categoryHotel'] != null) {
      cat = CategoryHotelModel.fromJson(json['categoryHotel']);
    }

    List<FloorModel> parsedFloors = [];
    if (json['floors'] != null && json['floors'] is List) {
      parsedFloors = (json['floors'] as List).map((f) => FloorModel.fromJson(f)).toList();
    }

    return HotelModel(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      imageUrl: json['imageUrl'] as String?,
      name: json['name'] as String?,
      description: json['decription'] as String? ?? json['description'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      status: json['status'] as String? ?? "ACT",
      categoryHotel: cat,
      floors: parsedFloors,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'imageUrl': imageUrl,
      'name': name,
      'decription': description,
      'phone': phone,
      'email': email,
      'status': status,
      if (categoryHotel != null) 'categoryHotel': categoryHotel!.toJson(),
      'floors': floors.map((f) => f.toJson()).toList(),
    };
  }
}
