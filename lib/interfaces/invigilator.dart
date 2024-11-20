import 'package:attendence/models/invigilator_model.dart';
import 'package:attendence/services/authentication.dart';
import 'package:flutter/material.dart';
import 'attendList.dart'; // Import the attendance widget
import 'invigilatorSch.dart'; // Import the ScheduleWidget
import 'notInvigilator.dart'; // Import the notifications page
import 'login.dart'; // Import your existing LoginScreen

class MyComponent extends StatelessWidget {
  const MyComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<InvigilatorModel>(
          future: AuthenticationServices().getInvigilator(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('An error occurred'));
            }
            if (snapshot.hasData && snapshot.data != null) {
              final invigilator = snapshot.data!;
              return Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://cdn.builder.io/api/v1/image/assets/TEMP/66031705f31040ad085179e4e18e0cd0916f3d8c620e74de8bf385d0a90bb4b9?placeholderIfAbsent=true&apiKey=d8f66a03e3a84a08a7b48b30dfb4cd0b'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Image.network(
                            'https://cdn.builder.io/api/v1/image/assets/TEMP/cf8c4da72ebe7f58dbc77a309b54dd879a1d64a33bccba14a622b0720a4882c0?placeholderIfAbsent=true&apiKey=d8f66a03e3a84a08a7b48b30dfb4cd0b',
                            width: 37,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const Spacer(),
                      ProfileCard(
                        name: invigilator.name,
                        id: invigilator.id,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DashboardItem(
                            icon:
                                'https://cdn.builder.io/api/v1/image/assets/TEMP/7ca90565e30947640542a57973c1f211e61de7fdd324dbc52b3ba3833b426015?placeholderIfAbsent=true&apiKey=d8f66a03e3a84a08a7b48b30dfb4cd0b',
                            label: 'Attend List',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AttendanceWidget()),
                              );
                            },
                          ),
                          const SizedBox(width: 32),
                          DashboardItem(
                            icon:
                                'https://cdn.builder.io/api/v1/image/assets/TEMP/a188b18a05f1cab422be3a3a2ccd412ef47bffaa93bd5d83537b01f593752012?placeholderIfAbsent=true&apiKey=d8f66a03e3a84a08a7b48b30dfb4cd0b',
                            label: 'Schedule',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ScheduleWidget()),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 13),
                      DashboardItem(
                        icon:
                            'https://cdn.builder.io/api/v1/image/assets/TEMP/3630c1b5d1cf2c462b3c677d23f34099b8e913368c3aad425eb4c70a176114d0?placeholderIfAbsent=true&apiKey=d8f66a03e3a84a08a7b48b30dfb4cd0b',
                        label: 'Notifications',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const InvigilatorNotificationsPage()),
                          );
                        },
                      ),
                      const SizedBox(height: 22),

                      // Simple Log Out Button
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.red, // Change color as needed
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 8),
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
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String name;
  final String id;

  const ProfileCard({
    super.key,
    required this.name,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 65, vertical: 18),
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
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 29),
          Text(
            id,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardItem extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback? onTap;

  const DashboardItem({
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
        padding: const EdgeInsets.all(20),
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
            const SizedBox(height: 11),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
