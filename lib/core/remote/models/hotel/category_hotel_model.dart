class CategoryHotelModel {
  int? id;
  String? name;
  String? status;

  CategoryHotelModel({
    this.id,
    this.name,
    this.status,
  });

  factory CategoryHotelModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) return CategoryHotelModel();
    return CategoryHotelModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'status': status,
    };
  }
}
