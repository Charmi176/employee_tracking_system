import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class SystemSettingsScreen extends StatefulWidget {
  const SystemSettingsScreen({super.key});

  @override
  State<SystemSettingsScreen> createState() => _SystemSettingsScreenState();
}

class _SystemSettingsScreenState extends State<SystemSettingsScreen>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

  Uint8List? logoImage;
  Uint8List? faviconImage;

  final ImagePicker picker = ImagePicker();

  bool maintenanceMode = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> pickLogo() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        logoImage = bytes;
      });
    }
  }

  Future<void> pickFavicon() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        faviconImage = bytes;
      });
    }
  }

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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "System Settings",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),

                  Row(
                    children: const [
                      Icon(Icons.home_outlined, size: 18, color: Colors.grey),
                      Icon(Icons.chevron_right, size: 18, color: Colors.grey),
                      Text("Administration"),
                      Icon(Icons.chevron_right, size: 18, color: Colors.grey),
                      Text("System Settings"),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10)
                  ],
                ),

                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "System Settings",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 20),

                      /// TABS WITH ARROWS
                      Row(
                        children: [

                          const Icon(Icons.chevron_left,
                              color: Colors.grey),

                          const SizedBox(width: 10),

                          Expanded(
                            child: TabBar(
                              controller: _tabController,
                              labelColor: Colors.black,
                              unselectedLabelColor: Colors.black87,
                              indicatorColor: Colors.blue,
                              labelStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              tabs: const [
                                Tab(text: "General"),
                                Tab(text: "Security"),
                                Tab(text: "Notifications"),
                              ],
                            ),
                          ),

                          const SizedBox(width: 10),

                          const Icon(Icons.chevron_right,
                              color: Colors.grey),
                        ],
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        height: 600,
                        child: TabBarView(
                          controller: _tabController,
                          children: [

                            /// GENERAL TAB
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: "System Name",
                                      hintText: "Kuber ERP",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  DropdownButtonFormField(
                                    value: "Eastern Time (UTC-5)",
                                    items: const [
                                      DropdownMenuItem(
                                        value: "Eastern Time (UTC-5)",
                                        child: Text(
                                            "Eastern Time (UTC-5)"),
                                      )
                                    ],
                                    onChanged: (value) {},
                                    decoration: InputDecoration(
                                      labelText: "Timezone",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  DropdownButtonFormField(
                                    value: "English",
                                    items: const [
                                      DropdownMenuItem(
                                        value: "English",
                                        child: Text("English"),
                                      )
                                    ],
                                    onChanged: (value) {},
                                    decoration: InputDecoration(
                                      labelText: "Default Language",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  DropdownButtonFormField(
                                    value: "DD/MM/YYYY",
                                    items: const [
                                      DropdownMenuItem(
                                        value: "DD/MM/YYYY",
                                        child: Text("DD/MM/YYYY"),
                                      )
                                    ],
                                    onChanged: (value) {},
                                    decoration: InputDecoration(
                                      labelText: "Date Format",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 30),

                                  const Text(
                                    "System Branding",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),

                                  const SizedBox(height: 15),

                                  Row(
                                    children: [

                                      Column(
                                        children: [
                                          const Text("System Logo"),

                                          const SizedBox(height: 10),

                                          Stack(
                                            children: [

                                              Container(
                                                height: 90,
                                                width: 90,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  color: Colors.grey.shade200,
                                                ),
                                                child: logoImage != null
                                                    ? ClipRRect(
                                                  borderRadius: BorderRadius.circular(8),
                                                  child: Image.memory(
                                                    logoImage!,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                                    : Image.network(
                                                  "https://cdn-icons-png.flaticon.com/512/1828/1828884.png",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),

                                              Positioned(
                                                bottom: -5,
                                                right: -5,
                                                child: GestureDetector(
                                                  onTap: pickLogo,
                                                  child: const CircleAvatar(
                                                    radius: 18,
                                                    backgroundColor: Colors.white,
                                                    child: Icon(Icons.edit),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),

                                      const SizedBox(width: 40),

                                      Column(
                                        children: [
                                          const Text("Favicon"),

                                          const SizedBox(height: 10),

                                          Stack(
                                            children: [

                                              Container(
                                                height: 90,
                                                width: 90,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                  color:
                                                  Colors.grey.shade200,
                                                ),
                                                child: faviconImage != null
                                                    ? Image.memory(
                                                  faviconImage!,
                                                  fit: BoxFit.cover,
                                                )
                                                    : Image.network(
                                                    "https://cdn-icons-png.flaticon.com/512/5968/5968672.png"),
                                              ),

                                              Positioned(
                                                bottom: -5,
                                                right: -5,
                                                child: GestureDetector(
                                                  onTap: pickFavicon,
                                                  child: const CircleAvatar(
                                                    radius: 18,
                                                    backgroundColor:
                                                    Colors.white,
                                                    child: Icon(Icons.edit),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 30),

                                  const Text(
                                    "System Status",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),

                                  const SizedBox(height: 10),

                                  Row(
                                    children: [

                                      Switch(
                                        value: maintenanceMode,
                                        onChanged: (value) {
                                          setState(() {
                                            maintenanceMode = value;
                                          });
                                        },
                                      ),

                                      const SizedBox(width: 10),

                                      const Text("Maintenance Mode"),
                                    ],
                                  ),

                                  const Text(
                                      "When enabled, only administrators can access the system."),

                                ],
                              ),
                            ),

                            /// SECURITY TAB
                            const Center(child: Text("Security Settings")),

                            /// NOTIFICATION TAB
                            /// NOTIFICATION TAB
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  const Text(
                                    "Notification Preferences",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 25),

                                  /// EMAIL NOTIFICATION
                                  Row(
                                    children: [

                                      Container(
                                        width: 45,
                                        height: 45,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF1E63E9),
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        ),
                                      ),

                                      const SizedBox(width: 15),

                                      const Text(
                                        "Email Notifications",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 20),

                                  /// SMS SWITCH
                                  Row(
                                    children: [

                                      Switch(
                                        value: false,
                                        onChanged: (value) {},
                                      ),

                                      const SizedBox(width: 10),

                                      const Text(
                                        "SMS Notifications",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 40),

                                  /// SAVE BUTTON
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1E63E9),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 35,
                                        vertical: 15,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    onPressed: () {

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("System settings updated"),
                                        ),
                                      );

                                    },

                                    child: const Text(
                                      "Save Settings",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )

                          ],
                        ),
                      ),
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
}