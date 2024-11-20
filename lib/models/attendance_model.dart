// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:attendence/models/student.dart';

class AttendanceModel {
  final DateTime date;
  final List<Student> students;

  AttendanceModel({
    required this.date,
    required this.students,
  });

  // Factory method to create an AttendanceModel from a map
  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      date: (map['date'] as Timestamp).toDate(),
      students: (map['students'] as List<dynamic>)
          .map((studentMap) => Student.fromMap(studentMap))
          .toList(),
    );
  }

  // Convert AttendanceModel to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'students': students.map((student) => student.toMap()).toList(),
    };
  }

  AttendanceModel copyWith({
    DateTime? date,
    List<Student>? students,
  }) {
    return AttendanceModel(
      date: date ?? this.date,
      students: students ?? this.students,
    );
  }
}
