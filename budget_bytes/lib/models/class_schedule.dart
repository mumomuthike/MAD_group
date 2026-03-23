// lib/models/class_schedule.dart
class ClassSchedule {
  final int? id;
  final int userId;
  final String className;
  final String location;
  final String daysOfWeek;  // e.g. "Mon,Wed,Fri"
  final String startTime;   // "09:00"
  final String endTime;     // "10:15"

  ClassSchedule({
    this.id,
    required this.userId,
    required this.className,
    required this.location,
    required this.daysOfWeek,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toMap() => {
    'class_id': id,
    'user_id': userId,
    'class_name': className,
    'location': location,
    'days_of_week': daysOfWeek,
    'start_time': startTime,
    'end_time': endTime,
  };

  factory ClassSchedule.fromMap(Map<String, dynamic> map) => ClassSchedule(
    id: map['class_id'],
    userId: map['user_id'],
    className: map['class_name'],
    location: map['location'],
    daysOfWeek: map['days_of_week'],
    startTime: map['start_time'],
    endTime: map['end_time'],
  );

  // Helper: minutes between end of class and next class start
  int minutesUntilNext(ClassSchedule next) {
    final end = _toMinutes(endTime);
    final start = _toMinutes(next.startTime);
    return start - end;
  }

  int _toMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}