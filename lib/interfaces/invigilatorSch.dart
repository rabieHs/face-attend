import 'package:flutter/material.dart';

import '../models/invigilator_schedule_model.dart';
import '../services/scedules_services.dart';

class ScheduleWidget extends StatefulWidget {
  const ScheduleWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ScheduleWidget> createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
  List<InvigilatorSchedule>? invigilatorAssignments;

  @override
  void initState() {
    super.initState();
    loadSchedule();
  }

  Future<void> loadSchedule() async {
    final assignments = await SchedulesServices().fetchInvigilatorSchedule();
    setState(() {
      invigilatorAssignments = assignments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: NetworkImage(
                'https://cdn.builder.io/api/v1/image/assets/TEMP/ebc4f48515ef837df4485123c35862a664f30d93f26eec9c1c0544c54e8a27e2?placeholderIfAbsent=true&apiKey=d8f66a03e3a84a08a7b48b30dfb4cd0b'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Image.network(
                'https://cdn.builder.io/api/v1/image/assets/TEMP/0db284d3b3a6899d4cb548de45cbdd371745832a23d5bb86a9a71970b92a7f23?placeholderIfAbsent=true&apiKey=d8f66a03e3a84a08a7b48b30dfb4cd0b',
                width: 37,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 300),
            Expanded(
              child: invigilatorAssignments == null
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        // Table Header
                        Container(
                          color: Colors.grey.shade300,
                          child: Row(
                            children: [
                              _buildTableHeader('Date'),
                              _buildTableHeader('Time'),
                              _buildTableHeader('N'),
                              _buildTableHeader('Course'),
                              _buildTableHeader('Building'),
                              _buildTableHeader('Room'),
                            ],
                          ),
                        ),
                        const Divider(),
                        // Table Rows
                        ...invigilatorAssignments!.map((assignment) {
                          return Row(
                            children: [
                              _buildTableCell(assignment.date.isUtc.toString()),
                              _buildTableCell(assignment.time),
                              _buildTableCell(assignment.students.toString()),
                              _buildTableCell(assignment.name),
                              _buildTableCell(assignment.building),
                              _buildTableCell(assignment.room),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8E8E93),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
              ),
              onPressed: () {
                Navigator.pop(context); // Navigate back to the previous screen
              },
              child: const Text(
                'Back',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: const TextStyle(fontSize: 10),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
