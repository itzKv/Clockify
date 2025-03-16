class DeleteActivityResponse {
  final String status;
  final String message;

  DeleteActivityResponse({
    required this.status,
    required this.message,
  });

  factory DeleteActivityResponse.fromJson(Map<String, dynamic> json) {
    return DeleteActivityResponse(
      status: json['status'], 
      message: json['message'],
    );
  }
}