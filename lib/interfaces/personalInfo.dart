import 'package:attendence/models/student.dart';
import 'package:flutter/material.dart';

import '../services/authentication.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          //constraints: const BoxConstraints(maxWidth: 360), // Match the width of LoginScreen
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 0.6,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ProfileBackgroundImage(), // Background image
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 260, 25, 25), //
                      child: ProfileForm(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileBackgroundImage extends StatelessWidget {
  const ProfileBackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://cdn.builder.io/api/v1/image/assets/TEMP/e6ea7246def45990d98b648dc206e9fe5a0bcd3500038f3eef1e39a2fb443c9f?placeholderIfAbsent=true&apiKey=d8f66a03e3a84a08a7b48b30dfb4cd0b',
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[300],
          child: const Center(
            child: Icon(Icons.error, color: Colors.red),
          ),
        );
      },
    );
  }
}

class ProfileForm extends StatelessWidget {
  const ProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Student>(
        future: AuthenticationServices().getStudent(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.hasData && snapshot.data != null) {
            final student = snapshot.data!;
            return Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFixedField('Full Name', student.name),
                  const SizedBox(height: 6),
                  _buildFixedField('University ID', student.id),
                  const SizedBox(height: 6),
                  _buildFixedField('Major', student.major!),
                  const SizedBox(height: 6),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Go back on button press
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8E8E93),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 65, vertical: 9),
                        minimumSize: const Size(220, 0),
                      ),
                      child: const Text('Back',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _buildFixedField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 2,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: TextFormField(
            initialValue: value,
            readOnly: true, // Make the field uneditable
            decoration: InputDecoration(
              hintText: 'Type here',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
