class ApiBaseResponse {
  String? message;
  String? messageKh;
  String? messageCh;
  String? code;
  dynamic data;

  ApiBaseResponse({
    this.message,
    this.messageKh,
    this.messageCh,
    this.code,
    this.data,
  });

  bool get isSuccess => code == "SUC-000" || code == "200" || code == null;

  factory ApiBaseResponse.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return ApiBaseResponse(data: json);
    }
    return ApiBaseResponse(
      message: json['message'] as String?,
      messageKh: json['messageKh'] as String?,
      messageCh: json['messageCh'] as String?,
      code: json['code']?.toString(),
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['messageKh'] = messageKh;
    map['messageCh'] = messageCh;
    map['code'] = code;
    map['data'] = data;
    return map;
  }
}
