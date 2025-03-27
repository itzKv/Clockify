import 'package:clockify/core/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:uuid/uuid.dart';

class TimerProvider extends ChangeNotifier {
  final StopWatchTimer stopWatchTimer = StopWatchTimer();
  final TextEditingController descriptionController = TextEditingController();
  final Uuid _uuid = Uuid();

  bool _isTimerStarted = false;
  bool _isTimerStopped = false;
  DateTime? _startTime;
  DateTime? _endTime;
  double? _locationLat;
  double? _locationLng;
  String _locationAddress = "Fetching location ...";

  bool get isTimerStarted => _isTimerStarted;
  bool get isTimerStopped => _isTimerStopped;
  DateTime? get startTime => _startTime;
  DateTime? get endTime => _endTime;
  double? get locationLat => _locationLat;
  double? get locationLng => _locationLng;
   String get locationAddress => _locationAddress;


  void startTimer() {
    stopWatchTimer.onResetTimer();
    stopWatchTimer.onStartTimer();
    _isTimerStarted = true;
    _startTime = DateTime.now();
    notifyListeners();
  }

  void stopTimer() {
    stopWatchTimer.onStopTimer();
    _isTimerStopped = true;
    _endTime = DateTime.now();
    notifyListeners();
  }

  void resetTimer() {
    stopWatchTimer.onResetTimer();
    _isTimerStarted = false;
    _isTimerStopped = false;
    _startTime = null;
    _endTime = null;
    descriptionController.text = "";
    notifyListeners();
  }

  void setLocation(double lat, double lng) {
    _locationLat = lat;
    _locationLng = lng;
    notifyListeners();
  }

  String generateUuid() {
    return _uuid.v4();
  }

  Future<void> fetchLocation() async {
    try {
      Position position = await LocationService().getCurrentPosition();
      _locationLat = position.latitude;
      _locationLng = position.longitude;
      _locationAddress = '$_locationLat , $_locationLng';
      notifyListeners();
    } catch (e) {
      _locationAddress = 'Error: $e';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    stopWatchTimer.dispose();
    super.dispose();
  }
}
