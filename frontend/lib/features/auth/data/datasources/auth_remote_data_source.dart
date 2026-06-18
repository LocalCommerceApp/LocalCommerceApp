import '../../../../core/network/api_client.dart';
import '../user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password, String role);
  Future<UserModel> register(Map<String, dynamic> userData);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<UserModel> login(String email, String password, String role) async {
    final response = await apiClient.post('/auth/login', {
      'email': email,
      'password': password,
      'role': role,
    });
    return UserModel.fromJson(response);
  }

  @override
  Future<UserModel> register(Map<String, dynamic> userData) async {
    final response = await apiClient.post('/auth/register', userData);
    return UserModel.fromJson(response);
  }
}
