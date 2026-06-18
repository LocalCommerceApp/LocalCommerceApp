class UserEntity {
  final String id;
  final String email;
  final String role;
  final String name;
  final String businessName;
  final String phone;
  final String? accessToken;
  final String? refreshToken;

  UserEntity({
    required this.id,
    required this.email,
    required this.role,
    this.name = '',
    this.businessName = '',
    this.phone = '',
    this.accessToken,
    this.refreshToken,
  });
}
