abstract class Failure {
  final String errorMessage;
  const Failure({required this.errorMessage});
}

class ServerFailure extends Failure {
  final dynamic errorData; // To store JSON from API
  
  ServerFailure(this.errorData, {required String errorMessage}) : super(errorMessage: errorMessage);
}