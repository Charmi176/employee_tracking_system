import 'package:flutter/material.dart';


class SystemSettingsScreen extends StatefulWidget {
  const SystemSettingsScreen({super.key});

  @override
  State<SystemSettingsScreen> createState() => _SystemSettingsScreenState();
}

class _SystemSettingsScreenState extends State<SystemSettingsScreen> {
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
              // --- Breadcrumb & Title ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("System Settings",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF374151))),
                  Row(
                    children: [
                      const Icon(Icons.home_outlined, size: 18, color: Colors.grey),
                      const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
                      Text("Administration", style: TextStyle(color: Colors.grey[600])),
                      const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
                      Text("System Settings", style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // --- Main Content Card ---
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header inside card
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text("System Settings",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4B5563))),
                    ),

                    // --- Tabs Navigation ---
                    const DefaultTabController(
                      length: 5,
                      child: Column(
                        children: [
                          TabBar(
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            labelColor: Colors.blue,
                            unselectedLabelColor: Colors.black54,
                            indicatorColor: Colors.blue,
                            indicatorSize: TabBarIndicatorSize.tab,
                            tabs: [
                              Tab(text: "General"),
                              Tab(text: "Security"),
                              Tab(text: "Notifications"),
                              Tab(text: "Email SMTP"),
                              Tab(text: "Storage"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFFE5E7EB)),

                    // --- Form Fields Section ---
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: [
                          // Row 1
                          Row(
                            children: [
                              Expanded(child: _buildSystemField("System Name", "Kuber ERP")),
                              const SizedBox(width: 25),
                              Expanded(child: _buildSystemDropdown("Timezone", "Eastern Time (UTC-5)")),
                            ],
                          ),
                          const SizedBox(height: 30),
                          // Row 2
                          Row(
                            children: [
                              Expanded(child: _buildSystemDropdown("Default Language", "English")),
                              const SizedBox(width: 25),
                              Expanded(child: _buildSystemDropdown("Date Format", "DD/MM/YYYY")),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ટેક્સ્ટ ઇનપુટ માટેનું કસ્ટમ ફીલ્ડ (આઉટલાઇન લેબલ સાથે)
  Widget _buildSystemField(String label, String value) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
    );
  }

  // ડ્રોપડાઉન માટેનું કસ્ટમ ફીલ્ડ
  Widget _buildSystemDropdown(String label, String value) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
      items: [value].map((String val) {
        return DropdownMenuItem<String>(value: val, child: Text(val));
      }).toList(),
      onChanged: (val) {},
    );
  }
}