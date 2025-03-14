class UserModel {
  final String uuid;
  final String email;

  UserModel({
    required this.uuid,
    required this.email,
  });

  factory UserModel.fromJson({ required Map<String, dynamic> json }) {
    return UserModel(
      uuid: json['uuid'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'email': email,
    };
  }
}