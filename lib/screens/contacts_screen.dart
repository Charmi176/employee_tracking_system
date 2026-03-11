
import 'package:flutter/material.dart';
import 'package:excel/excel.dart' as excel; // Alias use karyo che
import 'dart:html' as html; // Web download mate
import 'home_screen.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  Map<String, bool> columnVisibility = {
    "Checkbox": true,
    "Name": true,
    "Email": true,
    "Birth Date": true,
    "Mobile": true,
    "Address": true,
  };

  final List<Map<String, dynamic>> contacts = [
    {
      "name": "John Deo",
      "email": "test@email.com",
      "birth": "02/25/2018",
      "mobile": "1234567890",
      "address": "God creature is sixth was abundantly a...",
      "image": "https://randomuser.me/api/portraits/women/44.jpg"
    },
    {
      "name": "Sarah Smith",
      "email": "test@email.com",
      "birth": "04/14/1985",
      "mobile": "1234567890",
      "address": "Celeste Slater 606-...",
      "image": "https://randomuser.me/api/portraits/men/32.jpg"
    },
    {
      "name": "Edna Gilbert",
      "email": "test@email.com",
      "birth": "11/08/1983",
      "mobile": "1234567890",
      "address": "Hiroko Potter P.O. B...",
      "image": "https://randomuser.me/api/portraits/women/68.jpg"
    },
    {
      "name": "Shelia Osterberg",
      "email": "test@email.com",
      "birth": "05/20/1988",
      "mobile": "1234567890",
      "address": "881 Beechwood St...",
      "image": "https://randomuser.me/api/portraits/women/65.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Contacts",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.home_outlined,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
                      const Text("Apps"),
                      const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
                      const Text("Contacts"),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),

              /// MAIN CARD
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05), blurRadius: 10)
                  ],
                ),
                child: Column(
                  children: [
                    /// TOP BAR
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE9EEF8),
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            "Contacts",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 20),

                          /// SEARCH
                          Expanded(
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const TextField(
                                decoration: InputDecoration(
                                  hintText: "Search",
                                  prefixIcon: Icon(Icons.search),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),

                          /// FILTER MENU
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.filter_list, color: Colors.blue),
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                enabled: false,
                                child: Text(
                                  "Show/Hide Column",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              PopupMenuItem(
                                enabled: false,
                                child: StatefulBuilder(
                                  builder: (context, setPopupState) {
                                    return SizedBox(
                                      width: 200,
                                      height: 250,
                                      child: ListView(
                                        children: columnVisibility.keys.map((key) {
                                          return CheckboxListTile(
                                            title: Text(key),
                                            value: columnVisibility[key],
                                            onChanged: (val) {
                                              setPopupState(() {
                                                columnVisibility[key] = val!;
                                              });
                                              setState(() {}); // Main UI update
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),

                          /// ADD CONTACT
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline,
                                color: Colors.green),
                            onPressed: _openNewContactDialog,
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.refresh, color: Colors.brown),
                          const SizedBox(width: 12),

                          /// DOWNLOAD EXCEL
                          IconButton(
                            icon: const Icon(Icons.download, color: Colors.blue),
                            onPressed: _downloadExcel,
                          ),
                        ],
                      ),
                    ),

                    /// CONTACT LIST
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        final c = contacts[index];

                        return Container(
                          padding: const EdgeInsets.all(15),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Color(0xFFE5E7EB)),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (columnVisibility["Checkbox"]!)
                                const Checkbox(value: false, onChanged: null),

                              if (columnVisibility["Name"]!)
                                _rowItem(
                                  "Name:",
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 14,
                                        backgroundImage: NetworkImage(c["image"]),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(c["name"]),
                                    ],
                                  ),
                                ),
                              if (columnVisibility["Email"]!)
                                _rowItem(
                                  "Email:",
                                  Row(
                                    children: [
                                      const Icon(Icons.mail_outline, color: Colors.red, size: 18 ),
                                      const SizedBox(width: 6),
                                      Text(c["email"]),
                                    ],
                                  ),
                                ),
                              if (columnVisibility["Birth Date"]!)
                                _rowItem(
                                  "Birth Date:",
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today, size: 16, color: Colors.brown),
                                      const SizedBox(width: 6),
                                      Text(c["birth"]),
                                    ],
                                  ),
                                ),
                              if (columnVisibility["Mobile"]!)
                                _rowItem(
                                  "Mobile:",
                                  Row(
                                    children: [
                                      const Icon(Icons.phone, color: Colors.green, size: 18),
                                      const SizedBox(width: 6),
                                      Text(c["mobile"]),
                                    ],
                                  ),
                                ),
                              if (columnVisibility["Address"]!)
                                _rowItem(
                                  "Address:",
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, color: Colors.blue, size: 18),
                                      const SizedBox(width: 6),
                                      Expanded(child: Text(c["address"]))
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 10),
                        Row(
                        children: [
                        GestureDetector(
                        onTap: () {
                        _editContactDialog(index);
                        },
                        child: const Icon(Icons.edit_outlined, color: Colors.blue),
                        ),
                        const SizedBox(width: 15),
                        const Icon(Icons.delete_outline, color: Colors.orange),
                        ],
                        )
                        ],
                          ),

                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  void _editContactDialog(int index) {
    final contact = contacts[index];

    TextEditingController nameController =
    TextEditingController(text: contact["name"]);
    TextEditingController emailController =
    TextEditingController(text: contact["email"]);
    TextEditingController mobileController =
    TextEditingController(text: contact["mobile"]);
    TextEditingController birthController =
    TextEditingController(text: contact["birth"]);
    TextEditingController addressController =
    TextEditingController(text: contact["address"]);
    TextEditingController noteController =
    TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            width: 700,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// HEADER
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: Color(0xFF5B6BD5),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(
                            "https://randomuser.me/api/portraits/women/44.jpg"),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Edit Contact: ${contact["name"]}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                ),

                /// FORM
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [

                      /// NAME + EMAIL
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: "Name *",
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.person_outline),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: TextField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                labelText: "Email *",
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.mail_outline),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      /// MOBILE + BIRTH DATE
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: mobileController,
                              decoration: const InputDecoration(
                                labelText: "Mobile *",
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.phone_android),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: TextField(
                              controller: birthController,
                              decoration: const InputDecoration(
                                labelText: "Birth date *",
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      /// ADDRESS
                      TextField(
                        controller: addressController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: "Address",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 15),

                      /// NOTE
                      TextField(
                        controller: noteController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: "Note",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// BUTTONS
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white, // TEXT COLOR WHITE
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                contacts[index]["name"] = nameController.text;
                                contacts[index]["email"] = emailController.text;
                                contacts[index]["mobile"] = mobileController.text;
                                contacts[index]["birth"] = birthController.text;
                                contacts[index]["address"] = addressController.text;
                              });

                              Navigator.pop(context);
                            },
                            child: const Text("Save"),
                          ),
                          const SizedBox(width: 15),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white, // TEXT COLOR WHITE
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                contacts.removeAt(index);
                              });

                              Navigator.pop(context);
                            },
                            child: const Text("Delete"),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteContactDialog(int index) {

    final contact = contacts[index];

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// TITLE
                const Text(
                  "Are you sure?",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                /// CONTACT INFO
                Text(
                  "Name: ${contact["name"]}",
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 6),

                Text(
                  "Email: ${contact["email"]}",
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 6),

                Text(
                  "Mobile: ${contact["mobile"]}",
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 25),

                /// BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    /// DELETE BUTTON
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {

                        setState(() {
                          contacts.removeAt(index);
                        });

                        Navigator.pop(context);
                      },
                      child: const Text("Delete"),
                    ),

                    const SizedBox(width: 15),

                    /// CANCEL BUTTON
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  /// ADD CONTACT POPUP
  void _openNewContactDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController mobileController = TextEditingController();
    TextEditingController addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("New Contact"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: mobileController,
                  decoration: const InputDecoration(labelText: "Mobile"),
                ),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: "Address"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  contacts.add({
                    "name": nameController.text,
                    "email": emailController.text,
                    "birth": "2026-03-11",
                    "mobile": mobileController.text,
                    "address": addressController.text,
                    "image": "https://randomuser.me/api/portraits/men/1.jpg"
                  });
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  /// EXCEL DOWNLOAD (Works on Web)
  void _downloadExcel() {
    var file = excel.Excel.createExcel();
    excel.Sheet sheet = file['Contacts'];

    sheet.appendRow([
      excel.TextCellValue("Name"),
      excel.TextCellValue("Email"),
      excel.TextCellValue("Birth Date"),
      excel.TextCellValue("Mobile"),
      excel.TextCellValue("Address"),
    ]);

    for (var c in contacts) {
      sheet.appendRow([
        excel.TextCellValue(c["name"]),
        excel.TextCellValue(c["email"]),
        excel.TextCellValue(c["birth"]),
        excel.TextCellValue(c["mobile"]),
        excel.TextCellValue(c["address"]),
      ]);
    }

    var fileBytes = file.save();
    if (fileBytes != null) {
      final blob = html.Blob([fileBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute("download", "contacts.xlsx")
        ..click();
      html.Url.revokeObjectUrl(url);
    }
  }

  Widget _rowItem(String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}