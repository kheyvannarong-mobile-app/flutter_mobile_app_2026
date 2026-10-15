import 'room_model.dart';

class FloorModel {
  int? id;
  int? hotelId;
  String? numberNo;
  String? decription;
  String? status;
  List<RoomModel> rooms;

  FloorModel({
    this.id,
    this.hotelId,
    this.numberNo,
    this.decription,
    this.status = "ACT",
    List<RoomModel>? rooms,
  }) : rooms = rooms ?? [];

  factory FloorModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) return FloorModel();

    List<RoomModel> parsedRooms = [];
    if (json['rooms'] != null && json['rooms'] is List) {
      parsedRooms = (json['rooms'] as List).map((r) => RoomModel.fromJson(r)).toList();
    }

    return FloorModel(
      id: json['id'] as int?,
      hotelId: json['hotelId'] as int?,
      numberNo: json['numberNo'] as String?,
      decription: json['decription'] as String?,
      status: json['status'] as String? ?? "ACT",
      rooms: parsedRooms,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'hotelId': hotelId,
      'numberNo': numberNo,
      'decription': decription,
      'status': status,
      'rooms': rooms.map((r) => r.toJson()).toList(),
    };
  }
}
