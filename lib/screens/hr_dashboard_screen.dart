import 'package:flutter/material.dart';
import 'employee_screen.dart';

class HrDashboardScreen extends StatefulWidget {
  const HrDashboardScreen({super.key});

  @override
  State<HrDashboardScreen> createState() => _HrDashboardScreenState();
}

class _HrDashboardScreenState extends State<HrDashboardScreen> {
  bool isLoggedIn = true;
  bool isDashboardOpen = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope( // 🔥 BACK DISABLE
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FB),
        appBar: AppBar(
          title: const Text("HR Dashboard"),
          backgroundColor: Colors.grey,
        ),

        body: Row(
          children: [

            /// 🔹 SIDEBAR
            buildSidebar(),

            /// 🔹 MAIN CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    /// 🔹 TOP CARDS (HORIZONTAL SCROLL)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          buildTopCard("Avg Time", "18 days", Colors.green),
                          buildTopCard("Turnover", "4.2%", Colors.red),
                          buildTopCard("Training", "87%", Colors.blue),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 🔹 SUMMARY
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

                    /// 🔹 DEPARTMENTS
                    buildDepartment("Engineering", 42, Colors.blue),
                    buildDepartment("Sales", 36, Colors.green),
                    buildDepartment("Marketing", 25, Colors.orange),
                    buildDepartment("Finance", 20, Colors.purple),
                    buildDepartment("HR", 14, Colors.red),

                    const SizedBox(height: 20),

                    /// 🔹 BUTTONS
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

                    /// 🔹 ACTIVITY
                    buildActivity("Leave Approved", "John Doe"),
                    buildActivity("New Employee Joined", "Rahul"),
                    buildActivity("Policy Updated", "HR Team"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 SIDEBAR
  Widget buildSidebar() {
    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 40),

          Row(
            children: const [
              SizedBox(width: 15),
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.blue,
                child: Icon(Icons.blur_circular, color: Colors.white),
              ),
              SizedBox(width: 10),
              Text("Kuber",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),

          const SizedBox(height: 20),

          const Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('assets/profile.jpg'),
                ),
                SizedBox(height: 10),
                Text("Sarah Smith",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Admin", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text("HAUPTMENÜ",
                style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),

          const SizedBox(height: 10),

          InkWell(
            onTap: () {
              setState(() {
                isDashboardOpen = !isDashboardOpen;
              });
            },
            child: Container(
              color: const Color(0xFFF1F3F6),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.dashboard, size: 18),
                  const SizedBox(width: 10),
                  const Expanded(child: Text("Dashboard")),
                  Icon(isDashboardOpen
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_right),
                ],
              ),
            ),
          ),

          if (isDashboardOpen)
            Column(
              children: [
                subMenu("Dashboard 1", true),
                subMenu("Dashboard 2", false),
                subMenu("Mitarbeiter Dashboard", false),
                subMenu("Kunde Dashboard", false),
              ],
            ),

          const SizedBox(height: 10),


          mainMenu(Icons.timeline, "Timeline Chart"),

          const Spacer(),


          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout"),
            onTap: () {
              setState(() {
                isLoggedIn = false;
              });

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const EmployeeScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget subMenu(String title, bool active) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, top: 8),
      child: Row(
        children: [
          Icon(Icons.arrow_right,
              size: 14, color: active ? Colors.blue : Colors.grey),
          const SizedBox(width: 5),
          Text(title,
              style: TextStyle(
                  color: active ? Colors.blue : Colors.black)),
        ],
      ),
    );
  }

  Widget mainMenu(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.keyboard_arrow_right),
      onTap: () {},
    );
  }

  Widget buildTopCard(String title, String value, Color color) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(title),
              const SizedBox(height: 8),
              Text(value,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color)),
            ],
          ),
        ),
      ),
    );
  }

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