class DateUtils {
  /// Checks if two dates are on the same day
  static bool isSameDay(DateTime date1, DateTime date2) =>
      date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;

  /// Checks if a date is today
  static bool isToday(DateTime date) => isSameDay(date, DateTime.now());

  /// Checks if a date was yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }

  /// Checks if a date is in the current week
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// Gets the start of the day (00:00:00)
  static DateTime startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  /// Gets the end of the day (23:59:59)
  static DateTime endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59);

  /// Gets the start of the week (Monday)
  static DateTime startOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return startOfDay(date.subtract(Duration(days: daysFromMonday)));
  }

  /// Gets the end of the week (Sunday)
  static DateTime endOfWeek(DateTime date) {
    final daysToSunday = 7 - date.weekday;
    return endOfDay(date.add(Duration(days: daysToSunday)));
  }

  /// Gets the start of the month
  static DateTime startOfMonth(DateTime date) =>
      DateTime(date.year, date.month);

  /// Gets the end of the month
  static DateTime endOfMonth(DateTime date) {
    final nextMonth = date.month == 12
        ? DateTime(date.year + 1)
        : DateTime(date.year, date.month + 1);
    return nextMonth.subtract(const Duration(days: 1));
  }

  /// Calculates the difference in days between two dates
  static int daysBetween(DateTime start, DateTime end) {
    final startDate = startOfDay(start);
    final endDate = startOfDay(end);
    return endDate.difference(startDate).inDays;
  }

  /// Calculates the difference in hours between two dates
  static int hoursBetween(DateTime start, DateTime end) =>
      end.difference(start).inHours;

  /// Calculates the difference in minutes between two dates
  static int minutesBetween(DateTime start, DateTime end) =>
      end.difference(start).inMinutes;

  /// Adds business days to a date (excluding weekends)
  static DateTime addBusinessDays(DateTime date, int days) {
    var result = date;
    var addedDays = 0;

    while (addedDays < days) {
      result = result.add(const Duration(days: 1));
      if (result.weekday < 6) {
        // Monday = 1, Friday = 5
        addedDays++;
      }
    }

    return result;
  }

  /// Checks if a date is a weekend (Saturday or Sunday)
  static bool isWeekend(DateTime date) {
    return date.weekday == 6 || date.weekday == 7; // Saturday = 6, Sunday = 7
  }

  /// Checks if a date is a weekday (Monday to Friday)
  static bool isWeekday(DateTime date) => !isWeekend(date);

  /// Gets the age in years from a birth date
  static int getAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;

    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  /// Formats a duration into a human-readable string
  static String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  /// Gets the time until a future date
  static Duration timeUntil(DateTime futureDate) =>
      futureDate.difference(DateTime.now());

  /// Gets the time since a past date
  static Duration timeSince(DateTime pastDate) =>
      DateTime.now().difference(pastDate);

  /// Creates a DateTime from a timestamp (milliseconds since epoch)
  static DateTime fromTimestamp(int timestamp) =>
      DateTime.fromMillisecondsSinceEpoch(timestamp);

  /// Converts a DateTime to a timestamp (milliseconds since epoch)
  static int toTimestamp(DateTime dateTime) => dateTime.millisecondsSinceEpoch;

  /// Checks if a year is a leap year
  static bool isLeapYear(int year) =>
      (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));

  /// Gets the number of days in a month
  static int daysInMonth(int year, int month) {
    switch (month) {
      case 2:
        return isLeapYear(year) ? 29 : 28;
      case 4:
      case 6:
      case 9:
      case 11:
        return 30;
      default:
        return 31;
    }
  }

  /// Gets the quarter of the year (1-4) for a given date
  static int getQuarter(DateTime date) => ((date.month - 1) ~/ 3) + 1;

  /// Gets the week number of the year
  static int getWeekOfYear(DateTime date) {
    final startOfYear = DateTime(date.year);
    final dayOfYear = date.difference(startOfYear).inDays + 1;
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  /// Creates a list of dates between two dates
  static List<DateTime> getDateRange(DateTime start, DateTime end) {
    final dates = <DateTime>[];
    var current = startOfDay(start);
    final endDate = startOfDay(end);

    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      dates.add(current);
      current = current.add(const Duration(days: 1));
    }

    return dates;
  }

  /// Gets the name of the month
  static String getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  /// Gets the name of the day of the week
  static String getDayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[weekday - 1];
  }
}
