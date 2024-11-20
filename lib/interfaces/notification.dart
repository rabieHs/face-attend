import 'dart:math';

import 'package:attendence/models/notification_model.dart';
import 'package:attendence/services/notification_services.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      'Exam: Computer Networks on 01/10/2024 at 08:00-10:00 in Building 11, Room 11',
      'Exam: Deep Learning on 03/10/2024 at 10:00-12:00 in Building 11, Room 7',
      'Exam: Computer Vision on 06/10/2024 at 08:00-12:00 in Building 11, Room 21',
      'Exam: Recommendation System on 07/10/2024 at 13:00-15:00 in Building 11, Room 3',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<NotificationModel>>(
            future: NotificationServices.getUserNotifications(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else if (snapshot.hasData && snapshot.data != null) {
                final notifications = snapshot.data!;
                return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(
                          notifications[index].title,
                          style: const TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(notifications[index].description),
                        leading: const Icon(Icons.notifications),
                        trailing: const Icon(Icons.arrow_forward),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}

class MyComponent extends StatelessWidget {
  const MyComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: NetworkImage(
              'https://cdn.builder.io/api/v1/image/assets/TEMP/847699dbea23933644c0787d70e5ea1a4ada00dfbc825f35c5af70e3299d1376?placeholderIfAbsent=true&apiKey=d8f66a03e3a84a08a7b48b30dfb4cd0b'),
          fit: BoxFit.cover,
        ),
      ),
      child: AspectRatio(
        aspectRatio: 0.557,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 374),
          padding: const EdgeInsets.fromLTRB(75, 8, 10, 57),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Image.network(
                'https://cdn.builder.io/api/v1/image/assets/TEMP/0db284d3b3a6899d4cb548de45cbdd371745832a23d5bb86a9a71970b92a7f23?placeholderIfAbsent=true&apiKey=d8f66a03e3a84a08a7b48b30dfb4cd0b',
                width: 37,
                fit: BoxFit.contain,
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to notifications page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationsPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8E8E93),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.fromLTRB(65, 10, 65, 20),
                    minimumSize: const Size(164, 0),
                    elevation: 2,
                    shadowColor: Colors.black.withOpacity(0.25),
                  ),
                  child: const Text(
                    'View Notifications',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
