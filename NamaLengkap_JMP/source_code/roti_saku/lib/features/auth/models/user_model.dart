/// lib/features/auth/models/user_model.dart

class UserModel {
  final String id;
  final String name;
  final String role; // 'admin' or 'customer'

  UserModel({
    required this.id,
    required this.name,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      role: map['role'] as String,
    );
  }
}