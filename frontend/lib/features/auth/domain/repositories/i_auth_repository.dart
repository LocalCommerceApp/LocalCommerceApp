import '../entities/user_entity.dart';

abstract class IAuthRepository {
  Future<UserEntity> login(String email, String password, String role);
  Future<UserEntity> register(Map<String, dynamic> userData);
  UserEntity? getCachedUser();
}
