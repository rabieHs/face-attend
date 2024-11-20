import 'package:attendence/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/invigilator_schedule_model.dart';
import '../models/schedule.dart';

class SchedulesServices {
  static Future<MajorSchedule?> fetchMajorSchedule(String majorId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('schedules')
          .doc(majorId)
          .get();

      if (docSnapshot.exists) {
        return MajorSchedule.fromMap(docSnapshot.data()!);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching schedule: $e');
      return null;
    }
  }

  Future<List<InvigilatorSchedule>> fetchInvigilatorSchedule() async {
    final user = await AuthenticationServices().getUser();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      // Access the collection
      DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.collection('invigilatorSchedule').doc(user.id).get();

      if (doc.exists && doc.data() != null) {
        List<dynamic> scheduleData = doc.data()?['schedule'] ?? [];
        return scheduleData
            .map((data) => InvigilatorSchedule.fromMap(data))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching schedule: $e');
      return [];
    }
  }
}
