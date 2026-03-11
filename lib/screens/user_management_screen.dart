import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // kIsWeb માટે
import 'package:excel/excel.dart' as ex;
import 'dart:html' as html;

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  bool isDark = false;

  // ટેક્સ્ટ ફીલ્ડ માટે કંટ્રોલર્સ
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController deptController = TextEditingController();
  String selectedRole = 'Employee';
  String selectedStatus = 'Active';

  Map<String, bool> columnVisibility = {
    "Checkbox": true,
    "Name": true,
    "Email": true,
    "Phone": true,
    "Department": true,
    "Role": true,
    "Status": true,
    "Last Login": true,
    "Actions": true,
  };

  final List<Map<String, dynamic>> _users = [
    {"name": "Eva Garcia", "email": "eva@example.com", "phone": "1119876543", "dept": "Support", "role": "Employee", "status": "Inactive", "login": "2026-01-08"},
    {"name": "John Doe", "email": "john@example.com", "phone": "1234567890", "dept": "IT", "role": "Admin", "status": "Active", "login": "2026-01-12"},
    {"name": "Jane Smith", "email": "jane@example.com", "phone": "9876543210", "dept": "HR", "role": "Manager", "status": "Active", "login": "2026-01-11"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF3F4F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // હેડર સેક્શન
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("User Management", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      const Icon(Icons.home_outlined, size: 18, color: Colors.grey),
                      const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
                      Text("Administration", style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // મેઈન કન્ટેનર
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Text("Users List", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16)),
                          const SizedBox(width: 20),
                          // સર્ચ બાર
                          Expanded(
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9FAFB),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: const TextField(
                                decoration: InputDecoration(
                                  hintText: "Search",
                                  prefixIcon: Icon(Icons.search, size: 20),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),

                          // કોલમ ફિલ્ટર બટન
                          _buildColumnFilter(),

                          // 🟢 ADD USER BUTTON (અહીં ફંક્શન કોલ કર્યું છે)
                          _actionIcon(Icons.add_circle_outline, Colors.green, () {
                            _showAddUserDialog(context);
                          }),

                          _actionIcon(Icons.refresh, Colors.blueGrey, () {}),
                          _actionIcon(Icons.download, Colors.blue, () {
                            _downloadExcel();
                          }),
                        ],
                      ),
                    ),

                    // ડેટા ટેબલ

            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: _users.map((user) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [
                            Checkbox(value: false, onChanged: (v) {}),
                          ],
                        ),

                        const SizedBox(height: 10),

                        _mobileField("Name:", user['name']),
                        _mobileField("Email:", user['email']),
                        _mobileField("Phone:", user['phone']),
                        _mobileField("Department:", user['dept']),
                        _mobileField("Role:", user['role']),

                        Row(
                          children: [
                            const Text("Status:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(width: 10),
                            _statusBadge(user['status']),
                          ],
                        ),

                        const SizedBox(height: 10),

                        _mobileField("Last Login:", user['login']),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.orange),
                              onPressed: () {},
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _mobileField(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
  // એક્શન આઇકોન વિજેટ
  Widget _actionIcon(IconData icon, Color color, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, color: color),
      onPressed: onTap,
    );
  }

  // સ્ટેટસ બેજ વિજેટ
  Widget _statusBadge(String status) {
    bool isActive = status == "Active";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
          status,
          style: TextStyle(color: isActive ? Colors.green : Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)
      ),
    );
  }

  // કોલમ ફિલ્ટર પોપઅપ
  Widget _buildColumnFilter() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.filter_list, color: Colors.blue),
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          enabled: false,
          child: Text("Show/Hide Column", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          enabled: false,
          child: SizedBox(
            width: 200,
            height: 250,
            child: ListView(
              children: columnVisibility.keys.map((String key) {
                return StatefulBuilder(
                  builder: (context, setPopupState) {
                    return CheckboxListTile(
                      title: Text(key, style: const TextStyle(fontSize: 14)),
                      value: columnVisibility[key],
                      dense: true,
                      onChanged: (bool? value) {
                        setState(() { columnVisibility[key] = value!; });
                        setPopupState(() {});
                      },
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  // 🔵 નવો યુઝર ઉમેરવા માટેનો ડાયલોગ
  void _showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.antiAlias,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // હેડર
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  color: const Color(0xFF6366F1),
                  child: Row(
                    children: [
                      const CircleAvatar(radius: 16, backgroundColor: Colors.white24, child: Icon(Icons.person, color: Colors.white)),
                      const SizedBox(width: 12),
                      const Text("New User", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
                    ],
                  ),
                ),

                // ફોર્મ
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildTextField("Full Name*", Icons.person_outline, nameController)),
                          const SizedBox(width: 20),
                          Expanded(child: _buildTextField("Email*", Icons.email_outlined, emailController)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: _buildTextField("Phone*", Icons.phone_outlined, phoneController)),
                          const SizedBox(width: 20),
                          Expanded(child: _buildTextField("Department*", Icons.business_center_outlined, deptController)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: _buildDropdownField("Role*", ["Admin", "Manager", "Employee"], (val) => selectedRole = val!)),
                          const SizedBox(width: 20),
                          Expanded(child: _buildDropdownField("Status*", ["Active", "Inactive"], (val) => selectedStatus = val!)),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // બટન્સ
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // સેવ લોજિક
                              setState(() {
                                _users.add({
                                  "name": nameController.text,
                                  "email": emailController.text,
                                  "phone": phoneController.text,
                                  "dept": deptController.text,
                                  "role": selectedRole,
                                  "status": selectedStatus,
                                  "login": DateTime.now().toString().split(' ')[0], // આજની તારીખ
                                });
                              });
                              // ફિલ્ડ્સ ખાલી કરવા
                              nameController.clear();
                              emailController.clear();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              foregroundColor: Colors.black87,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            child: const Text("Save", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 15),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB91C1C),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: Icon(icon, color: Colors.grey, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      ),
    );
  }
  void _downloadExcel() {

    var excel = ex.Excel.createExcel();
    ex.Sheet sheetObject = excel['Users List'];
    excel.delete('Sheet1');

    List<String> headers = [
      "Name",
      "Email",
      "Phone",
      "Department",
      "Role",
      "Status",
      "Last Login"
    ];

    sheetObject.appendRow(headers.map((e) => ex.TextCellValue(e)).toList());

    for (var user in _users) {
      sheetObject.appendRow([
        ex.TextCellValue(user['name'] ?? ""),
        ex.TextCellValue(user['email'] ?? ""),
        ex.TextCellValue(user['phone'] ?? ""),
        ex.TextCellValue(user['dept'] ?? ""),
        ex.TextCellValue(user['role'] ?? ""),
        ex.TextCellValue(user['status'] ?? ""),
        ex.TextCellValue(user['login'] ?? ""),
      ]);
    }

    var fileBytes = excel.save();

    if (kIsWeb) {

      final content = html.Blob([fileBytes!]);
      final url = html.Url.createObjectUrlFromBlob(content);

      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "Users_Data.xlsx")
        ..click();

      html.Url.revokeObjectUrl(url);
    }

  }


  Widget _buildDropdownField(String label, List<String> items, Function(String?) onChange) {
    return DropdownButtonFormField<String>(
      value: items.last,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      ),
      items: items.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
      onChanged: onChange,
    );
   }
   }


