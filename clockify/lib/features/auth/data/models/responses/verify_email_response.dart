
class VerifyEmailResponse {
  final String status;
  final String message;

  VerifyEmailResponse({
    required this.status,
    required this.message,
  });

  factory VerifyEmailResponse.fromJson(Map<String, dynamic> json) {
    return VerifyEmailResponse(
      status: json['status'] ?? "", 
      message: json['message'] ?? "",
    );
  }
}