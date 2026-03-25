import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WorkLogsScreen extends StatelessWidget {
  const WorkLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8), // Light Blue-ish background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Work Logs',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D47A1), // Dark Blue Header
                        ),
                      ),
                      const Text(
                        'Track your daily productivity',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1976D2), // Medium Blue Subtitle
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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

              // Summary Stats
              Row(
                children: [
                  _buildStatCard('164h', 'This Month', Icons.timer_outlined, const Color(0xFF0D47A1)),
                  const SizedBox(width: 12),
                  _buildStatCard('12', 'Tasks Done', Icons.check_circle_outline, Colors.green.shade700),
                  const SizedBox(width: 12),
                  _buildStatCard('45m', 'Avg Break', Icons.coffee_outlined, Colors.orange.shade800),
                ],
              ),
              const SizedBox(height: 25),

              // Weekly Productivity Chart
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue.shade100, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Weekly Productivity',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 150,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 10,
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                                  return Text(days[value.toInt()],
                                      style: const TextStyle(color: Color(0xFF1976D2), fontSize: 12, fontWeight: FontWeight.bold));
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          barGroups: [
                            _makeGroupData(0, 6),
                            _makeGroupData(1, 5.5),
                            _makeGroupData(2, 7),
                            _makeGroupData(3, 6),
                            _makeGroupData(4, 4.5),
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

              // Recent Logs Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Logs',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View All', style: TextStyle(color: Color(0xFF1976D2), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),

              // Logs List
              _buildLogCard(
                date: '15 Dec 2025',
                day: 'Monday',
                status: 'Completed',
                statusColor: const Color(0xFF2E7D32), // Dark Green
                checkIn: '10:00 AM',
                checkOut: '07:00 PM',
                workingHours: '8.0 hrs',
                taskTitle: 'User Management',
                taskDesc: 'Basic dart programming and implementation of user authentication flows.',
              ),
              const SizedBox(height: 15),
              _buildLogCard(
                date: '14 Dec 2025',
                day: 'Sunday',
                status: 'Weekend',
                statusColor: const Color(0xFFEF6C00), // Dark Orange
                checkIn: '--:--',
                checkOut: '--:--',
                workingHours: '0.0 hrs',
                taskTitle: 'N/A',
                taskDesc: 'No tasks assigned for the weekend.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.blue.shade100, width: 1.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF1976D2), fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: const Color(0xFF0D47A1), // Dark Blue Bars
          width: 14,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade100, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(date, style: const TextStyle(color: Color(0xFF1976D2), fontSize: 13, fontWeight: FontWeight.bold)),
                  Text(day, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const Divider(height: 30, thickness: 1, color: Color(0xFFE3F2FD)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLogInfo('Check In', checkIn),
              _buildLogInfo('Check Out', checkOut),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLogInfo('Lunch Break', '01:00 - 02:30'),
              _buildLogInfo('Working Hours', workingHours, isBold: true),
            ],
          ),
          const SizedBox(height: 20),
          // --- Have ahiya Blue background ane white text sathe task box che ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0D47A1), // Dark Blue Box
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Task: $taskTitle', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text(taskDesc, style: const TextStyle(color: Colors.white, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogInfo(String label, String value, {bool isBold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF1976D2), fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 15, fontWeight: isBold ? FontWeight.bold : FontWeight.w600, color: Colors.black)),
      ],
    );
  }
}