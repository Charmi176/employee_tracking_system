  import 'package:flutter/material.dart';
  import 'package:fl_chart/fl_chart.dart';
  import 'employee_screen.dart';
  import 'user_management_screen.dart';
  import 'chart_screen.dart';
  import 'employee_calender_screen.dart';
  import 'employee_document_screen.dart';
  import 'employee_calender_screen.dart';
  import 'system_settings_screen.dart';
  import 'contacts_screen.dart';
  import 'hr_dashboard_screen.dart';
  
  class HomeScreen extends StatefulWidget {
    const HomeScreen({super.key});
  
    @override
    State<HomeScreen> createState() => _HomeScreenState();
  }
  
  class _HomeScreenState extends State<HomeScreen> {
    int selectedIndex = -1;
    int LogoutSelected = 0;
    int touchedIndex = -1;
    bool isDark = false;
    Color primaryColor = const Color(0xFF1E63E9);
  
  
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  
    @override
    Widget build(BuildContext context) {
  
      return Scaffold(
        key: _scaffoldKey,
        endDrawer: const SideMenu(),
        backgroundColor: isDark ? Colors.black : const Color(0xFFF3F4F6),
  
  
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
  
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
  
                  // 🔵 HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
  
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Welcome",
                              style: TextStyle(
                                  color: isDark ? Colors.white70 : Colors.grey)),
  
                          const SizedBox(height: 4),
  
                          Text("Eleza Patel",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black)),
  
                          const SizedBox(height: 4),
  
                          Text("30 November, 2024",
                              style: TextStyle(
                                  color: isDark ? Colors.white60 : Colors.grey)),
                        ],
                      ),
  
                      Row(
                        children: [
  
                          // 🔔 Notification
                          CircleIcon(
                            icon: Icons.notifications_none,
                            isSelected: selectedIndex == 0,
                            showBadge: true,
                            onTap: () {
                              setState(() {
                                selectedIndex =
                                (selectedIndex == 0) ? -1 : 0;
                              });
                            },
                          ),
  
                          const SizedBox(width: 10),
  
                          // 🌙 Dark Mode
                          CircleIcon(
                            icon: isDark
                                ? Icons.light_mode
                                : Icons.dark_mode_outlined,
                            isSelected: false,
                            onTap: () {
                              setState(() {
                                isDark = !isDark;
                                selectedIndex = -1;
                              });
                            },
                          ),
  
                          const SizedBox(width: 10),
  
                          // ☰ Menu (Square)
                          CircleIcon(
                            icon: Icons.menu,
                            isSelected: false,
                            isSquare: true,
                            onTap: () {
                              _scaffoldKey.currentState?.openEndDrawer();
                            },
                          ),
                        ],
                      )
                    ],
                  ),
  
                  const SizedBox(height: 20),
  
                  // 🔵 CARDS
                  StatCard(
                    title: "TOTAL EMPLOYEE",
                    value: "475",
                    icon: Icons.people,
                    change: "+7%",
                    color: Colors.green,
                    isDark: isDark,
                  ),
  
                  const SizedBox(height: 15),
  
                  StatCard(
                    title: "PENDING LEAVE REQUEST",
                    value: "15",
                    icon: Icons.description,
                    change: "+5",
                    color: Colors.purple,
                    isDark: isDark,
                  ),
  
                  const SizedBox(height: 15),
  
                  StatCard(
                    title: "ACTIVE REQUIREMENT POSITION",
                    value: "35",
                    icon: Icons.person_add,
                    change: "+12",
                    color: Colors.pink,
                    isDark: isDark,
                  ),
  
                  const SizedBox(height: 15),
  
                  StatCard(
                    title: "PAYROLL PROCESSING SYSTEM",
                    value: "11",
                    icon: Icons.payments,
                    change: "+3",
                    color: Colors.green,
                    isDark: isDark,
                  ),
  
                  const SizedBox(height: 20),
  
                  // 🔵 CHART
                  EmployeeChartCard(isDark: isDark),
  
                  const SizedBox(height: 20),
  
                  RecruitmentCard(isDark: isDark),
  
                  const SizedBox(height: 20),
  
                  PayrollChartCard(isDark: isDark),
  
                  const SizedBox(height: 20),
  
                  AttendanceCard(isDark: isDark),
  
                  const SizedBox(height: 20),
  
                  BirthdayCard(isDark: isDark),
  
                  const SizedBox(height: 20),
  
                  UpcomingInterviewCard(isDark: isDark),
  
                  const SizedBox(height: 20),
  
                  const SizedBox(height: 20),
  
                  MessageCard(isDark: isDark),
  
                  const SizedBox(height: 20),
  
                  RecentActivityCard(),
  
                  WeeklyAttendanceCard(isDark: isDark),
  
                  const SizedBox(height: 20),
  
  
  
  
  
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
  
  //////////////////////////////////////////////////////////
  
  class CircleIcon extends StatelessWidget {
    final IconData icon;
    final bool isSelected;
    final VoidCallback onTap;
    final bool showBadge;
    final bool isSquare;
  
    const CircleIcon({
      super.key,
      required this.icon,
      required this.isSelected,
      required this.onTap,
      this.showBadge = false,
      this.isSquare = false,
    });
  
    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
                borderRadius: isSquare ? BorderRadius.circular(12) : null,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.08),
                  )
                ],
              ),
              child: Icon(
                icon,
                size: 24,
                color: isSelected ? Colors.blue : Colors.black,
              ),
            ),
  
            if (showBadge)
              Positioned(
                right: 3,
                top: 3,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
      );
    }
  }
  
  //////////////////////////////////////////////////////////
  
  class StatCard extends StatefulWidget {
    final String title;
    final String value;
    final IconData icon;
    final String change;
    final Color color;
    final bool isDark;
  
    const StatCard({
      super.key,
      required this.title,
      required this.value,
      required this.icon,
      required this.change,
      required this.color,
      required this.isDark,
    });
  
    @override
    State<StatCard> createState() => _StatCardState();
  }
  
  class _StatCardState extends State<StatCard> {
    bool isHover = false;
  
    @override
    Widget build(BuildContext context) {
      return MouseRegion(
        onEnter: (_) => setState(() => isHover = true),
        onExit: (_) => setState(() => isHover = false),
  
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
  
          /// 🔥 Upar uthva mate
          transform: Matrix4.translationValues(0, isHover ? -8 : 0, 0),
  
          padding: const EdgeInsets.all(18),
          margin: const EdgeInsets.symmetric(vertical: 8),
  
          decoration: BoxDecoration(
            color: widget.isDark ? Colors.grey[900] : Colors.white,
            borderRadius: BorderRadius.circular(22),
  
            /// 🔥 PREMIUM SHADOW
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isHover ? 0.15 : 0.08),
                blurRadius: isHover ? 30 : 18,
                spreadRadius: 1,
                offset: Offset(0, isHover ? 18 : 10),
              ),
            ],
  
            /// 🔥 soft border (premium look)
            border: Border.all(
              color: Colors.grey.withOpacity(0.08),
            ),
          ),
  
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
  
              /// LEFT TEXT
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                      style: TextStyle(
                          color:
                          widget.isDark ? Colors.white60 : Colors.grey,
                          fontSize: 12)),
  
                  const SizedBox(height: 8),
  
                  Text(widget.value,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: widget.isDark
                              ? Colors.white
                              : Colors.black)),
  
                  const SizedBox(height: 8),
  
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: widget.color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.arrow_upward,
                                size: 14, color: widget.color),
                            const SizedBox(width: 4),
                            Text(widget.change,
                                style: TextStyle(
                                    color: widget.color,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text("vs last month",
                          style: TextStyle(
                              fontSize: 12,
                              color: widget.isDark
                                  ? Colors.white60
                                  : Colors.grey)),
                    ],
                  )
                ],
              ),
  
              /// RIGHT ICON
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, color: widget.color, size: 22),
              )
            ],
          ),
        ),
      );
    }
  }
  
  //////////////////////////////////////////////////////////
  
  class EmployeeChartCard extends StatefulWidget {
    final bool isDark;
  
    const EmployeeChartCard({super.key, required this.isDark});
  
    @override
    State<EmployeeChartCard> createState() => _EmployeeChartCardState();
  }
  
  class _EmployeeChartCardState extends State<EmployeeChartCard> {
    int touchedIndex = -1;
  
    @override
    Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: widget.isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            Text(
              "Total Employees",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: widget.isDark ? Colors.white : Colors.black,
              ),
            ),
  
            const SizedBox(height: 20),
  
            SizedBox(
              height: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
  
                  Stack(
                    alignment: Alignment.center,
                    children: [
  
                      PieChart(
                        PieChartData(
                          startDegreeOffset: 270,
                          sectionsSpace: 0,
                          centerSpaceRadius: 55,
  
                          pieTouchData: PieTouchData(
                            touchCallback: (event, response) {
                              if (!event.isInterestedForInteractions ||
                                  response == null ||
                                  response.touchedSection == null) {
                                setState(() {
                                  touchedIndex = -1;
                                });
                                return;
                              }
  
                              setState(() {
                                touchedIndex =
                                    response.touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
  
                          sections: List.generate(2, (index) {
                            final isTouched = index == touchedIndex;
  
                            return PieChartSectionData(
                              value: index == 0 ? 65 : 35,
                              color: index == 0
                                  ? const Color(0xFF1E63E9)
                                  : const Color(0xFFE64980),
  
                              radius: isTouched ? 22 : 18,
                              showTitle: false, // 🔥 remove text from chart
                            );
                          }),
                        ),
                      ),
  
                      // 🔵 Center Number
                      Text(
                        "475",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: widget.isDark ? Colors.white : Colors.black,
                        ),
                      ),
  
                      // 🔥 TOOLTIP BOX
                      if (touchedIndex != -1)
                        Positioned(
                          top: touchedIndex == 0 ? 80 : 40,
                          left: touchedIndex == 0 ? 90 : 60,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: touchedIndex == 0
                                  ? const Color(0xFF1E63E9)
                                  : const Color(0xFFE64980),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              touchedIndex == 0 ? "Male\n307" : "Female\n168",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
  
                  Text(
                    "475",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: widget.isDark ? Colors.black : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
  
            const SizedBox(height: 10),
  
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.circle, size: 10, color: Color(0xFF1E63E9)),
                SizedBox(width: 5),
                Text("Male"),
                SizedBox(width: 20),
                Icon(Icons.circle, size: 10, color: Color(0xFFE64980)),
                SizedBox(width: 5),
                Text("Female"),
              ],
            ),
          ],
        ),
      );
    }
  }
  
  
  class SideMenu extends StatefulWidget {
    const SideMenu({super.key});
  
    @override
    State<SideMenu> createState() => _SideMenuState();
  }
  
  class _SideMenuState extends State<SideMenu> {
    int selectedIndex = 0;
    bool isLogoutSelected = false;
    bool showAdminMenu = false;
    bool showChartMenu = false;
    bool showAuthMenu = false; // ✅ FIXED
  
    @override
    Widget build(BuildContext context) {
      return Drawer(
        width: 260,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
  
                  const SizedBox(height: 20),
  
                  Row(
                    children: const [
                      Icon(Icons.rocket_launch, color: Colors.blue),
                      SizedBox(width: 10),
                      Text("Excelhr",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _menuItem(Icons.dashboard, "HR_DASHBOARD", 0),
                  _menuItem(Icons.group, "Employee", 1),
  
  
  
                  const SizedBox(height: 15),
  
                  /// ADMIN
                  /// ADMIN
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showAdminMenu = !showAdminMenu;
                      });
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.admin_panel_settings, color: Colors.grey),
                        const SizedBox(width: 10),
                        const Text("Administration"),
                        const Spacer(),
                        Icon(showAdminMenu
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
  
                  if (showAdminMenu) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: _bottomItem(Icons.person, "User Management", 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: _bottomItem(Icons.settings, "System Setting", 21),
                    ),
                  ],
  
                  /// 🔥 NEW REGISTER (OUTSIDE ADMIN)
                  const SizedBox(height: 10),
  
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showAuthMenu = !showAuthMenu; // reuse variable
                      });
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.app_registration, color: Colors.grey),
                        const SizedBox(width: 10),
                        const Text("Register"),
                        const Spacer(),
                        Icon(showAuthMenu
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
  
                  if (showAuthMenu) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: _bottomItem(Icons.policy, "HR Policies", 30),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: _bottomItem(Icons.description, "Employee Document", 31),
                    ),
  
                    /// 🔥 NEW SUPPORT ITEM
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: _bottomItem(Icons.support_agent, "Support", 32),
                    ),
                  ],
  
  
                  const SizedBox(height: 10),
  
                  _bottomItem(Icons.contacts, "Contacts", 3),
                  _bottomItem(Icons.calendar_month, "Calendar", 4),
  
                  /// CHART
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showChartMenu = !showChartMenu;
                      });
  
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const AnimatedDashboard(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.show_chart, color: Colors.grey),
                        const SizedBox(width: 10),
                        const Text("Charts"),
                        const Spacer(),
                        Icon(showChartMenu
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
  
                  if (showChartMenu) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: _chartSubItem("Echart", 50),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: _chartSubItem("Apex", 51, isActive: true),
                    ),
                  ],
                  const SizedBox(height: 20),
  
                  /// 🔥 AUTH MENU
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showAuthMenu = !showAuthMenu;
                      });
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.person_outline, color: Colors.grey),
                        const SizedBox(width: 10),
                        const Text("Authentication"),
                        const Spacer(),
                        Icon(showAuthMenu
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
  
                  if (showAuthMenu) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: _authSubItem("Sign In", 60),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: _authSubItem("Sign Up", 61),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: _authSubItem("Forgot Password", 62),
                    ),
                  ],
  
                  const SizedBox(height: 10),
  
                  _bottomItem(Icons.person, "Profile", 7),
                  _bottomItem(Icons.settings, "Settings", 8),
  
                  const SizedBox(height: 10),
  
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isLogoutSelected = true;
                      });
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.logout, color: Colors.red),
                        SizedBox(width: 10),
                        Text("Logout",
                            style: TextStyle(color: Colors.red)),
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
  
    ////////////////////////////////////////////

    Widget _menuItem(IconData icon, String text, int index) {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });

          Navigator.pop(context);

          // 🔥 DASHBOARD FIX
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HrDashboardScreen(),
              ),
            );
          }

          // 🔥 EMPLOYEE
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EmployeeScreen(),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey),
              const SizedBox(width: 10),
              Text(text),
            ],
          ),
        ),
      );
    }
  
    ////////////////////////////////////////////
  
    Widget _bottomItem(IconData icon, String text, int index) {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
  
          Navigator.pop(context);
  
          // 🔥 USER MANAGEMENT NAVIGATION
          if (text == "User Management") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UserManagementScreen(),
              ),
            );
          }
  
          // 🔥 SYSTEM SETTINGS
          if (text == "System Setting") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SystemSettingsScreen(),
              ),
            );
          }
  
          // 🔥 CONTACTS
          if (text == "Contacts") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ContactsScreen(),
              ),
            );
          }
  
          // 🔥 CALENDAR
          if (text == "Calendar") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CalendarScreen(),
              ),
            );
          }
          if (index == 30) {
            // future screen
          }
  

          if (index == 31) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EmployeeDocumentScreen(),
              ),
            );
          }
  
          // 🔥 SUPPORT
  
  
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey),
              const SizedBox(width: 10),
              Text(text),
            ],
          ),
        ),
      );
    }
  
    ////////////////////////////////////////////
  
    Widget _chartSubItem(String text, int index,
        {bool isActive = false}) {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
  
          Navigator.pop(context);
  
          if (index == 51) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                const AnimatedDashboard(),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              const Icon(Icons.arrow_right, size: 18),
              const SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(
                  color: isActive ? Colors.blue : Colors.black,
                  fontWeight:
                  isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      );
    }
  
    ////////////////////////////////////////////
  
    Widget _authSubItem(String text, int index) {
      bool selected = selectedIndex == index;
  
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
  
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              const Icon(Icons.arrow_right, size: 18),
              const SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(
                  color: selected ? Colors.blue : Colors.black,
                  fontWeight:
                  selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
  
    ////////////////////////////////////////////
  
  
  class RecruitmentCard extends StatelessWidget {
    final bool isDark;
  
    const RecruitmentCard({super.key, required this.isDark});
  
    @override
    Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withOpacity(0.05),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
  
            // 🔵 HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recruitment Overview",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
  
                Text(
                  "See all jobs",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
  
            const SizedBox(height: 15),
  
            _jobRow("Product Designer", 56, 30, 27, 3),
            _jobRow("Software Engineer", 17, 15, 13, 2),
            _jobRow("Web Developer", 41, 35, 31, 4),
            _jobRow("UI Designer", 24, 23, 18, 5),
          ],
        ),
      );
    }
  
    //////////////////////////////////////////////////////////
  
    Widget _jobRow(
        String title, int inbox, int interviewed, int rejected, int hired) {
  
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
  
            // 🔵 TITLE
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
  
            // 🔵 STATS
            Expanded(
              flex: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _miniStat(inbox, "Inbox"),
                  _miniStat(interviewed, "Interviewed"),
                  _miniStat(rejected, "Rejected"),
                ],
              ),
            ),
  
            // 🔵 HIRED BOX
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F0FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    "$hired",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Hired",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.blue,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    }
  
    //////////////////////////////////////////////////////////
  
    Widget _miniStat(int value, String label) {
      return Column(
        children: [
          Text(
            "$value",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.white60 : Colors.grey,
            ),
          ),
        ],
      );
    }
  }
  //////////////////////////////////////////////////////////
  
  //////////////////////////////////////////////////////////
  
  class PayrollChartCard extends StatelessWidget {
    final bool isDark;
  
    const PayrollChartCard({super.key, required this.isDark});
  
    @override
    Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withOpacity(0.05),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
  
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
  
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "MONTHLY PAYROLL",
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "\$3,230,250.00",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
  
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "OVERTIME",
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "\$150,000.00",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
  
            const SizedBox(height: 15),
  
            Row(
              children: [
                _Legend(color: Color(0xFF1E63E9), text: "Monthly"),
                SizedBox(width: 15),
                _Legend(color: Color(0xFF8E5CF6), text: "Overtime"),
                SizedBox(width: 15),
                _Legend(color: Color(0xFFE64980), text: "Bonuses"),
              ],
            ),
  
            const SizedBox(height: 20),
  
            SizedBox(
              height: 230,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceBetween,
                  maxY: 250,
  
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipRoundedRadius: 8,
                      tooltipMargin: 10,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
  
                        const months = [
                          "Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"
                        ];
  
                        String type;
                        if (rodIndex == 0) {
                          type = "Monthly Payroll";
                        } else if (rodIndex == 1) {
                          type = "Overtime";
                        } else {
                          type = "Bonuses";
                        }
  
                        return BarTooltipItem(
                          "(${months[group.x]}, \$${rod.toY.toInt()}) $type",
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        );
                      },
                    ),
                  ),
  
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 100,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.2),
                        strokeWidth: 1,
                      );
                    },
                  ),
  
                  borderData: FlBorderData(show: false),
  
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 100,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            "\$${value.toInt()}",
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark ? Colors.white60 : Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
  
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const months = [
                            "Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"
                          ];
                          return Text(
                            months[value.toInt()],
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark ? Colors.white60 : Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
  
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                  ),
  
                  barGroups: _getBarData(),
                ),
              ),
            ),
          ],
        ),
      );
    }
  
    List<BarChartGroupData> _getBarData() {
      final List<double> monthly = [100, 140, 130, 170, 140, 180, 160, 210, 230];
      final List<double> overtime = [60, 80, 70, 90, 75, 95, 85, 100, 110];
      final List<double> bonus = [30, 40, 35, 50, 38, 55, 45, 60, 50];
  
      return List.generate(9, (i) {
        return BarChartGroupData(
          x: i,
          barRods: [
            _rod(monthly[i], const Color(0xFF1E63E9)),
            _rod(overtime[i], const Color(0xFF8E5CF6)),
            _rod(bonus[i], const Color(0xFFE64980)),
          ],
        );
      });
    }
  
    BarChartRodData _rod(double y, Color color) {
      return BarChartRodData(
        toY: y,
        width: 6,
        borderRadius: BorderRadius.circular(4),
        color: color,
      );
    }
  }
  class _Legend extends StatelessWidget {
    final Color color;
    final String text;
  
    const _Legend({required this.color, required this.text});
  
    @override
    Widget build(BuildContext context) {
      return Row(
        children: [
          Icon(Icons.circle, size: 10, color: color),
          const SizedBox(width: 5),
          Text(text),
        ],
      );
    }
  }
  class AttendanceCard extends StatelessWidget {
    final bool isDark;
  
    const AttendanceCard({super.key, required this.isDark});
  
    @override
    Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withOpacity(0.05),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
  
            // 🔵 HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Attendance Overview",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
  
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    "View Details",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                )
              ],
            ),
  
            const SizedBox(height: 15),
  
            // 🔵 TABLE HEADER
            Row(
              children: [
                _headerText("Employee Name", flex: 3),
                _headerText("Designation", flex: 3),
                _headerText("Type", flex: 2),
                _headerText("Check In Time", flex: 3),
                _headerText("Status", flex: 2),
              ],
            ),
  
            const Divider(),
  
            // 🔵 LIST
            _employeeRow(
              "Leslie Alexander",
              "Data Analyst",
              "Office",
              "09:15 AM",
              "On Time",
              true,
              "assets/images/f5.png",
            ),
            _employeeRow(
              "Darlene Robertson",
              "Web Designer",
              "Office",
              "10:15 AM",
              "Late",
              false,
              "assets/images/f2.png",
            ),
  
            _employeeRow(
              "Jacob Jones",
              "Medical Assistant",
              "Remote",
              "10:24 AM",
              "Late",
              false,
              "assets/images/f3.jpg",
            ),
  
            _employeeRow(
              "Kathryn Murphy",
              "Marketing Coordinator",
              "Office",
              "09:10 AM",
              "On Time",
              true,
              "assets/images/f4.png",
            ),
            _employeeRow(
              "Leasie Watson",
              "Team Lead Design",
              "Office",
              "09:27 AM",
              "On Time",
              true,
              "assets/images/f1.jpg",
            ),
  
            const SizedBox(height: 8),
  
            // 🔵 BOTTOM SCROLL LINE
            Container(
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      );
    }
  
    //////////////////////////////////////////////////////////
  
    Widget _headerText(String text, {required int flex}) {
      return Expanded(
        flex: flex,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
  
    //////////////////////////////////////////////////////////
  
    Widget _employeeRow(
        String name,
        String role,
        String type,
        String time,
        String status,
        bool isOnTime,
        String imagePath,
        ) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
  
            // 🔵 PROFILE + NAME
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage(imagePath),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
  
            // 🔵 ROLE
            Expanded(
              flex: 3,
              child: Text(
                role,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white70 : Colors.grey,
                ),
              ),
            ),
  
            // 🔵 TYPE
            Expanded(
              flex: 2,
              child: Text(
                type,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white70 : Colors.grey,
                ),
              ),
            ),
  
            // 🔵 TIME
            Expanded(
              flex: 3,
              child: Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white70 : Colors.grey,
                ),
              ),
            ),
  
            // 🔵 STATUS
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isOnTime
                      ? Colors.green.withOpacity(0.15)
                      : Colors.red.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: isOnTime ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
  
  class BirthdayCard extends StatelessWidget {
    final bool isDark;
  
    const BirthdayCard({super.key, required this.isDark});
  
    @override
    Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFE9EEF8),
              const Color(0xFFD9E3F5),
            ],
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
  
            // 🔵 Left Side
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
  
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(
                          "https://randomuser.me/api/portraits/women/44.jpg",
                        ),
                      ),
  
                      const SizedBox(width: 10),
  
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Mehjabin Rahman",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Has Birthday Today",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
  
                  const SizedBox(height: 12),
  
                  // 🔵 Button
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withValues(alpha: 0.3),
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: const Text(
                      "Wish Her",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
  
            // 🔵 Right Icon (Cake)
            const Icon(
              Icons.cake,
              size: 60,
              color: Colors.grey,
            ),
          ],
        ),
      );
    }
  }
  class UpcomingInterviewCard extends StatelessWidget {
    final bool isDark;
  
    const UpcomingInterviewCard({super.key, required this.isDark});
  
    @override
    Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withOpacity(0.05),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
  
            // 🔵 HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Upcoming Interviews",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
  
                Text(
                  "Today, 17 Nov 2024",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
  
            const SizedBox(height: 15),
  
            // 🔵 LIST
            _interviewRow("10.30", "Web Developer", "Robinson Cruso"),
            _interviewRow("11.45", "UI/UX Designer", "Rabiul Basher"),
            _interviewRow("12.30", "Software Engineer", "Rohan Robin"),
  
            const SizedBox(height: 15),
  
            // 🔵 BUTTON
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.blue.withOpacity(0.3),
                  )
                ],
              ),
              child: const Center(
                child: Text(
                  "View more interviews",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
  
    ////////////////////////////////////////////////////
  
    Widget _interviewRow(String time, String role, String name) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
  
            // 🔵 TIME
            SizedBox(
              width: 60,
              child: Text(
                time,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
  
            // 🔵 LINE
            Container(
              width: 1,
              height: 50,
              color: Colors.grey.shade300,
            ),
  
            const SizedBox(width: 10),
  
            // 🔵 CARD
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F7FB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
  
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          role,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
  
                    const Icon(Icons.more_horiz, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
  class MessageCard extends StatelessWidget {
    final bool isDark;
  
    const MessageCard({super.key, required this.isDark});
  
    @override
    Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withOpacity(0.05),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
  
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "New Message",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const Icon(Icons.more_horiz, color: Colors.grey),
              ],
            ),
  
            const SizedBox(height: 15),
  
            /// LIST
            _messageRow(
                "assets/images/f1.jpg",
                "Tayeb Rahman",
                "Great service by Nyales thank...",
                true),
  
            _messageRow(
                "assets/images/f3.jpg",
                "Tayeb Rahman",
                "Great service by Nyales thank...",
                true),
  
            _messageRow("assets/images/f2.png", "Taranta Aley", "I want to Leave for Today...", false),
          ],
        ),
      );
    }
  
    ////////////////////////////////////////////////////
  
    Widget _messageRow(
        String image, String name, String msg, bool isOnline) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
  
            /// PROFILE
            Stack(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: AssetImage(image),
                ),
  
                if (isOnline)
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  )
              ],
            ),
  
            const SizedBox(width: 10),
  
            /// TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    msg,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
  
            /// BLUE DOT
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            )
          ],
        ),
      );
    }
  }
  class RecentActivityCard extends StatelessWidget {
    const RecentActivityCard({super.key});
  
    @override
    Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF1E63E9),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              color: Colors.blue.withOpacity(0.4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
  
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recent Activity",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "10:40 AM",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
              ],
            ),
  
            const SizedBox(height: 15),
  
            /// TITLE
            const Text(
              "You Posted a New Job",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
  
            const SizedBox(height: 8),
  
            /// DESC
            const Text(
              "Kindly check the requirements and terms of work and make sure everything is right.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
  
            const SizedBox(height: 15),
  
            /// FOOTER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
  
                const Text(
                  "Today: 12 Activities",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
  
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "See All Activity",
                    style: TextStyle(
                      color: Color(0xFF1E63E9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      );
    }
  }
  class SettingsDrawer extends StatelessWidget {
    final bool isDark;
    final Color primaryColor;
    final Function(bool) onThemeChange;
    final Function(Color) onColorChange;
  
    const SettingsDrawer({
      super.key,
      required this.isDark,
      required this.primaryColor,
      required this.onThemeChange,
      required this.onColorChange,
    });
  
    @override
    Widget build(BuildContext context) {
      return Drawer(
        width: 320,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
  
                const Text("Select Layout",
                    style: TextStyle(fontWeight: FontWeight.bold)),
  
                const SizedBox(height: 10),
  
                _layoutCard("Light", !isDark),
                _layoutCard("Dark", isDark),
  
                const SizedBox(height: 20),
  
                const Text("Sidebar Menu Color",
                    style: TextStyle(fontWeight: FontWeight.bold)),
  
                const SizedBox(height: 10),
  
                Row(
                  children: [
                    _toggleBtn("Light", !isDark, () {
                      onThemeChange(false);
                    }),
                    _toggleBtn("Dark", isDark, () {
                      onThemeChange(true);
                    }),
                  ],
                ),
  
                const SizedBox(height: 20),
  
                const Text("Color Theme",
                    style: TextStyle(fontWeight: FontWeight.bold)),
  
                const SizedBox(height: 10),
  
                Wrap(
                  spacing: 10,
                  children: [
                    _colorCircle(Colors.black),
                    _colorCircle(const Color(0xFF5B6EF5)),
                    _colorCircle(Colors.orange),
                    _colorCircle(Colors.teal),
                    _colorCircle(Colors.green),
                    _colorCircle(Colors.blue),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  
    //////////////////////////////////////////////////////////
  
    Widget _layoutCard(String text, bool selected) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
              color: selected ? Colors.blue : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(selected ? Icons.check_circle : Icons.circle_outlined,
                color: selected ? Colors.blue : Colors.grey),
            const SizedBox(width: 10),
            Text(text),
          ],
        ),
      );
    }
  
    //////////////////////////////////////////////////////////
  
    Widget _toggleBtn(String text, bool selected, VoidCallback onTap) {
      return Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFF5B6EF5) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
      );
    }
  
    //////////////////////////////////////////////////////////
  
    Widget _colorCircle(Color color) {
      return GestureDetector(
        onTap: () => onColorChange(color),
        child: CircleAvatar(
          backgroundColor: color,
          child: primaryColor == color
              ? const Icon(Icons.check, color: Colors.white, size: 16)
              : null,
        ),
      );
    }
  }
  class WeeklyAttendanceCard extends StatelessWidget {
    final bool isDark;
  
    const WeeklyAttendanceCard({super.key, required this.isDark});
  
    @override
    Widget build(BuildContext context) {
  
      final List<double> present = [230, 210, 220, 240, 215];
      final List<double> absent = [10, 18, 12, 6, 14];
      final List<double> late = [12, 15, 10, 8, 11];
  
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withOpacity(0.05),
            )
          ],
        ),
  
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
  
            /// TITLE
            Text(
              "Weekly Attendance",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
  
            const SizedBox(height: 10),
  
            /// LEGEND
            Row(
              children: const [
                Icon(Icons.circle, size: 10, color: Colors.green),
                SizedBox(width: 5),
                Text("Present"),
                SizedBox(width: 20),
                Icon(Icons.circle, size: 10, color: Colors.red),
                SizedBox(width: 5),
                Text("Absent"),
                SizedBox(width: 20),
                Icon(Icons.circle, size: 10, color: Colors.orange),
                SizedBox(width: 5),
                Text("Late"),
              ],
            ),
  
            const SizedBox(height: 20),
  
            /// BAR CHART
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  maxY: 260,
                  alignment: BarChartAlignment.spaceAround,
  
                  borderData: FlBorderData(show: false),
  
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 50,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.2),
                        strokeWidth: 1,
                      );
                    },
                  ),
  
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, interval: 50),
                    ),
  
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
  
                          const days = [
                            "Mon",
                            "Tue",
                            "Wed",
                            "Thu",
                            "Fri"
                          ];
  
                          return Text(
                            days[value.toInt()],
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white60 : Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
  
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
  
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
  
                  barGroups: List.generate(5, (index) {
                    return BarChartGroupData(
                      x: index,
                      barsSpace: 3,
                      barRods: [
  
                        /// PRESENT
                        BarChartRodData(
                          toY: present[index],
                          width: 6,
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
  
                        /// ABSENT
                        BarChartRodData(
                          toY: absent[index],
                          width: 6,
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
  
                        /// LATE
                        BarChartRodData(
                          toY: late[index],
                          width: 6,
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
  
            const SizedBox(height: 20),
  
            /// BUTTONS
            Row(
              children: [
  
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9EEF8),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Text(
                        "View Full Attendance History",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
  
                const SizedBox(width: 10),
  
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9EEF8),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Text(
                        "Generate Attendance Report",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }
  }
