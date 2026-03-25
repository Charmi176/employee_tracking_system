import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HRPoliciesScreen(),
  ));
}

class HRPoliciesScreen extends StatefulWidget {
  const HRPoliciesScreen({super.key});

  @override
  State<HRPoliciesScreen> createState() => _HRPoliciesScreenState();
}

class _HRPoliciesScreenState extends State<HRPoliciesScreen> {

  final List<Map<String, dynamic>> policies = [
    {
      "policy": "Code of Conduct",
      "category": "General",
      "dept": "HR",
      "effective": "2025-01-01",
      "revision": "2024-12-15",
      "size": "1.2 MB",
      "type": "PDF",
      "status": "Active"
    },
    {
      "policy": "Work From Home",
      "category": "Remote Work",
      "dept": "Operations",
      "effective": "2025-02-01",
      "revision": "2025-01-10",
      "size": "0.9 MB",
      "type": "PDF",
      "status": "Active"
    },
    {
      "policy": "Travel Policy",
      "category": "Finance",
      "dept": "Finance",
      "effective": "2024-06-01",
      "revision": "2024-05-20",
      "size": "1.5 MB",
      "type": "PDF",
      "status": "In Review"
    },
  ];

  Widget statusChip(String status) {
    Color bg;
    Color text;

    if (status == "Active") {
      bg = Colors.green.shade50;
      text = Colors.green;
    } else {
      bg = Colors.blue.shade50;
      text = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(status, style: TextStyle(color: text)),
    );
  }

  void showAddPolicyDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          width: 600,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFF6C72FF),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("New HR Policy", style: TextStyle(color: Colors.white, fontSize: 18)),
                    Icon(Icons.close, color: Colors.white)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: const [
                    TextField(decoration: InputDecoration(labelText: "Policy Name")),
                    SizedBox(height: 15),
                    TextField(decoration: InputDecoration(labelText: "Category")),
                    SizedBox(height: 15),
                    TextField(decoration: InputDecoration(labelText: "Department")),
                    SizedBox(height: 15),
                    TextField(decoration: InputDecoration(labelText: "Effective Date")),
                    SizedBox(height: 15),
                    TextField(decoration: InputDecoration(labelText: "Status")),
                    SizedBox(height: 15),
                    TextField(decoration: InputDecoration(labelText: "Tags")),
                    SizedBox(height: 15),
                    TextField(maxLines: 3, decoration: InputDecoration(labelText: "Description")),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget toolbarIcon(IconData icon, Color color, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [

            /// HEADER
            const Row(
              children: [
                Text("HR Policies", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Spacer(),
                Icon(Icons.home_outlined),
                Text(" > Documents > HR Policies")
              ],
            ),

            const SizedBox(height: 20),

            /// CARD
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [

                    /// TOOLBAR
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Text("HR Policies List", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 20),

                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Search",
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),

                          toolbarIcon(Icons.filter_list, Colors.blue),
                          toolbarIcon(Icons.add, Colors.green, onTap: showAddPolicyDialog),
                          toolbarIcon(Icons.refresh, Colors.orange),
                          toolbarIcon(Icons.download, Colors.blue),
                        ],
                      ),
                    ),

                    /// TABLE
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 30,
                          columns: const [
                            DataColumn(label: Icon(Icons.check_box_outline_blank)),
                            DataColumn(label: Text("Policy Name")),
                            DataColumn(label: Text("Category")),
                            DataColumn(label: Text("Department")),
                            DataColumn(label: Text("Effective Date")),
                            DataColumn(label: Text("Last Revision")),
                            DataColumn(label: Text("Size")),
                            DataColumn(label: Text("Type")),
                            DataColumn(label: Text("Download")),
                            DataColumn(label: Text("Status")),
                            DataColumn(label: Text("Actions")),
                          ],
                          rows: policies.map((p) {
                            return DataRow(cells: [
                              const DataCell(Icon(Icons.check_box_outline_blank)),
                              DataCell(Text(p['policy'])),
                              DataCell(Text(p['category'])),
                              DataCell(Text(p['dept'])),
                              DataCell(Text(p['effective'])),
                              DataCell(Text(p['revision'])),
                              DataCell(Text(p['size'])),
                              DataCell(Text(p['type'])),
                              const DataCell(Icon(Icons.download)),
                              DataCell(statusChip(p['status'])),
                              DataCell(Row(
                                children: const [
                                  Icon(Icons.edit, color: Colors.blue),
                                  SizedBox(width: 10),
                                  Icon(Icons.delete, color: Colors.red),
                                ],
                              )),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}