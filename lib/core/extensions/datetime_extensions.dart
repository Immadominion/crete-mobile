extension DateTimeExtensions on DateTime {
  /// Checks if the date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Checks if the date was yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Checks if the date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Checks if the date is in the current week
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// Checks if the date is in the current month
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /// Checks if the date is in the current year
  bool get isThisYear {
    final now = DateTime.now();
    return year == now.year;
  }

  /// Gets the start of the day (00:00:00)
  DateTime get startOfDay => DateTime(year, month, day);

  /// Gets the end of the day (23:59:59.999)
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Gets the start of the week (Monday)
  DateTime get startOfWeek {
    final daysFromMonday = weekday - 1;
    return startOfDay.subtract(Duration(days: daysFromMonday));
  }

  /// Gets the end of the week (Sunday)
  DateTime get endOfWeek {
    final daysToSunday = 7 - weekday;
    return endOfDay.add(Duration(days: daysToSunday));
  }

  /// Gets the start of the month
  DateTime get startOfMonth => DateTime(year, month);

  /// Gets the end of the month
  DateTime get endOfMonth {
    final nextMonth = month == 12
        ? DateTime(year + 1)
        : DateTime(year, month + 1);
    return nextMonth.subtract(const Duration(days: 1));
  }

  /// Gets the start of the year
  DateTime get startOfYear => DateTime(year);

  /// Gets the end of the year
  DateTime get endOfYear => DateTime(year, 12, 31, 23, 59, 59, 999);

  /// Checks if the date is a weekend
  bool get isWeekend => weekday == DateTime.saturday || weekday == DateTime.sunday;

  /// Checks if the date is a weekday
  bool get isWeekday => !isWeekend;

  /// Gets the time ago string
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()} week${(difference.inDays / 7).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  /// Gets the time remaining until this date
  String get timeRemaining {
    final now = DateTime.now();
    final difference = this.difference(now);

    if (difference.isNegative) {
      return 'Ended';
    }

    if (difference.inDays > 0) {
      return '${difference.inDays}d ${difference.inHours % 24}h remaining';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ${difference.inMinutes % 60}m remaining';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m remaining';
    } else {
      return 'Less than 1m remaining';
    }
  }

  /// Formats the date for chat timestamps
  String get chatTimestamp {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (isToday) {
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    } else if (isYesterday) {
      return 'Yesterday ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return '${weekdays[weekday - 1]} ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    } else {
      return '$month/$day/$year';
    }
  }

  /// Formats the date in a human-readable way
  String get humanReadable {
    if (isToday) {
      return 'Today';
    } else if (isYesterday) {
      return 'Yesterday';
    } else if (isTomorrow) {
      return 'Tomorrow';
    } else if (isThisWeek) {
      final weekdays = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];
      return weekdays[weekday - 1];
    } else if (isThisYear) {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[month - 1]} $day';
    } else {
      return '$month/$day/$year';
    }
  }

  /// Gets the quarter of the year (1-4)
  int get quarter => ((month - 1) ~/ 3) + 1;

  /// Gets the week number of the year
  int get weekOfYear {
    final startOfYear = DateTime(year);
    final dayOfYear = difference(startOfYear).inDays + 1;
    return ((dayOfYear - weekday + 10) / 7).floor();
  }

  /// Checks if this year is a leap year
  bool get isLeapYear => (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));

  /// Gets the number of days in this month
  int get daysInMonth {
    switch (month) {
      case 2:
        return isLeapYear ? 29 : 28;
      case 4:
      case 6:
      case 9:
      case 11:
        return 30;
      default:
        return 31;
    }
  }

  /// Adds business days (excluding weekends)
  DateTime addBusinessDays(int days) {
    var result = this;
    var addedDays = 0;

    while (addedDays < days) {
      result = result.add(const Duration(days: 1));
      if (result.isWeekday) {
        addedDays++;
      }
    }

    return result;
  }

  /// Gets the age from this birth date
  int get age {
    final now = DateTime.now();
    int age = now.year - year;

    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }

    return age;
  }

  /// Converts to timestamp (milliseconds since epoch)
  int get timestamp => millisecondsSinceEpoch;

  /// Formats as ISO 8601 string
  String get iso8601 => toIso8601String();

  /// Formats as UTC string
  String get utc => toUtc().toString();

  /// Gets the month name
  String get monthName {
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

  /// Gets the short month name
  String get shortMonthName {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  /// Gets the weekday name
  String get weekdayName {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return weekdays[weekday - 1];
  }

  /// Gets the short weekday name
  String get shortWeekdayName {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday - 1];
  }

  /// Checks if the date is between two other dates
  bool isBetween(DateTime start, DateTime end) => isAfter(start) && isBefore(end);

  /// Checks if the date is the same as another date (ignoring time)
  bool isSameDate(DateTime other) => year == other.year && month == other.month && day == other.day;
}
