import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' as ex; // Prefix added
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;
import 'package:path_provider/path_provider.dart';


import 'package:flutter/material.dart' hide Border, BorderStyle;

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EmployeeDocumentScreen(),
  ));
}

class EmployeeDocumentScreen extends StatefulWidget {
  const EmployeeDocumentScreen({super.key});

  @override
  State<EmployeeDocumentScreen> createState() => _EmployeeDocumentScreenState();
}

class _EmployeeDocumentScreenState extends State<EmployeeDocumentScreen> {
  final List<Map<String, dynamic>> _allEmployees = [
    {"name": "John Doe", "doc": "Passport", "dept": "Operations", "uDate": "2024-01-10", "eDate": "2029-01-10", "size": "1.5 MB", "type": "PDF", "status": "Verified"},
    {"name": "Jane Smith", "doc": "Visa", "dept": "HR", "uDate": "2024-05-20", "eDate": "2025-05-20", "size": "0.8 MB", "type": "JPG", "status": "Pending"},
    {"name": "Bob Johnson", "doc": "Driving Lic...", "dept": "Logistics", "uDate": "2023-03-15", "eDate": "2023-03-15", "size": "2.1 MB", "type": "PDF", "status": "Expired"},
    {"name": "Alice Williams", "doc": "Degree Ce...", "dept": "Finance", "uDate": "2024-02-12", "eDate": "-", "size": "3.4 MB", "type": "PDF", "status": "Verified"},
  ];

  List<Map<String, dynamic>> _foundEmployees = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _foundEmployees = List.from(_allEmployees);
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    setState(() {
      if (enteredKeyword.isEmpty) {
        _foundEmployees = _allEmployees;
      } else {
        _foundEmployees = _allEmployees
            .where((user) => user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
            .toList();
      }
    });
  }

  // --- EXCEL DOWNLOAD LOGIC (Error Free) ---
  Future<void> _exportToExcel() async {
    var excel = ex.Excel.createExcel();
    ex.Sheet sheetObject = excel['Sheet1'];

    // Header
    sheetObject.appendRow([
      ex.TextCellValue('Name'),
      ex.TextCellValue('Document'),
      ex.TextCellValue('Dept'),
      ex.TextCellValue('Upload Date'),
      ex.TextCellValue('Expiry Date'),
      ex.TextCellValue('Size'),
      ex.TextCellValue('Type'),
      ex.TextCellValue('Status'),
    ]);

    // Data
    for (var emp in _foundEmployees) {
      sheetObject.appendRow([
        ex.TextCellValue(emp['name'].toString()),
        ex.TextCellValue(emp['doc'].toString()),
        ex.TextCellValue(emp['dept'].toString()),
        ex.TextCellValue(emp['uDate'].toString()),
        ex.TextCellValue(emp['eDate'].toString()),
        ex.TextCellValue(emp['size'].toString()),
        ex.TextCellValue(emp['type'].toString()),
        ex.TextCellValue(emp['status'].toString()),
      ]);
    }

    var fileBytes = excel.save();

    if (kIsWeb) {
      final blob = html.Blob([fileBytes!]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "Employee_Documents.xlsx")
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/Employee_Documents.xlsx');
      await file.writeAsBytes(fileBytes!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Excel Downloaded: ${file.path}")));
      }
    }
  }

