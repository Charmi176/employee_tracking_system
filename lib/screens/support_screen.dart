import 'package:flutter/material.dart';


class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),

      appBar: AppBar(
        title: const Text("Support"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔍 SEARCH BAR
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.search),
                          hintText: "Search",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Icon(Icons.filter_alt_outlined),
                  const SizedBox(width: 10),
                  Icon(Icons.refresh),
                  const SizedBox(width: 10),
                  Icon(Icons.download),
                ],
              ),

              const SizedBox(height: 20),

              /// 🔽 SUPPORT CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Column(
                  children: [

                    _row("Name:", "Tim Hank", isProfile: true),
                    _divider(),

                    _row("Email:", "test@example.com", icon: Icons.email, iconColor: Colors.red),
                    _divider(),

                    _row("Subject:", "Image not Proper"),
                    _divider(),

                    _statusRow(),
                    _divider(),

                    _row("Assigned To:", "John Deo"),
                    _divider(),

                    _row("Date:", "27/05/2016"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ////////////////////////////////////////////

  Widget _row(String title, String value,
      {IconData? icon, Color? iconColor, bool isProfile = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [

          SizedBox(
            width: 110,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          if (isProfile)
            const CircleAvatar(
              radius: 14,
              backgroundImage: NetworkImage(
                "https://randomuser.me/api/portraits/women/44.jpg",
              ),
            ),

          if (icon != null)
            Icon(icon, size: 18, color: iconColor),

          const SizedBox(width: 8),

          Text(value),
        ],
      ),
    );
  }

  ////////////////////////////////////////////

  Widget _statusRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [

          const SizedBox(
            width: 110,
            child: Text(
              "Status:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "closed",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////

  Widget _divider() {
    return Divider(color: Colors.grey.shade300);
  }
}