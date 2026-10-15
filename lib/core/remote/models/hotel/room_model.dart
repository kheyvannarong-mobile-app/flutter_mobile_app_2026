class RoomModel {
  int? id;
  int? floorId;
  String? numberNo;
  String? decription;
  double price;
  String? status;

  RoomModel({
    this.id,
    this.floorId,
    this.numberNo,
    this.decription,
    this.price = 0.0,
    this.status = "ACT",
  });

  factory RoomModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) return RoomModel();
    return RoomModel(
      id: json['id'] as int?,
      floorId: json['floorId'] as int?,
      numberNo: json['numberNo'] as String?,
      decription: json['decription'] as String?,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? "ACT",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'floorId': floorId,
      'numberNo': numberNo,
      'decription': decription,
      'price': price,
      'status': status,
    };
  }
}
