class ConstantUri {
  ConstantUri._();
  static const baseUri = "http://localhost:30033";
  static const loginPath = "$baseUri/api/oauth/token";
  static const registerPath = "$baseUri/api/oauth/register";
}
