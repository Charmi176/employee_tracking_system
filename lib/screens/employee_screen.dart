import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'employee_client_screen.dart';
import 'employee_work_sheet.dart';

void main() {
  runApp(const EmployeeScreen());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      theme: ThemeData.dark(),
      home: const DashboardUI(),
    );
  }
}

class DashboardUI extends StatefulWidget {
  const DashboardUI({super.key});

  @override
  State<DashboardUI> createState() => _DashboardUIState();
}

class _DashboardUIState extends State<DashboardUI> {
  final ScrollController _horizontalController = ScrollController();
  Map<String, bool> iconColorStates = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Scrollbar(
        controller: _horizontalController,
        thumbVisibility: true,
        thickness: 10,
        interactive: true,
        child: SingleChildScrollView(
          controller: _horizontalController,
          scrollDirection: Axis.horizontal,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 SIDEBAR
              Container(
                width: 250,
                height: MediaQuery.of(context).size.height,
                color: const Color(0xFF131313),
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    const ListTile(
                      leading: Icon(Icons.dashboard, color: Colors.blue),
                      title: Text("DASHBOARD"),
                      subtitle: Text("WORKSPACE", style: TextStyle(color: Colors.grey, fontSize: 10)),
                    ),
                    menuItem(Icons.public, "Clients", activeColor: Colors.blue),
                    menuItem(Icons.calendar_today, "Appointments", activeColor: Colors.orange),
                    menuItem(Icons.shopping_cart, "shop", activeColor: Colors.pink),
                    menuItem(Icons.science, "labs", activeColor: Colors.cyan),
                    menuItem(Icons.people, "Users", activeColor: Colors.teal),
                    const Padding(
                      padding: EdgeInsets.all(15),
                      child: Text("MANAGEMENT", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ),
                    menuItem(Icons.chat_outlined, "Consult", activeColor: Colors.indigoAccent),
                    menuItem(Icons.list_alt, "Tasks", activeColor: Colors.redAccent),
                    menuItem(Icons.layers, "Assets", activeColor: Colors.deepPurple),
                    menuItem(Icons.build_circle_outlined, "Studio", activeColor: Colors.blueAccent),
                    menuItem(Icons.badge_outlined, "Register", activeColor: Colors.amber),

                  ],
                ),
              ),

              /// 🔹 MAIN UI
              SizedBox(
                width: 1200,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      searchBar(),
                      const SizedBox(height: 25),
                      welcomeBanner(),
                      const SizedBox(height: 25),

                      /// 🔹 4 STAT CARDS IN A ROW (હવે અહીં ફિક્સ કર્યું છે)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            statCard("REGISTERED USERS", "1,520", Icons.people, "12%", true),
                            const SizedBox(width: 20),
                            statCard("MONTHLY VISITS", "15,837", Icons.visibility, "10.5%", true),
                            const SizedBox(width: 20),
                            statCard("PROFITS", "\$135,965", Icons.account_balance, "50.9%", true),
                            const SizedBox(width: 20),
                            statCard("PORTFOLIO", "5,837", Icons.bar_chart, "10.5%", false),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),

                      /// 🔹 TABLES & NOTICE BOARD
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: upcomingAppointments()),
                          const SizedBox(width: 20),
                          Expanded(child: noticeBoard()),
                        ],
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget menuItem(IconData icon, String title, {Color activeColor = Colors.green}) {
    bool isSelected = iconColorStates[title] ?? false;

    return InkWell(
      onTap: () {

        // 🔥 Clients Screen Navigation
        if (title == "Clients") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ClientScreen(),
            ),
          );
        }

        if (title == "Tasks") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WorkLogScreen(),
            ),
          );
        }
        setState(() => iconColorStates[title] = !isSelected);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? activeColor : Colors.grey, size: 20),
            const SizedBox(width: 15),
            Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.grey)),
          ],
        ),
      ),
    );
  }


  Widget statCard(String title, String value, IconData icon, String percentage, bool isPositive) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF131313),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11, letterSpacing: 1)),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: Colors.grey, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Row(
            children: [
              Icon(isPositive ? Icons.arrow_upward : Icons.arrow_downward, color: isPositive ? Colors.green : Colors.red, size: 14),
              const SizedBox(width: 4),
              Text(percentage, style: TextStyle(color: isPositive ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              const Text("Since last month", style: TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget searchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(10)),
            child: const Row(children: [Icon(Icons.search, color: Colors.grey), SizedBox(width: 10), Text("Search...")]),
          ),
        ),
        const SizedBox(width: 15),
        const Icon(Icons.notifications_none),
        const SizedBox(width: 15),
        const CircleAvatar(radius: 18),
      ],
    );
  }

  Widget welcomeBanner() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(10)),
      child: const Row(
        children: [
          Icon(Icons.auto_awesome, color: Colors.blue, size: 18),
          SizedBox(width: 10),
          Text("New", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          SizedBox(width: 15),
          Expanded(child: Text("Welcome back to your dashboard, Gabe Oni")),
          Text("Learn More →", style: TextStyle(color: Colors.orange)),
        ],
      ),
    );
  }

  Widget upcomingAppointments() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF131313),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Upcoming Appointments", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text("View All →", style: TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1000, // કોલમ વધતા વિડ્થ વધારી છે
              child: Column(
                children: [
                  headerRow(),
                  const Divider(color: Colors.white10, height: 30),
                  tableRow("AP1053", "AW", "Amatron Wals", "9:00 PM, Sun, Mar 13th", "Cardiology: Dr. Joal", "+6", "Completed", Colors.green, "Surgery"),
                  tableRow("AP1052", "FG", "Family Group", "9:00 PM, Sun, Mar 13th", "Dr. Shie", "+2", "Pending", Colors.orange, "Check-up"),
                  tableRow("AP1049", "CT", "Cathy Tiana", "12:30 PM, Sun, Dec 26th", "Dr. Rav", "", "In progress", Colors.blue, "Urgent"),
                  tableRow("AP1050", "HB", "Herman Beck", "2:30 PM, Thu, Dec 16th", "Dr. Gabe", "+2", "Pending", Colors.orange, "Consultation"),
                  tableRow("AP1051", "RF", "Raji Fash", "4:00 PM, Mon, Dec 13th", "Dr. Gabe", "+2", "In progress", Colors.blue, "Urgent"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // 🔹 PAGINATION FOOTER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Showing 1-5 of 124 appointments", style: TextStyle(color: Colors.grey, fontSize: 12)),
              Row(
                children: [
                  _pageBtn(Icons.chevron_left),
                  const SizedBox(width: 10),
                  _pageBtn(Icons.chevron_right),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _pageBtn(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 20, color: Colors.grey),
    );
  }
  Widget noticeBoard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF131313),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Notice Board", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 25),
          Row(
            children: [
              _tab("TODO", true),
              _tab("EVENTS", false),
            ],
          ),
          const SizedBox(height: 25),
          // 🔹 ADD TASK INPUT
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(10)),
                  child: const Text("What to do today? *", style: TextStyle(color: Colors.grey, fontSize: 13)),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(10)),
                child: const Text("ADD", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 30),
          todoItem("Patient rounds in Ward 1 & 2", false),
          todoItem("Prepare Ora presentation", true),
          todoItem("Print Payment Receipts", false),
          todoItem("Submit Supplier Voucher", false),
        ],
      ),
    );
  }

  Widget _tab(String label, bool isSel) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: TextStyle(color: isSel ? Colors.blueAccent : Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 10),
          Container(height: 2, color: isSel ? Colors.blueAccent : Colors.white10),
        ],
      ),
    );
  }
  Widget headerRow() {
    return const Row(
      children: [
        SizedBox(width: 100, child: Text("REFERENCE", style: TextStyle(color: Colors.grey, fontSize: 11))),
        SizedBox(width: 220, child: Text("CLIENT(S)", style: TextStyle(color: Colors.grey, fontSize: 11))),
        SizedBox(width: 200, child: Text("APPOINTMENT", style: TextStyle(color: Colors.grey, fontSize: 11))),
        SizedBox(width: 200, child: Text("BOOKING", style: TextStyle(color: Colors.grey, fontSize: 11))),
        SizedBox(width: 150, child: Text("STATUS", style: TextStyle(color: Colors.grey, fontSize: 11))),
        SizedBox(width: 100, child: Text("TAGS", style: TextStyle(color: Colors.grey, fontSize: 11))),
      ],
    );
  }

  Widget tableRow(String ref, String initial, String name, String date, String booking, String badge, String status, Color color, String tag) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(ref, style: const TextStyle(color: Colors.grey, fontSize: 13))),
          SizedBox(
            width: 220,
            child: Row(
              children: [
                CircleAvatar(radius: 14, backgroundColor: color.withValues(alpha: 0.1), child: Text(initial, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold))),
                const SizedBox(width: 10),
                Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                if (badge.isNotEmpty) ...[const SizedBox(width: 8), Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.2), shape: BoxShape.circle), child: Text(badge, style: const TextStyle(color: Colors.blue, fontSize: 10)))]
              ],
            ),
          ),
          SizedBox(width: 200, child: Text(date, style: const TextStyle(fontSize: 13))),
          SizedBox(width: 200, child: Text(booking, style: const TextStyle(fontSize: 13))),
          // 🔹 STATUS PILL
          SizedBox(
            width: 150,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withValues(alpha: 0.2))),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, size: 8, color: color),
                  const SizedBox(width: 8),
                  Text(status, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          // 🔹 TAG
          SizedBox(
            width: 100,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(6)),
              child: Center(child: Text(tag, style: const TextStyle(color: Colors.grey, fontSize: 11))),
            ),
          ),
        ],
      ),
    );
  }

  Widget todoItem(String text, bool isDone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(color: isDone ? Colors.white.withValues(alpha: 0.04) : Colors.transparent, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(color: isDone ? Colors.orange : Colors.transparent, border: Border.all(color: isDone ? Colors.orange : Colors.grey, width: 1.5), borderRadius: BorderRadius.circular(4)),
            child: isDone ? const Center(child: Icon(Icons.check, size: 14, color: Colors.white)) : null,
          ),
          const SizedBox(width: 15),
          Expanded(child: Text(text, style: TextStyle(fontSize: 14, color: isDone ? Colors.grey : Colors.white, decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none))),
        ],
      ),
    );
  }
}

