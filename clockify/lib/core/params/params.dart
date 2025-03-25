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
class LoginParams {
  final String email;
  final String password;
  const LoginParams({required this.email, required this.password});
}
class RegisterParams {
  final String email;
  final String password;
  final String confirmPassword;
  const RegisterParams({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}

class ResetPasswordParams {
  final String resetToken;
  final String password;
  final String confirmPassword;
  const ResetPasswordParams({required this.resetToken, required this.password, required this.confirmPassword});
}

class GetAllActivitiesParams {
  final String? description;
  final String choice;
  final double? locationLat;
  final double? locationLng;

  const GetAllActivitiesParams({
    this.description,
    required this.choice,
    this.locationLat,
    this.locationLng,
  });

   Map<String, dynamic> toJson() {
    return {
      'description': description,
      'choice': choice,
      'location_lat': locationLat,
      'location_lng': locationLng,
    };
  }
}
class CreateActivityParams {
  final String description;
  final String startTime;
  final String endTime;
  final double locationLat;
  final double locationLng;

  const CreateActivityParams({
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.locationLat,
    required this.locationLng,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'start_time': startTime,
      'end_time': endTime,
      'location_lat': locationLat,
      'location_lng': locationLng,
    };
  }
}
class UpdateActivityParams{
  final String activityUuid;
  final String description;
  final DateTime startTime;
  final DateTime endTime;

  const UpdateActivityParams({
    required this.activityUuid,
    required this.description,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'uuid': activityUuid,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
    };
  }
}