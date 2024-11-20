import 'package:flutter/foundation.dart';

class Schedule {
  final String date;
  final String day;
  final String time;
  final String courseNumber;
  final String courseName;
  final String building;
  final String room;

  Schedule({
    required this.date,
    required this.day,
    required this.time,
    required this.courseNumber,
    required this.courseName,
    required this.building,
    required this.room,
  });

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      date: map['date'] as String,
      day: map['day'] as String,
      time: map['time'] as String,
      courseNumber: map['courseNumber'] as String,
      courseName: map['courseName'] as String,
      building: map['building'] as String,
      room: map['room'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'day': day,
      'time': time,
      'courseNumber': courseNumber,
      'courseName': courseName,
      'building': building,
      'room': room,
    };
  }
}

class MajorSchedule {
  final String majorName;
  final List<Schedule> schedules;

  MajorSchedule({
    required this.majorName,
    required this.schedules,
  });

  factory MajorSchedule.fromMap(Map<String, dynamic> map) {
    var schedulesList = map['schedule'] as List;
    return MajorSchedule(
      majorName: map['majorName'] as String,
      schedules: schedulesList
          .map((e) => Schedule.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'majorName': majorName,
      'schedule': schedules.map((e) => e.toMap()).toList(),
    };
  }
}
