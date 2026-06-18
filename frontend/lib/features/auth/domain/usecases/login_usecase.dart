import '../entities/user_entity.dart';
import '../repositories/i_auth_repository.dart';

class LoginUseCase {
  final IAuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity> call(String email, String password, String role) {
    return repository.login(email, password, role);
  }
}
