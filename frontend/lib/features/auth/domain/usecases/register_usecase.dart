import '../entities/user_entity.dart';
import '../repositories/i_auth_repository.dart';

class RegisterUseCase {
  final IAuthRepository repository;

  RegisterUseCase(this.repository);

  Future<UserEntity> call(Map<String, dynamic> userData) {
    return repository.register(userData);
  }
}
