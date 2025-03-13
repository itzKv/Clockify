
class RegisterUserResponse {
  final String status;
  final String? message;
  final UserData? user;
  final String? emailToken;
  final Map<String, ErrorDetail>? errors;

  RegisterUserResponse({
    required this.status,
    this.message,
    this.user,
    this.emailToken,
    this.errors
  });

  factory RegisterUserResponse.fromJson(Map<String, dynamic> json) {
    if (json["status"] == "success") {
      return RegisterUserResponse(
        status: json['status'],
        message: json['message'],
        user: json['user'] != null ? UserData.fromJson(json['user']) : null,
        emailToken: json['emailToken'],
      );
    } else {
      return RegisterUserResponse(
        status: json['status'],
        errors: (json['errors'] as Map<String, dynamic>?)?.map(
          (key, value) => MapEntry(key, ErrorDetail.fromJson(value))
        )
      );
    }
  }

}


class UserData {
  final String uuid;
  final String email;

  UserData({required this.uuid, required this.email});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      uuid: json["uuid"],
      email: json["email"],
    );
  }
}


class ErrorDetail {
  final String type;
  final String value;
  final String msg;
  final String path;
  final String location;

  ErrorDetail({
    required this.type,
    required this.value,
    required this.msg,
    required this.path, 
    required this.location,
  });

  factory ErrorDetail.fromJson(Map<String, dynamic> json) {
    return ErrorDetail(
      type: json['type'], 
      value: json['value'], 
      msg: json['msg'], 
      path: json['path'], 
      location: json['location'], 
    );
  }
}