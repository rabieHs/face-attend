import 'package:flutter/material.dart';

import 'package:attendence/services/scedules_services.dart';
import '../models/schedule.dart';

class ExamSchedule extends StatefulWidget {
  final String majorId;

  const ExamSchedule({
    Key? key,
    required this.majorId,
  }) : super(key: key);

  @override
  State<ExamSchedule> createState() => _ExamScheduleState();
}

class _ExamScheduleState extends State<ExamSchedule> {
  MajorSchedule? majorSchedule;

  @override
  void initState() {
    super.initState();
    loadSchedule();
  }

  Future<void> loadSchedule() async {
    final schedule = await SchedulesServices.fetchMajorSchedule(widget.majorId);
    setState(() {
      majorSchedule = schedule;
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
            majorSchedule == null
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          // Table Header
                          Row(
                            children: const [
                              _TableHeaderCell('Date'),
                              _TableHeaderCell('Day'),
                              _TableHeaderCell('Time'),
                              _TableHeaderCell('Course Number'),
                              _TableHeaderCell('Course Name'),
                              _TableHeaderCell('Building'),
                              _TableHeaderCell('Room'),
                            ],
                          ),
                          const Divider(),
                          // Table Rows
                          ...majorSchedule!.schedules.map(
                            (schedule) => TableRowWidget(schedule: schedule),
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

class _TableHeaderCell extends StatelessWidget {
  final String title;

  const _TableHeaderCell(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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

class TableRowWidget extends StatelessWidget {
  final Schedule schedule;

  const TableRowWidget({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildCell(schedule.date),
        _buildCell(schedule.day),
        _buildCell(schedule.time),
        _buildCell(schedule.courseNumber),
        _buildCell(schedule.courseName),
        _buildCell(schedule.building),
        _buildCell(schedule.room),
      ],
    );
  }

  Widget _buildCell(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Text(
        text,
        style: const TextStyle(fontSize: 10, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