// Common Widgets
Widget headerRow() {
  return const Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        SizedBox(width: 250, child: Text("CLIENT(S)", style: TextStyle(color: Colors.grey, fontSize: 11))),
        SizedBox(width: 200, child: Text("APPOINTMENT", style: TextStyle(color: Colors.grey, fontSize: 11))),
        SizedBox(width: 200, child: Text("BOOKING", style: TextStyle(color: Colors.grey, fontSize: 11))),
        SizedBox(width: 150, child: Text("STATUS", style: TextStyle(color: Colors.grey, fontSize: 11))),
      ],
    ),
  );
}

Widget tableRow(String initials, String name, String badge, String time, String doctor, String docBadge, String status, Color color, String tag, {bool isImage = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      children: [
        SizedBox(
          width: 250,
          child: Row(
            children: [
              CircleAvatar(radius: 14, backgroundColor: color.withValues(alpha: 0.2), child: Text(initials, style: const TextStyle(fontSize: 10))),
              const SizedBox(width: 10),
              Text(name, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
        SizedBox(width: 200, child: Text(time, style: const TextStyle(fontSize: 13))),
        SizedBox(width: 200, child: Text(doctor, style: const TextStyle(fontSize: 13))),
        SizedBox(width: 150, child: Text(status, style: TextStyle(color: color, fontSize: 11))),
      ],
    ),
  );
}