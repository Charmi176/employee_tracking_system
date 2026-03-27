import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool showHolidayOnly = false;
  String viewMode = "month";



  bool isHoliday(DateTime day) {
    return day.day % 5 == 0;
  }
  Map<String, String> getRandomHoliday(DateTime day) {
    final Map<String, Map<String, String>> holidays = {
      "2026-04-10": {
        "title": "Festival Holiday",
        "desc": "Festival celebration holiday."
      },
      "2026-04-15": {
        "title": "Public Holiday",
        "desc": "Government declared holiday."
      },
      "2026-04-20": {
        "title": "Company Holiday",
        "desc": "Company closed today."
      },
    };

    String key =
        "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";

    return holidays[key] ??
        {
          "title": "",
          "desc": "",
        };
  }
  void _showHolidayDialog(DateTime day) {
    final holiday = getRandomHoliday(day);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text(
          holiday['title']!,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(   // 🔥 HARD ENGLISH
              "Date",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 5),
            Text(
              "${day.day} ${_monthName(day.month)}, ${day.year}",
            ),
            const SizedBox(height: 10),
            Text(holiday['desc']!),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"), // 🔥 ENGLISH
          )
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F7FF), // Soft Blue Background
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Calendar",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(color: Colors.blue.withOpacity(0.1), blurRadius: 20, spreadRadius: 5)
                    ],
                  ),
                  child: isMobile
                      ? Column(
                    children: [
                      _calendarFilter(),
                      const SizedBox(height: 20),
                      _calendarView(),
                    ],
                  )
                      : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _calendarFilter(),
                      const SizedBox(width: 30),
                      Expanded(child: _calendarView()),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _calendarFilter() {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text("Add Event"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          const SizedBox(height: 25),
          const Text("MY CALENDARS", style: TextStyle(letterSpacing: 1.2, fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 12)),
          Row(
            children: [
              Checkbox(
                activeColor: Colors.blue,
                value: showHolidayOnly,
                onChanged: (v) => setState(() => showHolidayOnly = v!),
              ),
              const Text("Holiday", style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          )
        ],
      ),
    );
  }

  Widget _calendarView() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(onPressed: () => setState(() => focusedDay = DateTime(focusedDay.year, focusedDay.month - 1)), icon: const Icon(Icons.chevron_left, color: Colors.blue)),
                IconButton(onPressed: () => setState(() => focusedDay = DateTime(focusedDay.year, focusedDay.month + 1)), icon: const Icon(Icons.chevron_right, color: Colors.blue)),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => setState(() => focusedDay = DateTime.now()),
                  style: TextButton.styleFrom(backgroundColor: Colors.blue.shade50),
                  child: const Text("today", style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
            Text("${_monthName(focusedDay.month)} ${focusedDay.year}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            _viewToggle(),
          ],
        ),
        const SizedBox(height: 20),
        _monthView(),
      ],
    );
  }

  Widget _viewToggle() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: ["month", "week"].map((m) => _modeBtn(m)).toList(),
      ),
    );
  }

  Widget _monthView() {
    return TableCalendar(
      firstDay: DateTime.utc(2003),
      lastDay: DateTime.utc(2030),
      focusedDay: focusedDay,
      headerVisible: false,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          this.focusedDay = focusedDay;
        });
        if (isHoliday(selectedDay)) {
          _showHolidayDialog(selectedDay);
        }
      },
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          if (showHolidayOnly && !isHoliday(day)) return const SizedBox();

          if (isHoliday(day)) {
            final holiday = getRandomHoliday(day);

            return Container(
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${day.day}",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Flexible( // ✅ FIX
                    child: Text(
                      holiday['title']!,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Colors.blue,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1, // ✅ FIX
                    ),
                  ),
                ],
              ),
            );
          }

          return null;
        },
      ),
    );
  }

  Widget _modeBtn(String text) {
    bool active = viewMode == text;
    return GestureDetector(
      onTap: () => setState(() => viewMode = text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(text, style: TextStyle(color: active ? Colors.white : Colors.blueGrey, fontWeight: FontWeight.bold)),
      ),
    );
  }

  String _monthName(int m) {
    const months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    return months[m - 1];
  }
}