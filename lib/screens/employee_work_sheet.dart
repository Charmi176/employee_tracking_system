import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WorkLogsScreen extends StatefulWidget {
  const WorkLogsScreen({super.key});

  @override
  State<WorkLogsScreen> createState() => _WorkLogsScreenState();
}

final supabase = Supabase.instance.client;

class _WorkLogsScreenState extends State<WorkLogsScreen> {

  TimeOfDay? checkInTime;
  TimeOfDay? checkOutTime;
  double workingHours = 0;
  List logs = [];

  @override
  void initState() {
    super.initState();
    fetchLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Work Logs',
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1))),
                      Text('Track your daily productivity',
                          style: TextStyle(fontSize: 16, color: Color(0xFF1976D2))),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xFF0D47A1),
                    child: Text('JD', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              /// STATS
              Row(
                children: [
                  _buildStatCard('164h', 'This Month', Icons.timer_outlined, const Color(0xFF0D47A1)),
                  const SizedBox(width: 12),
                  _buildStatCard('12', 'Tasks Done', Icons.check_circle_outline, Colors.green),
                  const SizedBox(width: 12),
                  _buildStatCard('45m', 'Avg Break', Icons.coffee_outlined, Colors.orange),
                ],
              ),

              const SizedBox(height: 25),

              /// CHART
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Weekly Productivity',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 150,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 10,
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const days = ['M','T','W','T','F','S','S'];
                                  return Text(days[value.toInt()]);
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          barGroups: [
                            _makeGroupData(0, 6),
                            _makeGroupData(1, 5),
                            _makeGroupData(2, 7),
                            _makeGroupData(3, 6),
                            _makeGroupData(4, 4),
                            _makeGroupData(5, 0),
                            _makeGroupData(6, 0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// ✅ TIME PICKER (ADDED)
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text("Add Work Log",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null) {
                              setState(() => checkInTime = picked);
                              _calculateWorkingHours();
                            }
                          },
                          child: Text(checkInTime == null
                              ? "Check In"
                              : checkInTime!.format(context)),
                        ),

                        ElevatedButton(
                          onPressed: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null) {
                              setState(() => checkOutTime = picked);
                              _calculateWorkingHours();
                            }
                          },
                          child: Text(checkOutTime == null
                              ? "Check Out"
                              : checkOutTime!.format(context)),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Text("Working Hours: ${workingHours.toStringAsFixed(1)} hrs"),

                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: saveWorkLog,
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// RECENT LOGS
              const Text("Recent Logs",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

              const SizedBox(height: 10),

              Column(
                children: logs.map((log) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildLogCard(
                      date: log['date'] != null
                          ? log['date'].toString().substring(0, 10)
                          : '',
                      day: (log['day'] ?? '').toString(),
                      status: (log['status'] ?? '').toString(),
                      statusColor: Colors.green,
                      checkIn: (log['check_in'] ?? '').toString(),
                      checkOut: (log['check_out'] ?? '').toString(),
                      workingHours: (log['hours'] ?? '').toString(),
                      taskTitle: (log['task_title'] ?? '').toString(),
                      taskDesc: (log['task_desc'] ?? '').toString(),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Icon(icon, color: color),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(label),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(toY: y, color: const Color(0xFF0D47A1))
    ]);
  }

  Widget _buildLogCard({
    required String date,
    required String day,
    required String status,
    required Color statusColor,
    required String checkIn,
    required String checkOut,
    required String workingHours,
    required String taskTitle,
    required String taskDesc,
  }) {
    return ListTile(
      title: Text("$date - $day"),
      subtitle: Text("$checkIn → $checkOut"),
      trailing: Text(workingHours),
    );
  }

  Future<void> saveWorkLog() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await supabase.from('work_logs').insert({
      'user_id': user.id,
      'date': DateTime.now().toIso8601String(),
      'day': _getDayName(),
      'check_in': checkInTime?.format(context),
      'check_out': checkOutTime?.format(context),
      'hours': "${workingHours.toStringAsFixed(1)} hrs",
      'status': "Completed",
    });

    fetchLogs();
  }

  Future<void> fetchLogs() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final data = await supabase
        .from('work_logs')
        .select()
        .eq('user_id', user.id);

    setState(() {
      logs = data;
    });
  }

  String _getDayName() {
    return ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    [DateTime.now().weekday - 1];
  }

  void _calculateWorkingHours() {
    if (checkInTime != null && checkOutTime != null) {
      final now = DateTime.now();

      final checkIn = DateTime(now.year, now.month, now.day,
          checkInTime!.hour, checkInTime!.minute);

      final checkOut = DateTime(now.year, now.month, now.day,
          checkOutTime!.hour, checkOutTime!.minute);

      double total = checkOut.difference(checkIn).inMinutes / 60;
      total -= 1.5;

      if (total < 0) total = 0;

      setState(() => workingHours = total);
    }
  }
}