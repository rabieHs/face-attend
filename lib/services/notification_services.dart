import 'package:attendence/models/notification_model.dart';
import 'package:attendence/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationServices {
  static Future<List<NotificationModel>> getUserNotifications() async {
    try {
      final user = await AuthenticationServices().getUser();
      final query = await FirebaseFirestore.instance
          .collection("notifications")
          .where("userId", isEqualTo: user.id)
          .get();
      return query.docs
          .map((doc) => NotificationModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print(e);
      throw Exception("No Notifications Found");
    }
  }

  Future<void> SendNotification(NotificationModel notification) async {
    try {
      await FirebaseFirestore.instance.collection("notifications").add(
            notification.toMap(),
          );
    } catch (e) {
      print(e);
      throw Exception("Failed to send notification");
    }
  }
}
