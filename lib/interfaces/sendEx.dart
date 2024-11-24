import 'dart:io';
import 'package:attendence/services/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../models/notification_model.dart';
import '../services/authentication.dart';

class SendPdfComponent extends StatefulWidget {
  const SendPdfComponent({super.key});

  @override
  _SendPdfComponentState createState() => _SendPdfComponentState();
}

class _SendPdfComponentState extends State<SendPdfComponent> {
  File? _selectedFile;
  final TextEditingController _receiverEmailController =
      TextEditingController();
  String _message = '';

  String? _userName;
  String? _universityId;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails(); // Fetch user details when the screen is loaded
  }

  Future<void> _fetchUserDetails() async {
    final user = await AuthenticationServices()
        .getUser(); // Assuming this function fetches user data
    setState(() {
      _userName = user.name; // Set user name
      _universityId = user.id; // Set user university ID
    });
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _message = ''; // Clear any previous messages
      });
    }
  }

  Future<void> _sendEmail() async {
    if (_receiverEmailController.text.isNotEmpty && _selectedFile != null) {
      final String formalLetter = '''
Dear Instructor,

I am sending you this letter to inform you that I will not be able to attend the class due to [Reason]. 
Please find the attached document explaining the situation.

Thank you for your understanding.

Sincerely,
$_userName
University ID: $_universityId
''';

      final Email email = Email(
        body: formalLetter,
        subject: 'Excuse for Absence',
        recipients: [_receiverEmailController.text],
        attachmentPaths: [_selectedFile!.path],
        isHTML: false,
      );

      try {
        await FlutterEmailSender.send(email);

        setState(() {
          _message =
              'Email sent successfully to ${_receiverEmailController.text}';
        });
        NotificationServices().SendNotification(NotificationModel(
            userId: _universityId!,
            title: "Absence Excuse Recived",
            description: "one of the student has sent an excuse for absence"));
      } catch (error) {
        setState(() {
          _message = 'Failed to send email: $error';
        });
      }
    } else {
      setState(() {
        _message = 'Please enter the receiver\'s email and upload a file.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://cdn.builder.io/api/v1/image/assets/TEMP/bdea58451f0af00e4a865c2c054a0e4c068b997f8cdde43ffbcefac0ff2c6206?placeholderIfAbsent=true&apiKey=d8f66a03e3a84a08a7b48b30dfb4cd0b',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 200),
                const Text('Submit Excuse Document',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                // Display sender's email (fetched dynamically)
                if (_userName != null && _universityId != null) ...[
                  Text('Your Name: $_userName',
                      style: const TextStyle(fontSize: 16)),
                  Text('University ID: $_universityId',
                      style: const TextStyle(fontSize: 16)),
                ],
                const SizedBox(height: 10),
                TextField(
                  controller: _receiverEmailController,
                  decoration: const InputDecoration(
                    labelText: 'Receiver\'s Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: _pickFile,
                      child: const Text('Upload PDF'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _sendEmail,
                      child: const Text('Send Email'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (_message.isNotEmpty)
                  Text(
                    _message,
                    style: TextStyle(
                        color: _message.contains('successfully')
                            ? Colors.green
                            : Colors.red),
                  ),
                if (_selectedFile != null)
                  Text(
                    'Selected File: ${_selectedFile!.path.split('/').last}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Go Back'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
