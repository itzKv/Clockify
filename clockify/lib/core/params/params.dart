class NoParams {}

class UserParams {
  final String id;
  final String email;
  final String password;
  final int verified;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserParams({
    required this.id,
    required this.email,
    required this.password,
    required this.verified,
    required this.createdAt,
    required this.updatedAt,
  });

    // MOCK API
  factory UserParams.fromJson(Map<String, dynamic> json) {
    return UserParams(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      verified: json['verified'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'verified': verified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class MockApiService {
  final List<UserParams> _users = [
    UserParams(
      id: '1',
      email: 'user@example.com',
      password: 'password!123',
      verified: 1,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 2, 1),
    ),
    UserParams(
      id: '2',
      email: 'test@demo.com',
      password: 'securePass!1123',
      verified: 0,
      createdAt: DateTime(2024, 1, 15),
      updatedAt: DateTime(2024, 2, 5),
    ),
  ];

  Future<List<UserParams>> getUsers() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    return _users;
  }

  Future<UserParams?> getUserByEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _users.firstWhere((user) => user.email == email, orElse: () => UserParams(
      id: '',
      email: '',
      password: '',
      verified: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));
  }
}

class LoginParams {
  final String email;
  final String password;
  const LoginParams({required this.email, required this.password});
}

class RegisterParams {
  final String email;
  final String password;
  const RegisterParams({
    required this.email,
    required this.password,
  });
}