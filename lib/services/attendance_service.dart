class AttendanceService {
  // 🔥 MAIN STATUS LOGIC
  static String getStatus(DateTime now) {
    final int totalMinutes = now.hour * 60 + now.minute;

    // 10:00 AM → 1:00 PM (Working)
    if (totalMinutes >= 600 && totalMinutes < 780) {
      return "Working";
    }

    // 1:00 PM → 2:00 PM (Break)
    else if (totalMinutes >= 780 && totalMinutes < 840) {
      return "Break";
    }

    // 2:00 PM → 7:00 PM (Working)
    else if (totalMinutes >= 840 && totalMinutes < 1140) {
      return "Working";
    }

    // After 7:00 PM
    else if (totalMinutes >= 1140) {
      return "Completed";
    }

    // Before 10:00 AM
    else {
      return "Not Started";
    }
  }

  // 🔥 TIME FORMAT (UI ma use kari sako)
  static String formatTime(DateTime now) {
    int hour = now.hour;
    int minute = now.minute;

    String period = hour >= 12 ? "PM" : "AM";

    hour = hour % 12;
    if (hour == 0) hour = 12;

    String min = minute.toString().padLeft(2, '0');

    return "$hour:$min $period";
  }

  // 🔥 OPTIONAL: TOTAL WORKING HOURS CALCULATE
  static String calculateWorkingHours() {
    final now = DateTime.now();

    // Office timing (10 AM to 7 PM)
    final start = DateTime(now.year, now.month, now.day, 10, 0);
    final breakStart = DateTime(now.year, now.month, now.day, 13, 0);
    final breakEnd = DateTime(now.year, now.month, now.day, 14, 0);
    final end = DateTime(now.year, now.month, now.day, 19, 0);

    if (now.isBefore(start)) return "0h 0m";

    DateTime effectiveEnd = now.isAfter(end) ? end : now;

    Duration total = effectiveEnd.difference(start);

    // Remove break time (1 hour)
    if (effectiveEnd.isAfter(breakStart)) {
      Duration breakDuration = breakEnd.difference(breakStart);
      total = total - breakDuration;
    }

    int hours = total.inHours;
    int minutes = total.inMinutes % 60;

    return "${hours}h ${minutes}m";
  }
}