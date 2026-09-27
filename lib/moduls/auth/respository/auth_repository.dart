import '../../../core/remote/models/register/Register_request.dart';

abstract class AuthRepository {
  Future<bool> login({required String username, required String password});
  Future<bool> register(RegisterRequest request);
}