import 'package:attendence/firebase_options.dart';
import 'package:attendence/interfaces/invigilator.dart';
import 'package:attendence/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'interfaces/login.dart';
import 'interfaces/student.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FaceAttend App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
            future: AuthenticationServices().getUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('An error occurred'));
              }
              if (snapshot.hasData && snapshot.data != null) {
                if (snapshot.data!.id.startsWith('0')) {
                  return const MyComponent();
                } else if (snapshot.data!.id.startsWith('2')) {
                  return const HomeScreen();
                } else {
                  return const LoginScreen();
                }
              } else {
                return const LoginScreen();
              }
            }));
  }
}
