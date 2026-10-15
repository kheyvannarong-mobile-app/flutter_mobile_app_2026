class ForgotPasswordRequest {
  String? phoneNumber;
  String? deviceId;
  String? otp;
  String? oldPassword;
  String? password;
  String? confirmPassword;

  ForgotPasswordRequest({
    this.phoneNumber,
    this.deviceId,
    this.otp,
    this.oldPassword,
    this.password,
    this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (deviceId != null) 'deviceId': deviceId,
      if (otp != null) 'otp': otp,
      if (oldPassword != null) 'oldPassword': oldPassword,
      if (password != null) 'password': password,
      if (confirmPassword != null) 'confirmPassword': confirmPassword,
    };
  }
}

class ChangePasswordRequest {
  String oldPassword;
  String password;
  String confirmPassword;

  ChangePasswordRequest({
    required this.oldPassword,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'oldPassword': oldPassword,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}
