class UserModel {
  final String id;
  final String email;

  UserModel({
    required this.id,
    required this.email,
  });

  factory UserModel.fromJson({ required Map<String, dynamic> json }) {
    return UserModel(
      id: json['user']['uuid'] as String,
      email: json['user']['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
    };
  }
}