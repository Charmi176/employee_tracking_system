import 'package:flutter/material.dart';

class HrDashboardScreen extends StatelessWidget {
  const HrDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("HR Dashboard"),
        backgroundColor: Colors.grey,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 🔹 TOP CARDS
            Row(
              children: [
                buildTopCard("Avg Time", "18 days", Colors.green),
                buildTopCard("Turnover", "4.2%", Colors.red),
                buildTopCard("Training", "87%", Colors.blue),
              ],
            ),

            const SizedBox(height: 20),


            Row(
              children: [
                Expanded(
                  child: buildSummaryCard(
                    title: "Total Employees",
                    value: "256",
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: buildSummaryCard(
                    title: "Active",
                    value: "235",
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: buildSummaryCard(
                    title: "Contractors",
                    value: "21",
                    color: Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// 🔹 ATTENDANCE
            Row(
              children: [
                Expanded(child: attendanceBox("Present", "215", Colors.green)),
                Expanded(child: attendanceBox("Absent", "12", Colors.red)),
                Expanded(child: attendanceBox("Late", "8", Colors.orange)),
              ],
            ),

            const SizedBox(height: 20),

            /// 🔹 DEPARTMENT LIST
            buildDepartment("Engineering", 42, Colors.blue),
            buildDepartment("Sales", 36, Colors.green),
            buildDepartment("Marketing", 25, Colors.orange),
            buildDepartment("Finance", 20, Colors.purple),
            buildDepartment("HR", 14, Colors.red),

            const SizedBox(height: 20),

            /// 🔹 ACTION BUTTONS
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("View Attendance"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("Generate Report"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// 🔹 RECENT ACTIVITY
            buildActivity("Leave Approved", "John Doe"),
            buildActivity("New Employee Joined", "Rahul"),
            buildActivity("Policy Updated", "HR Team"),
          ],
        ),
      ),
    );
  }

  /// 🔥 TOP CARD
  Widget buildTopCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(title),
              const SizedBox(height: 8),
              Text(value,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color)),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 SUMMARY CARD
  Widget buildSummaryCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color)),
            const SizedBox(height: 5),
            Text(title),
          ],
        ),
      ),
    );
  }

  /// 🔥 ATTENDANCE BOX
  Widget attendanceBox(String title, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color)),
            const SizedBox(height: 5),
            Text(title),
          ],
        ),
      ),
    );
  }

  /// 🔥 DEPARTMENT BAR
  Widget buildDepartment(String name, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(name)),
          Expanded(
            flex: 6,
            child: LinearProgressIndicator(
              value: count / 50,
              color: color,
              backgroundColor: Colors.grey.shade300,
            ),
          ),
          const SizedBox(width: 10),
          Text(count.toString()),
        ],
      ),
    );
  }

  /// 🔥 ACTIVITY TILE
  Widget buildActivity(String title, String name) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.notifications),
        title: Text(title),
        subtitle: Text(name),
      ),
    );
  }
}