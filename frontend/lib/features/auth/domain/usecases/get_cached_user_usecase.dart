import '../entities/user_entity.dart';
import '../repositories/i_auth_repository.dart';

class GetCachedUserUseCase {
  final IAuthRepository repository;

  GetCachedUserUseCase(this.repository);

  UserEntity? call() {
    return repository.getCachedUser();
  }
}
