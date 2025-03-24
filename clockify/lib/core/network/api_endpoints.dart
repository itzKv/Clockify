class ApiEndpoints {
  static const String baseUrl = "https://cb52-2001-448a-90e0-210c-ed99-1d77-3f1f-343.ngrok-free.app/api/v1";
  static const String login = "$baseUrl/user/login";
  static const String register = "$baseUrl/user/register";
  static const String verifyEmail = "$baseUrl/user/verifyemail";
  static const String forgotPassword = "$baseUrl/user/forgotpassword";
  static const String createActivity = "$baseUrl/activity";
  static const String getAllActivities = "$baseUrl/activity";
  static const String deleteActivity = "$baseUrl/activity";
  static const String updateActivity = "$baseUrl/activity";
}