import 'package:flutter/material.dart';
import 'dart:io';
import 'package:excel/excel.dart' as ex;
import 'package:path_provider/path_provider.dart';

class EmployeeDocumentScreen extends StatefulWidget {
  const EmployeeDocumentScreen({super.key});

  @override
  State<EmployeeDocumentScreen> createState() => _EmployeeDocumentScreenState();
}

class _EmployeeDocumentScreenState extends State<EmployeeDocumentScreen> {

  /// ✅ Column Visibility
  bool showName = true;
  bool showType = true;
  bool showDept = true;
  bool showUpload = true;
  bool showExpiry = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Employee Documents",
            style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: const Color(0xFF1E63E9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            /// 🔍 TOP TOOLBAR
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E63E9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  /// Search Box
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: "Search",
                          prefixIcon: Icon(Icons.search, size: 20),
                          border: InputBorder.none,
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  GestureDetector(
                    onTap: () => _showAddDocumentDialog(context),
                    child: _topIcon(Icons.add, Colors.green),
                  ),
                  _topIcon(Icons.refresh, Colors.orange),

                  /// ✅ FILTER ICON CLICK
                  GestureDetector(
                    onTap: () => _showColumnDialog(context),
                    child: _topIcon(
                        Icons.filter_alt, Colors.white.withOpacity(0.3)),
                  ),

                  _topIcon(Icons.file_download,
                      Colors.white.withOpacity(0.3)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// 📊 TABLE
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// HEADER
                        _buildTableHeader(),

                        /// ROWS
                        _buildTableRow(context, "John Doe", "Passport",
                            "Operations", "2024-01-10", "2029-01-10", "1.5 MB"),
                        _buildTableRow(context, "Jane Smith", "Visa", "HR",
                            "2023-11-05", "2025-11-05", "2.1 MB"),
                        _buildTableRow(context, "Mike Ross", "ID Card",
                            "Legal", "2024-02-15", "2030-02-15", "800 KB"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showAddDocumentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [

                /// 🔷 HEADER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: const BoxDecoration(
                    color: Color(0xFF5A67D8),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Upload New Document",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, color: Colors.white),
                      )
                    ],
                  ),
                ),

                /// 🔽 BODY
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [

                        _inputField("Policy Name"),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(child: _inputField("Category*")),
                            const SizedBox(width: 12),
                            Expanded(child: _inputField("Department")),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(child: _inputField("Effective Date*")),
                            const SizedBox(width: 12),
                            Expanded(child: _inputField("Status")),
                          ],
                        ),

                        const SizedBox(height: 12),

                        _inputField("Tags"),
                        const SizedBox(height: 12),

                        _inputField("Description", maxLines: 3),

                        const SizedBox(height: 20),

                        /// 📁 Upload Box
                        Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.blue,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text("Drag & Drop file here or Browse"),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(child: _inputField("File Size")),
                            const SizedBox(width: 12),
                            Expanded(child: _inputField("File Type")),
                          ],
                        ),

                        const SizedBox(height: 20),

                        /// 🔘 Buttons
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade300,
                              ),
                              child: const Text("Save",
                                  style: TextStyle(color: Colors.black)),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text("Cancel"),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _inputField(String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
  /// 🔷 POPUP (Show/Hide Column)
  void _showColumnDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Show/Hide Column"),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return SingleChildScrollView(
                child: Column(
                  children: [

                    CheckboxListTile(
                      title: const Text("Employee Name"),
                      value: showName,
                      onChanged: (val) {
                        setState(() => showName = val!);
                        setStateDialog(() {});
                      },
                    ),

                    CheckboxListTile(
                      title: const Text("Document Type"),
                      value: showType,
                      onChanged: (val) {
                        setState(() => showType = val!);
                        setStateDialog(() {});
                      },
                    ),

                    CheckboxListTile(
                      title: const Text("Department"),
                      value: showDept,
                      onChanged: (val) {
                        setState(() => showDept = val!);
                        setStateDialog(() {});
                      },
                    ),

                    CheckboxListTile(
                      title: const Text("Upload Date"),
                      value: showUpload,
                      onChanged: (val) {
                        setState(() => showUpload = val!);
                        setStateDialog(() {});
                      },
                    ),

                    CheckboxListTile(
                      title: const Text("Expiry Date"),
                      value: showExpiry,
                      onChanged: (val) {
                        setState(() => showExpiry = val!);
                        setStateDialog(() {});
                      },
                    ),

                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// 🔹 Toolbar Icon
  Widget _topIcon(IconData icon, Color bgColor) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  /// 🔹 HEADER
  Widget _buildTableHeader() {
    return Container(
      color: Colors.blue.shade50,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          _cell("", width: 50, isHeader: true),

          if (showName)
            _cell("Employee Name", width: 150, isHeader: true),

          if (showType)
            _cell("Document Type", width: 130, isHeader: true),

          if (showDept)
            _cell("Department", width: 120, isHeader: true),

          if (showUpload)
            _cell("Upload Date", width: 110, isHeader: true),

          if (showExpiry)
            _cell("Expiry Date", width: 110, isHeader: true),

          _cell("Size", width: 80, isHeader: true),
          _cell("Action", width: 120, isHeader: true),
        ],
      ),
    );
  }

  /// 🔹 ROW
  Widget _buildTableRow(BuildContext context, String name, String type,
      String dept, String upload, String expiry, String size) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          const SizedBox(
              width: 50,
              child: Checkbox(value: false, onChanged: null)),

          if (showName) _cell(name, width: 150),
          if (showType) _cell(type, width: 130),
          if (showDept) _cell(dept, width: 120),
          if (showUpload) _cell(upload, width: 110),
          if (showExpiry) _cell(expiry, width: 110),

          _cell(size, width: 80),

          /// ACTIONS
          SizedBox(
            width: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _actionIcon(Icons.visibility, Colors.blue),
                _actionIcon(Icons.edit, Colors.green),
                _actionIcon(Icons.delete, Colors.red),
                _actionIcon(Icons.download, Colors.orange),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 CELL
  Widget _cell(String text,
      {double width = 100, bool isHeader = false}) {
    return Container(
      width: width,
      padding:
      const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Text(
        text,
        style: TextStyle(
          fontWeight:
          isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
          color: isHeader
              ? Colors.blue.shade900
              : Colors.black87,
        ),
      ),
    );
  }

  /// 🔹 ACTION ICON
  Widget _actionIcon(IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Icon(icon, color: color, size: 18),
    );
  }
}