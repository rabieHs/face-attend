import 'package:cloud_firestore/cloud_firestore.dart';

class InvigilatorSchedule {
  final String building;
  final DateTime date;
  final String name;
  final String room;
  final int students;
  final String time;

  InvigilatorSchedule({
    required this.building,
    required this.date,
    required this.name,
    required this.room,
    required this.students,
    required this.time,
  });

  // Factory method to create an instance from Firestore data
  factory InvigilatorSchedule.fromMap(Map<String, dynamic> data) {
    return InvigilatorSchedule(
      building: data['building'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      name: data['name'] ?? '',
      room: data['room'] ?? '',
      students: data['students'] ?? 0,
      time: data['time'] ?? '',
    );
  }
}
