import 'package:attendence/models/invigilator_model.dart';
import 'package:attendence/models/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../models/user.dart';

class AuthenticationServices {
  final auth = fb.FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  Future<bool> loginUser(String universityId, String password) async {
    try {
      final result = await auth.signInWithEmailAndPassword(
        email: universityId + "@faceattend.com",
        password: password,
      );
      if (result.user != null) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<User> getUser() async {
    final user = auth.currentUser;
    if (user != null) {
      final userData = await db.collection('users').doc(user.uid).get();
      return User.fromMap(userData.data() as Map<String, dynamic>);
    } else {
      throw Exception('User not found');
    }
  }

  Future<Student> getStudent() async {
    final currentUser = auth.currentUser;
    final user = await getUser();
    if (user != null) {
      print(user.id);
      final userData = await db.collection('students').doc(user.id).get();

      if (userData.data() == null) {
        throw Exception('User not found');
      } else {
        return Student.fromMap(userData.data() as Map<String, dynamic>);
      }
    } else {
      throw Exception('User not found');
    }
  }

  Future<InvigilatorModel> getInvigilator() async {
    final currentUser = auth.currentUser;
    if (currentUser != null) {
      final user = await getUser();

      final userData = await db.collection('invigilator').doc(user.id).get();
      print(userData.data());

      return InvigilatorModel.fromMap(userData.data() as Map<String, dynamic>);
    } else {
      throw Exception('User not found');
    }
  }

  Future<void> logout() async {
    await auth.signOut();
  }
}
