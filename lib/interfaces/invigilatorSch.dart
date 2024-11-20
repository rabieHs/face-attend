import 'package:flutter/material.dart';

import '../models/invigilator_schedule_model.dart';
import '../services/scedules_services.dart';

class ScheduleWidget extends StatefulWidget {
  const ScheduleWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ScheduleWidget> createState() => _InvigilatorScheduleState();
}

class _InvigilatorScheduleState extends State<ScheduleWidget> {
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
            const SizedBox(height: 350),
            invigilatorAssignments == null
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          // Table Header
                          Row(
                            children: [
                              _TableHeaderCell('Date'),
                              _TableHeaderCell('Time'),
                              _TableHeaderCell('N'),
                              _TableHeaderCell('Course'),
                              _TableHeaderCell('Building'),
                              _TableHeaderCell('Room'),
                            ],
                          ),
                          const Divider(),
                          // Table Rows
                          ...invigilatorAssignments!.map(
                            (assignment) =>
                                InvigilatorRowWidget(assignment: assignment),
                          ),
                        ],
                      ),
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
          ],
        ),
      ),
    );
  }
}

class InvigilatorRowWidget extends StatelessWidget {
  final InvigilatorSchedule assignment;

  const InvigilatorRowWidget({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildCell(assignment.date.isUtc.toString()),
        _buildCell(assignment.time),
        _buildCell(assignment.students.toString()),
        _buildCell(assignment.name),
        _buildCell(assignment.building),
        _buildCell(assignment.room),
      ],
    );
  }

  Widget _buildCell(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Text(
        text,
        style: const TextStyle(fontSize: 10, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}

class _TableHeaderCell extends StatelessWidget {
  final String title;

  const _TableHeaderCell(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 22),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
