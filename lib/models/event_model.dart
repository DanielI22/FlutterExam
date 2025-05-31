import 'package:flutter_exam/constants/app_constants.dart';

class CalendarEvent {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String createdBy;
  final String? color;
  final DateTime createdAt;

  CalendarEvent({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    required this.createdBy,
    this.color,
    required this.createdAt,
  });

  factory CalendarEvent.fromMap(Map<String, dynamic> map, String id) {
    return CalendarEvent(
      id: id,
      title: map[CalendarEventConstants.title],
      description: map[CalendarEventConstants.description],
      startTime: DateTime.parse(map[CalendarEventConstants.startTime]),
      endTime: DateTime.parse(map[CalendarEventConstants.endTime]),
      createdBy: map[CalendarEventConstants.createdBy],
      color: map[CalendarEventConstants.color],
      createdAt: DateTime.parse(map[CalendarEventConstants.createdAt]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      CalendarEventConstants.title: title,
      CalendarEventConstants.description: description,
      CalendarEventConstants.startTime: startTime.toIso8601String(),
      CalendarEventConstants.endTime: endTime.toIso8601String(),
      CalendarEventConstants.createdBy: createdBy,
      CalendarEventConstants.color: color,
      CalendarEventConstants.createdAt: createdAt.toIso8601String(),
    };
  }
}
