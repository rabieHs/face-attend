import 'package:attendence/services/authentication.dart';
import 'package:attendence/services/notification_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/attendance_model.dart';
import '../models/notification_model.dart';
import '../models/student.dart';

class AttendanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get today's attendance for a specific document
  Future<AttendanceModel?> getTodayAttendance() async {
    try {
      final user = await AuthenticationServices().getUser();
      final docId = user.id;
      final docSnapshot =
          await _firestore.collection('attendances').doc(docId).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final List<dynamic> attendances = data['attendences'] ?? [];

        // Find today's attendance entry
        final today = DateTime.now();
        final todayAttendance = attendances.firstWhere(
          (attendance) {
            final date = (attendance['date'] as Timestamp).toDate();
            return date.year == today.year &&
                date.month == today.month &&
                date.day == today.day;
          },
          orElse: () => null,
        );

        if (todayAttendance != null) {
          return AttendanceModel.fromMap(todayAttendance);
        }
      }
    } catch (e) {
      print('Error fetching today\'s attendance: $e');
    }
    return null;
  }
// addStudentToAttendance by invigilatorID and studentID

  Future<void> addStudentToAttendanceByInvigilatorId(
      Student newStudent, String invigilatorID) async {
    try {
      final docSnapshot =
          await _firestore.collection('attendances').doc(invigilatorID).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final List<dynamic> attendances = data['attendences'] ?? [];
        final today = DateTime.now();

        // Check if today's attendance exists
        final todayIndex = attendances.indexWhere((attendance) {
          final date = (attendance['date'] as Timestamp).toDate();
          return date.year == today.year &&
              date.month == today.month &&
              date.day == today.day;
        });

        if (todayIndex != -1) {
          // Update existing attendance
          final todayAttendance = attendances[todayIndex];
          final students = List<Map<String, dynamic>>.from(
              todayAttendance['students'] ?? []);
          students.add(newStudent.toMap());

          todayAttendance['students'] = students;
          attendances[todayIndex] = todayAttendance;

          await _firestore.collection('attendances').doc().update({
            'attendences': attendances,
          });
        } else {
          // Add a new attendance entry for today
          final newAttendance = AttendanceModel(
            date: DateTime.now(),
            students: [newStudent],
          );
          attendances.add(newAttendance.toMap());

          await _firestore.collection('attendances').doc(invigilatorID).update({
            'attendences': attendances,
          });
        }
      } else {
        // If document doesn't exist, create it with today's attendance
        final newAttendance = AttendanceModel(
          date: DateTime.now(),
          students: [newStudent],
        );

        await _firestore.collection('attendances').doc(invigilatorID).set({
          'attendences': [newAttendance.toMap()],
        });
      }
    } catch (e) {
      print('Error adding student to attendance: $e');
    }
  }

  /// Add a student to today's attendance list
  Future<void> addStudentToAttendance(Student newStudent) async {
    try {
      final user = await AuthenticationServices().getUser();
      final docId = user.id;
      final docSnapshot =
          await _firestore.collection('attendances').doc(docId).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final List<dynamic> attendances = data['attendences'] ?? [];
        final today = DateTime.now();

        // Check if today's attendance exists
        final todayIndex = attendances.indexWhere((attendance) {
          final date = (attendance['date'] as Timestamp).toDate();
          return date.year == today.year &&
              date.month == today.month &&
              date.day == today.day;
        });

        if (todayIndex != -1) {
          // Update existing attendance
          final todayAttendance = attendances[todayIndex];
          final students = List<Map<String, dynamic>>.from(
              todayAttendance['students'] ?? []);
          students.add(newStudent.toMap());

          todayAttendance['students'] = students;
          attendances[todayIndex] = todayAttendance;

          await _firestore.collection('attendances').doc(docId).update({
            'attendences': attendances,
          });
        } else {
          // Add a new attendance entry for today
          final newAttendance = AttendanceModel(
            date: DateTime.now(),
            students: [newStudent],
          );
          attendances.add(newAttendance.toMap());

          await _firestore.collection('attendances').doc(docId).update({
            'attendences': attendances,
          });
        }
      } else {
        // If document doesn't exist, create it with today's attendance
        final newAttendance = AttendanceModel(
          date: DateTime.now(),
          students: [newStudent],
        );

        await _firestore.collection('attendances').doc(docId).set({
          'attendences': [newAttendance.toMap()],
        });
      }
    } catch (e) {
      print('Error adding student to attendance: $e');
    }
  }

  /// Update a student's attendance in today's attendance list
  Future<void> updateStudentInAttendance(Student updatedStudent) async {
    try {
      final user = await AuthenticationServices().getUser();
      final docId = user.id;
      final docSnapshot =
          await _firestore.collection('attendances').doc(docId).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final List<dynamic> attendances = data['attendences'] ?? [];
        final today = DateTime.now();

        // Check if today's attendance exists
        final todayIndex = attendances.indexWhere((attendance) {
          final date = (attendance['date'] as Timestamp).toDate();
          return date.year == today.year &&
              date.month == today.month &&
              date.day == today.day;
        });

        if (todayIndex != -1) {
          // Update existing attendance
          final todayAttendance = attendances[todayIndex];
          final students = List<Map<String, dynamic>>.from(
              todayAttendance['students'] ?? []);

          final studentIndex =
              students.indexWhere((s) => s['id'] == updatedStudent.id);
          print("studentIndex: $studentIndex");

          if (studentIndex != -1) {
            print("student index data : ${students[studentIndex]}");
            students[studentIndex] = updatedStudent.toMap();
            todayAttendance['students'] = students;
            attendances[todayIndex] = todayAttendance;

            print("updated attendances $attendances");

            await _firestore.collection('attendances').doc(docId).update({
              'attendences': attendances,
            });
            NotificationServices().SendNotification(NotificationModel(
                userId: updatedStudent.id,
                title: "Attendance Updated",
                description: "Your attendance has been updated"));
          } else {
            print('Student not found in today\'s attendance.');
          }
        } else {
          print('No attendance found for today.');
        }
      }
    } catch (e) {
      print('Error updating student attendance: $e');
    }
  }

  Future<void> markStudentAsPresent(
      String studentId, String invigilatorId) async {
    try {
      // Retrieve the student data using the student ID
      final studentDataSnapshot = await FirebaseFirestore.instance
          .collection('students')
          .doc(studentId)
          .get();

      if (!studentDataSnapshot.exists) {
        print('Error: Student with ID $studentId not found.');
        return;
      }

      print("student data: ${studentDataSnapshot.data()}");

      final student = Student.fromMap(studentDataSnapshot.data()!);

      print("student name: ${student.name}");

      await addStudentToAttendanceByInvigilatorId(
          student.copyWith(attendance: "present"), invigilatorId);

      print(
          'Student ${student.name} marked as present for invigilator $invigilatorId.');
      NotificationServices().SendNotification(NotificationModel(
          userId: studentId,
          title: "Attendance Updated",
          description: "You marked as Present"));
    } catch (e) {
      print('Error marking student as present: $e');
    }
  }
}
