import 'package:flutter/material.dart';

/// 🔥 MODEL
class TimelineEntry {
  final String email;
  final String task;
  final String status;
  final DateTime time;

  TimelineEntry({
    required this.email,
    required this.task,
    required this.status,
    required this.time,
  });
}

/// 🔥 GLOBAL LIST (TEMP DB)
List<TimelineEntry> timelineData = [];

/// 🔥 ADD FUNCTION (Employee use karse)
void addTimeline(String email, String task, String status) {
  timelineData.add(
    TimelineEntry(
      email: email,
      task: task,
      status: status,
      time: DateTime.now(),
    ),
  );
}

/// 🔥 UI SCREEN
class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Timeline Chart")),
      body: timelineData.isEmpty
          ? const Center(child: Text("No Data Available"))
          : ListView.builder(
        itemCount: timelineData.length,
        itemBuilder: (context, index) {
          final data = timelineData[index];

          return Card(
            child: ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(data.email),
              subtitle: Text("${data.task} - ${data.status}"),
              trailing: Text(
                "${data.time.hour}:${data.time.minute}",
              ),
            ),
          );
        },
      ),
    );
  }
}