import 'dart:convert';
import 'dart:io';

import 'package:attendence/services/attendance_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  String invigilatorId = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      await _requestPermissions();

      // Get available cameras
      final cameras = await availableCameras();

      // Select front camera
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () =>
            cameras.first, // Fallback to the first camera if no front camera
      );

      // Initialize the camera controller
      _controller = CameraController(
        frontCamera,
        ResolutionPreset.high, // Set high resolution for better clarity
      );

      // Initialize the controller
      _initializeControllerFuture = _controller.initialize();
      await _initializeControllerFuture;
      setState(() {});
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      print('Error initializing camera: $e');
    }
  }

  Future<void> _requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    if (cameraStatus != PermissionStatus.granted) {
      throw Exception('Camera permission not granted');
    }
    final storageStatus = await Permission.storage.request();
    if (storageStatus != PermissionStatus.granted) {
      throw Exception('Storage permission not granted');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> takePicture(BuildContext context) async {
    if (invigilatorId == '') {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter Invigilator ID'),
            content: TextField(
              onChanged: (value) {
                invigilatorId = value;
              },
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    } else {
      print("Invigilator ID: $invigilatorId");
      try {
        await _initializeControllerFuture;

        // Capture the image
        final image = await _controller.takePicture();

        // Convert the image to base64
        final imageBytes = await image.readAsBytes();
        final base64Image = base64Encode(imageBytes);

        // Send the base64 image to the Flask server
        await _sendImageToServer(base64Image, context);
      } catch (e) {
        print('Error taking picture: $e');
      }
    }
  }

  Future<void> _sendImageToServer(
      String base64Image, BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });
    const serverUrl =
        'http://192.168.159.234:5000/recognize_face'; // Replace with your Device IP (IPv4)
    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image': base64Image}),
      );

      if (response.statusCode == 200) {
        //Display the response body and save the person  it on string
        final person = jsonDecode(response.body)['person'];
        try {
          await AttendanceService()
              .markStudentAsPresent(person, invigilatorId)
              .then((value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                    'Student $person marked as present for invigilator $invigilatorId.'),
              ),
            );
          });
          Navigator.pop(context);
        } catch (e) {
          Navigator.pop(context);
          print('Error student not recognized : $e');
        }
      } else {
        Navigator.pop(context);

        print('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      Navigator.pop(context);

      print('Error sending image to server: $e');
    }
  }

  Future<void> pickImage(BuildContext context) async {
    if (invigilatorId == "") {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter Invigilator ID'),
            content: TextField(
              onChanged: (value) {
                invigilatorId = value;
              },
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    }
    final image = await FilePicker.platform
        .pickFiles(type: FileType.image)
        .then((file) async {
      if (file != null) {
        final image = file.xFiles.first;
        final imageBytes = await image.readAsBytes();
        final base64Image = base64Encode(imageBytes);

        print("base64Image: $base64Image");
        await _sendImageToServer(base64Image, context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera')),
      body: _errorMessage != null
          ? Center(child: Text('Error: $_errorMessage'))
          : FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller);
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => //pickImage(context),
            takePicture(context),
        child: const Icon(Icons.camera),
      ),
    );
  }
}
