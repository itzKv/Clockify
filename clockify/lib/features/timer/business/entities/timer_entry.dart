class TimerEntry {
  final DateTime? startTime;
  final DateTime? endTime;
  final String description;

  TimerEntry({
    this.startTime,
    this.endTime,
    required this.description,
  });
}