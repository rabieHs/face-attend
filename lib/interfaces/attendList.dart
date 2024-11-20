import 'package:attendence/models/attendance_model.dart';
import 'package:attendence/services/attendance_services.dart';
import 'package:flutter/material.dart';

import '../models/student.dart';

class AttendanceWidget extends StatefulWidget {
  const AttendanceWidget({super.key});

  @override
  _AttendanceWidgetState createState() => _AttendanceWidgetState();
}

class _AttendanceWidgetState extends State<AttendanceWidget> {
  final ScrollController _scrollController = ScrollController();

  void _editStudent(
    Student? student,
  ) {
    final nameController = TextEditingController();
    final idController = TextEditingController();
    final attendanceController = TextEditingController();

    if (student != null) {
      nameController.text = student.name;
      idController.text = student.id;
      attendanceController.text = student.attendance;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(student == null ? 'Add Student' : 'Edit Student'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name')),
              TextField(
                  controller: idController,
                  decoration: const InputDecoration(labelText: 'ID')),
              TextField(
                  controller: attendanceController,
                  decoration: const InputDecoration(labelText: 'Attendance')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final newStudent = Student(
                    name: nameController.text,
                    id: idController.text,
                    attendance: attendanceController.text);

                if (student == null) {
                  // add student

                  try {
                    AttendanceService()
                        .addStudentToAttendance(newStudent)
                        .whenComplete(() {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Student added successfully'),
                        ),
                      );
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to add student'),
                      ),
                    );
                  }
                } else {
                  try {
                    AttendanceService()
                        .updateStudentInAttendance(newStudent)
                        .whenComplete(() {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Student updated successfully'),
                        ),
                      );
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to update student'),
                      ),
                    );
                  }
                  // update selected student
                }

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _goBack() {
    Navigator.pop(
        context); // Replace with the actual route to the invigilator page if necessary
  }

  void _scrollUp() {
    _scrollController.animateTo(
      _scrollController.offset - 100, // Scroll up by 100 pixels
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.offset + 100, // Scroll down by 100 pixels
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    print(DateTime.now().toString());
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://cdn.builder.io/api/v1/image/assets/TEMP/aca53e1bc98323339b64ae74609abf942dae82d276b147a6efe2a30e7de88671?placeholderIfAbsent=true&apiKey=d8f66a03e3a84a08a7b48b30dfb4cd0b'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: RefreshIndicator(
            onRefresh: () async {
              await AttendanceService().getTodayAttendance();
              setState(() {});
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                    height:
                        350), // Increased space to push the table further down
                FutureBuilder<AttendanceModel?>(
                    future: AttendanceService().getTodayAttendance(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(child: Text('An error occurred'));
                      }
                      if (snapshot.hasData && snapshot.data != null) {
                        final students = snapshot.data!.students;
                        print("students: $students");
                        return Container(
                          padding: const EdgeInsets.all(13),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text('NAME',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  Expanded(
                                      child: Text('ID',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  Expanded(
                                      child: Text('ATTENDANCE',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                ],
                              ),
                              const SizedBox(
                                  height: 8), // Space between header and table
                              SizedBox(
                                height: 150, // Set a fixed height for the table
                                child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: students.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 6),
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: const Color(0xFFEAECF0)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              _editStudent(students[index]);
                                              setState(() {});
                                            },
                                            child: Text(
                                              students[index].name,
                                              style: const TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Text(students[index].id),
                                          Text(students[index].attendance),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_upward),
                                    onPressed: _scrollUp,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.arrow_downward),
                                    onPressed: _scrollDown,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _editStudent(null),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8E8E93),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                      ),
                      child: const Text(
                        'Add Student',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _goBack,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8E8E93),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
