
class ForgotPasswordResponse {
  final String status;
  final String? message;
  final String? errors;


  ForgotPasswordResponse({
    required this.status,
    this.message,
    this.errors,
  });

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      status: json['status'] ?? "", 
      message: json.containsKey('message') ? json['message'] : "",
      errors: json.containsKey('errors') ? json['errors']['message'] : null
    );
  }
}