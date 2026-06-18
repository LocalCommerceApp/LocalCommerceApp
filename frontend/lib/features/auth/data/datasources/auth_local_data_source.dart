import '../../../../core/cache/cache_manager.dart';
import '../user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);
  UserModel? getCachedUser();
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<void> saveUser(UserModel user) async {
    await CacheManager.saveUser(user.toJson());
  }

  @override
  UserModel? getCachedUser() {
    final data = CacheManager.getUser();
    return data != null ? UserModel.fromJson(data) : null;
  }

  @override
  Future<void> clearCache() async {
    await CacheManager.clearAll();
  }
}
