import 'package:attendence/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/attendance_model.dart';
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
}
