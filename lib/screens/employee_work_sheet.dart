import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class WorkLogScreen extends StatefulWidget {
  const WorkLogScreen({super.key});

  @override
  State<WorkLogScreen> createState() => _WorkLogScreenState();
}

class _WorkLogScreenState extends State<WorkLogScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  Future<void> _fetchLogs() async {
    setState(() => _isLoading = true);
    try {
      final data = await supabase
          .from('work_logs')
          .select('*')
          .order('created_at', ascending: false);

      setState(() {
        _logs = List<Map<String, dynamic>>.from(data);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching logs: $e");
      setState(() => _isLoading = false);
    }
  }

  /// TIME PICKER FUNCTION
  Future<String?> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      return DateFormat.jm().format(dt);
    }

    return null;
  }

  /// WORKING HOURS CALCULATION
  String _calculateHours(String checkIn, String checkOut) {
    try {
      final format = DateFormat.jm();
      DateTime inTime = format.parse(checkIn);
      DateTime outTime = format.parse(checkOut);

      Duration diff = outTime.difference(inTime);

      double hours = diff.inMinutes / 60;
      return "${hours.toStringAsFixed(1)} hrs";
    } catch (e) {
      return "0.0 hrs";
    }
  }

  void _showAddLogDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    String checkIn = "10:00 AM";
    String checkOut = "07:00 PM";
    String status = "Completed";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Log Today's Work",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

              const SizedBox(height: 20),

              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                    labelText: 'Task Title',
                    border: OutlineInputBorder()),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: descController,
                decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder()),
                maxLines: 2,
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  /// CHECK IN
                  _buildTimePickerTile("Check In", checkIn, () async {
                    final time = await _pickTime();
                    if (time != null) {
                      setModalState(() => checkIn = time);
                    }
                  }),

                  /// CHECK OUT
                  _buildTimePickerTile("Check Out", checkOut, () async {
                    final time = await _pickTime();
                    if (time != null) {
                      setModalState(() => checkOut = time);
                    }
                  }),
                ],
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB57E65),
                    minimumSize: const Size(double.infinity, 50)),
                  onPressed: () async {

                    try {

                      final response = await Supabase.instance.client
                          .from('work_logs')
                          .insert({

                        'date': DateTime.now().toString().substring(0,10),

                        'day': DateFormat('EEEE').format(DateTime.now()),

                        'check_in': checkIn,

                        'check_out': checkOut,

                        'lunch': '01:00 - 02:00',

                        'hours': _calculateHours(checkIn, checkOut),

                        'task_title': titleController.text,

                        'task_desc': descController.text,

                        'status': status,

                        'employee_id': 'EMP001',

                      });

                      print("Inserted: $response");

                      Navigator.pop(context);

                      _fetchLogs();

                    } catch (e) {

                      print("Supabase Insert Error: $e");

                    }

                  },
                child: const Text("Save to Supabase",
                    style: TextStyle(color: Colors.white)),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchLogs,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 25),
                _buildSummaryStats(),
                const SizedBox(height: 25),
                _buildProductivityChart(),
                const SizedBox(height: 30),
                _buildLogsHeader(),

                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_logs.isEmpty)
                  const Center(child: Text("No logs found. Tap + to add."))
                else
                  ..._logs.map((log) => _buildLogCard(
                    date: log['date'] ?? '',
                    day: log['day'] ?? '',
                    status: log['status'] ?? 'Completed',
                    checkIn: log['check_in'] ?? '--:--',
                    checkOut: log['check_out'] ?? '--:--',
                    lunchBreak: '01:00 - 02:00',
                    workingHours: log['hours'] ?? '0.0 hrs',
                    taskTitle: log['task_title'] ?? '',
                    taskDesc: log['task_desc'] ?? '',
                    statusColor: log['status'] == 'Weekend'
                        ? Colors.orange
                        : Colors.green,
                  )),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddLogDialog,
        backgroundColor: const Color(0xFFB57E65),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Log Today',
            style: TextStyle(color: Colors.white)),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  /// -------- SAME UI METHODS --------

  Widget _buildTimePickerTile(String label, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8)),
            child: Text(value,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Work Logs',
                style:
                TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Track your daily productivity',
                style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
        const CircleAvatar(
            backgroundColor: Color(0xFF1A1A1A),
            child: Text('JD', style: TextStyle(color: Colors.white))),
      ],
    );
  }

  Widget _buildSummaryStats() {
    return Row(
      children: [
        _buildStatCard('${_logs.length * 8}h', 'This Month',
            Icons.access_time_filled),
        const SizedBox(width: 12),
        _buildStatCard('${_logs.length}', 'Tasks Done',
            Icons.check_circle),
        const SizedBox(width: 12),
        _buildStatCard('4.5m', 'Avg Break', Icons.coffee),
      ],
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade200)),
        child: Column(children: [
          Icon(icon, size: 20, color: Colors.black54),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(label,
              style: const TextStyle(fontSize: 10, color: Colors.grey))
        ]),
      ),
    );
  }

  Widget _buildProductivityChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: const Color(0xFFF1F3F4),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Weekly Productivity',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar(0.6, 'M'),
                _buildBar(0.5, 'T'),
                _buildBar(0.8, 'W'),
                _buildBar(0.7, 'T'),
                _buildBar(0.4, 'F'),
                _buildBar(0.1, 'S'),
                _buildBar(0.1, 'S')
              ]),
        ],
      ),
    );
  }

  Widget _buildBar(double heightFactor, String day) {
    return Column(children: [
      Container(
          height: 60 * heightFactor,
          width: 12,
          decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(10))),
      const SizedBox(height: 8),
      Text(day, style: const TextStyle(fontSize: 10))
    ]);
  }

  Widget _buildLogsHeader() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Recent Logs',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          TextButton(
              onPressed: _fetchLogs,
              child: const Text('Refresh',
                  style: TextStyle(color: Colors.grey)))
        ]);
  }

  Widget _buildLogCard({
    required String date,
    required String day,
    required String status,
    required String checkIn,
    required String checkOut,
    required String lunchBreak,
    required String workingHours,
    required String taskTitle,
    required String taskDesc,
    required Color statusColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: const Color(0xFFF1F3F4),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(date,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey)),
                    Text(day,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16))
                  ]),
              Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: statusColor.withOpacity(0.5))),
                  child: Text(status,
                      style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 15),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimeInfo('Check In', checkIn),
                _buildTimeInfo('Check Out', checkOut)
              ]),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12)),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(taskTitle,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(taskDesc,
                      style: const TextStyle(
                          fontSize: 12, color: Colors.grey))
                ]),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfo(String label, String value) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
              const TextStyle(fontSize: 11, color: Colors.grey)),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 13))
        ]);
  }
}