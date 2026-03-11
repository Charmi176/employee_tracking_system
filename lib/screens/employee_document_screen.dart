import 'package:flutter/material.dart';

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

  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  final List<Map<String, dynamic>> _allEmployees = [
    {"name": "John Doe", "doc": "Passport", "dept": "Operations", "uDate": "2024-01-10", "eDate": "2029-01-10", "size": "1.5 MB", "type": "PDF", "status": "Verified"},
    {"name": "Jane Smith", "doc": "Visa", "dept": "HR", "uDate": "2024-05-20", "eDate": "2025-05-20", "size": "0.8 MB", "type": "JPG", "status": "Pending"},
  ];

  List<Map<String, dynamic>> _foundEmployees = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _foundEmployees = List.from(_allEmployees);
    super.initState();
  }

  // SEARCH
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allEmployees;
    } else {
      results = _allEmployees
          .where((user) =>
      user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()) ||
          user["doc"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundEmployees = results;
    });
  }

  // DELETE
  void _deleteItem(int index) {
    setState(() {
      var itemToRemove = _foundEmployees[index];
      _allEmployees.remove(itemToRemove);
      _runFilter(_searchController.text);
    });
  }

  // DOWNLOAD (dummy)
  void _downloadFile(String fileName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$fileName downloaded"), backgroundColor: Colors.green),
    );
  }

  // ✅ ADD FORM DIALOG
  void _showAddDialog() {
    final nameController = TextEditingController();
    final docController = TextEditingController();
    final deptController = TextEditingController();
    final uDateController = TextEditingController();
    final eDateController = TextEditingController();
    final sizeController = TextEditingController();
    final typeController = TextEditingController();
    String status = "Pending";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Document"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Employee Name")),
              TextField(controller: docController, decoration: const InputDecoration(labelText: "Document")),
              TextField(controller: deptController, decoration: const InputDecoration(labelText: "Department")),
              TextField(controller: uDateController, decoration: const InputDecoration(labelText: "Upload Date")),
              TextField(controller: eDateController, decoration: const InputDecoration(labelText: "Expiry Date")),
              TextField(controller: sizeController, decoration: const InputDecoration(labelText: "Size")),
              TextField(controller: typeController, decoration: const InputDecoration(labelText: "Type")),

              DropdownButtonFormField(
                value: status,
                items: ["Verified", "Pending", "Expired"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  status = value!;
                },
                decoration: const InputDecoration(labelText: "Status"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _allEmployees.add({
                  "name": nameController.text,
                  "doc": docController.text,
                  "dept": deptController.text,
                  "uDate": uDateController.text,
                  "eDate": eDateController.text,
                  "size": sizeController.text,
                  "type": typeController.text,
                  "status": status,
                });

                _runFilter(_searchController.text);
              });

              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      appBar: AppBar(
        title: const Text("Employee Documents"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // SEARCH + ADD
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _runFilter,
                    decoration: const InputDecoration(
                      hintText: "Search...",
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.green),
                  onPressed: _showAddDialog,
                )
              ],
            ),

            const SizedBox(height: 20),

            // TABLE
            Expanded(
              child: SingleChildScrollView(
                controller: _verticalController,
                child: SingleChildScrollView(
                  controller: _horizontalController,
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text("Name")),
                      DataColumn(label: Text("Document")),
                      DataColumn(label: Text("Dept")),
                      DataColumn(label: Text("Upload")),
                      DataColumn(label: Text("Expiry")),
                      DataColumn(label: Text("Download")),
                      DataColumn(label: Text("Status")),
                      DataColumn(label: Text("Action")),
                    ],
                    rows: List.generate(_foundEmployees.length, (index) {
                      final item = _foundEmployees[index];

                      return DataRow(cells: [
                        DataCell(Text(item['name'])),
                        DataCell(Text(item['doc'])),
                        DataCell(Text(item['dept'])),
                        DataCell(Text(item['uDate'])),
                        DataCell(Text(item['eDate'])),

                        DataCell(IconButton(
                          icon: const Icon(Icons.download),
                          onPressed: () => _downloadFile(item['doc']),
                        )),

                        DataCell(Text(item['status'])),

                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteItem(index),
                            )
                          ],
                        )),
                      ]);
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}