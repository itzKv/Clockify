
class ResetPasswordResponse {
  final String status;
  final String? message;
  final String? loginToken;
  final String? errors;


  ResetPasswordResponse({
    required this.status,
    this.message,
    this.loginToken,
    this.errors,
  });

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(
      status: json['status'] ?? "", 
      message: json.containsKey('message') ? json['message'] : "",
      loginToken: json.containsKey('loginToken') ? json['loginToken'] : "",
      errors: json.containsKey('errors') ? json['errors']['message'] : null
    );
  }
}