  // --- UI STATUS CHIPS ---
  Widget _buildStatusChip(String status) {
    Color bgColor;
    Color textColor;
    if (status == "Verified") {
      bgColor = Colors.green.shade50;
      textColor = Colors.green;
    } else if (status == "Pending") {
      bgColor = Colors.orange.shade50;
      textColor = Colors.orange;
    } else {
      bgColor = Colors.red.shade50;
      textColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(4)),
      child: Text(status, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  // --- UPLOAD DIALOG (Same as UI Image) ---
  void _showUploadDialog() {
    String? fileName;
    String? fileSize;
    String? fileType;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            width: 650,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Blue
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF6C72FF),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Upload New Document", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.white)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildTextField("Employee Name*", Icons.person),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildTextField("Document Type*", Icons.description)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildTextField("Expiry Date", Icons.calendar_today)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildDropdownField("Department*")),
                          const SizedBox(width: 12),
                          Expanded(child: _buildDropdownField("Status", value: "Pending")),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildTextField("Tags", Icons.label_important_outline),
                      const SizedBox(height: 12),
                      TextField(
                        maxLines: 2,
                        decoration: InputDecoration(hintText: "Description", border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                      ),
                      const SizedBox(height: 15),
                      // Drag & Drop / File Access
                      GestureDetector(
                        onTap: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles();
                          if (result != null) {
                            setDialogState(() {
                              fileName = result.files.single.name;
                              fileSize = "${(result.files.single.size / 1024).toStringAsFixed(2)} KB";
                              fileType = result.files.single.extension?.toUpperCase() ?? "N/A";
                            });
                          }
                        },
                        child: Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade50,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud_upload, size: 35, color: Colors.grey.shade400),
                              const SizedBox(height: 8),
                              Text(fileName ?? "Drag & Drop file here or Browse", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildTextField("File Size", Icons.list, controller: TextEditingController(text: fileSize))),
                          const SizedBox(width: 12),
                          Expanded(child: _buildTextField("File Type", Icons.description, controller: TextEditingController(text: fileType))),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C72FF), padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Save", style: TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel", style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, {TextEditingController? controller}) {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: Icon(icon, size: 18),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, {String? value}) {
    return SizedBox(
      height: 45,
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), contentPadding: const EdgeInsets.symmetric(horizontal: 10)),
        items: const [DropdownMenuItem(value: "Pending", child: Text("Pending"))],
        onChanged: (val) {},
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumbs
            Row(
              children: [
                const Text("Employee Documents", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                Icon(Icons.home_outlined, size: 16, color: Colors.grey.shade600),
                const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                const Text("Documents", style: TextStyle(fontSize: 13)),
                const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                const Text("Employee Documents", style: TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 20),
            // Main Card
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]
                ),
                child: Column(
                  children: [
                    // Toolbar
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Text("Employee Documents List", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(width: 20),
                          Expanded(
                            child: SizedBox(
                              height: 38,
                              child: TextField(
                                controller: _searchController,
                                onChanged: _runFilter,
                                decoration: InputDecoration(
                                  hintText: "Search",
                                  prefixIcon: const Icon(Icons.search, size: 18),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          _toolbarIcon(Icons.filter_list, Colors.blue),
                          _toolbarIcon(Icons.add_circle_outline, Colors.green, onTap: _showUploadDialog),
                          _toolbarIcon(Icons.refresh, Colors.blue),
                          _toolbarIcon(Icons.file_download_outlined, Colors.blue, onTap: _exportToExcel),
                        ],
                      ),
                    ),
                    // Table
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 30,
                          headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
                          columns: const [
                            DataColumn(label: Icon(Icons.check_box_outline_blank, size: 18)),
                            DataColumn(label: Text("Employee Name")),
                            DataColumn(label: Text("Document Type")),
                            DataColumn(label: Text("Department")),
                            DataColumn(label: Text("Upload Date")),
                            DataColumn(label: Text("Expiry Date")),
                            DataColumn(label: Text("Size")),
                            DataColumn(label: Text("Type")),
                            DataColumn(label: Text("Download")),
                            DataColumn(label: Text("Status")),
                            DataColumn(label: Text("Actions")),
                          ],
                          rows: _foundEmployees.map((emp) {
                            return DataRow(cells: [
                              const DataCell(Icon(Icons.check_box_outline_blank, size: 18)),
                              DataCell(Text(emp['name'])),
                              DataCell(Text(emp['doc'])),
                              DataCell(Text(emp['dept'])),
                              DataCell(Text(emp['uDate'])),
                              DataCell(Text(emp['eDate'])),
                              DataCell(Text(emp['size'])),
                              DataCell(Text(emp['type'])),
                              DataCell(IconButton(icon: const Icon(Icons.download, size: 18), onPressed: _exportToExcel)),
                              DataCell(_buildStatusChip(emp['status'])),
                              DataCell(Row(
                                children: [
                                  const Icon(Icons.edit_note, color: Colors.blue, size: 20),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                    onPressed: () {
                                      setState(() {
                                        _allEmployees.remove(emp);
                                        _runFilter(_searchController.text);
                                      });
                                    },
                                  ),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _toolbarIcon(IconData icon, Color color, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
          child: Icon(icon, color: color, size: 18),
        ),
      ),
    );
  }
}