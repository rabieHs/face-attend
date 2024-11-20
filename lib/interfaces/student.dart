// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:attendence/models/student.dart';
import 'package:flutter/material.dart';

import 'package:attendence/models/user.dart';
import 'package:attendence/services/authentication.dart';

import 'book.dart';
import 'examSch.dart';
import 'login.dart';
import 'notification.dart';
import 'personalInfo.dart';
import 'sendEx.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://cdn.builder.io/api/v1/image/assets/TEMP/66031705f31040ad085179e4e18e0cd0916f3d8c620e74de8bf385d0a90bb4b9?placeholderIfAbsent=true&apiKey=d8f66a03e3a84a08a7b48b30dfb4cd0b'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<Student>(
            future: AuthenticationServices().getStudent(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('An error has occurred!'),
                );
              }
              if (snapshot.hasData && snapshot.data != null) {
                final user = snapshot.data!;
                return SafeArea(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Image.network(
                            'https://cdn.builder.io/api/v1/image/assets/TEMP/0db284d3b3a6899d4cb548de45cbdd371745832a23d5bb86a9a71970b92a7f23?placeholderIfAbsent=true&apiKey=d8f66a03e3a84a08a7b48b30dfb4cd0b',
                            width: 37,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const Spacer(),
                      UserInfoCard(
                        user: user,
                      ),
                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MenuItem(
                            icon:
                                'https://cdn.builder.io/api/v1/image/assets/TEMP/9a7f37965f551bea561852b1cc1036f3130f06191def2c3ba8d11d930f9eaac2?placeholderIfAbsent=true&apiKey=d8f66a03e3a84a08a7b48b30dfb4cd0b',
                            label: 'Personal Info',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfileScreen()),
                              );
                            },
                          ),
                          MenuItem(
                            icon:
                                'https://cdn.builder.io/api/v1/image/assets/TEMP/a188b18a05f1cab422be3a3a2ccd412ef47bffaa93bd5d83537b01f593752012?placeholderIfAbsent=true&apiKey=d8f66a03e3a84a08a7b48b30dfb4cd0b',
                            label: 'Exam Schedule',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ExamSchedule(
                                          majorId: user.major!,
                                        )),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 13),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MenuItem(
                            icon:
                                'https://cdn.builder.io/api/v1/image/assets/TEMP/0803f865b94710bd74455b5464a393d1703058fffab929c17595f039d40a7896?placeholderIfAbsent=true&apiKey=d8f66a03e3a84a08a7b48b30dfb4cd0b',
                            label: 'Send Excuses',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SendPdfComponent()),
                              );
                            },
                          ),
                          MenuItem(
                            icon:
                                'https://cdn.builder.io/api/v1/image/assets/TEMP/3630c1b5d1cf2c462b3c677d23f34099b8e913368c3aad425eb4c70a176114d0?placeholderIfAbsent=true&apiKey=d8f66a03e3a84a08a7b48b30dfb4cd0b',
                            label: 'Notifications',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const NotificationsPage()),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Log Out',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}

class UserInfoCard extends StatelessWidget {
  final Student user;
  const UserInfoCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
                'https://cdn.builder.io/api/v1/image/assets/TEMP/d9f2b8c80d238c276c0cc4ffd91976fcf709edcec368feaf218e7b37b262fc4e?placeholderIfAbsent=true&apiKey=d8f66a03e3a84a08a7b48b30dfb4cd0b'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  user.id,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'الأذكار',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 239, 149, 116),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookInterface()),
                        );
                      },
                      child: Image.asset(
                        'assets/images/book.webp',
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback? onTap;

  const MenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 145,
        height: 145,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 4,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Image.network(
                  icon,
                  width: 35,
                  height: 35,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
