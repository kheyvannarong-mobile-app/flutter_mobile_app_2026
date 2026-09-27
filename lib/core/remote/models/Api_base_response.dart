class ApiBaseResponse {
  ApiBaseResponse({
      this.message, 
      this.messageKh, 
      this.messageCh, 
      this.code, 
      this.data,});

  ApiBaseResponse.fromJson(dynamic json) {
    message = json['message'];
    messageKh = json['messageKh'];
    messageCh = json['messageCh'];
    code = json['code'];
    data = json['data'];
  }
  String? message;
  String? messageKh;
  String? messageCh;
  String? code;
  String? data;

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