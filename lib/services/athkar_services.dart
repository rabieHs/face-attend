import 'package:attendence/models/athkar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AthkarServices {
  static Future<List<Athkar>> fetchAthkars() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('athkar').get();
      for (var doc in snapshot.docs) {
        print(doc.data());
      }
      return snapshot.docs.map((doc) => Athkar.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception('Error fetching athkars: $e');
    }
  }
}
