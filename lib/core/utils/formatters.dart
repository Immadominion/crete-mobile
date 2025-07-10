class Formatters {
  // Number formatting
  static String number(num value, {int? decimalPlaces}) {
    if (decimalPlaces != null) {
      return value.toStringAsFixed(decimalPlaces);
    }
    return value.toString();
  }

  static String currency(num value, {String symbol = r'$'}) => '$symbol${value.toStringAsFixed(2)}';

  static String percent(num value, {int decimalPlaces = 1}) => '${(value * 100).toStringAsFixed(decimalPlaces)}%';

  static String compact(num value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }

  // Token amount formatting
  static String tokenAmount(
    num value, {
    String? symbol,
    int decimalPlaces = 2,
  }) {
    final formattedValue = value.toStringAsFixed(decimalPlaces);
    return symbol != null ? '$formattedValue $symbol' : formattedValue;
  }

  // Solana amount formatting (handles lamports)
  static String solAmount(int lamports) {
    final sol = lamports / 1000000000; // Convert lamports to SOL
    return '${sol.toStringAsFixed(4)} SOL';
  }

  // Wallet address formatting
  static String walletAddress(
    String address, {
    int startChars = 4,
    int endChars = 4,
  }) {
    if (address.length <= startChars + endChars) {
      return address;
    }
    return '${address.substring(0, startChars)}...${address.substring(address.length - endChars)}';
  }

  // Date formatting
  static String date(DateTime dateTime) => '${dateTime.month}/${dateTime.day}/${dateTime.year}';

  static String time(DateTime dateTime) {
    final hour = dateTime.hour > 12
        ? dateTime.hour - 12
        : (dateTime.hour == 0 ? 12 : dateTime.hour);
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  static String dateTime(DateTime dateTime) => '${date(dateTime)} ${time(dateTime)}';

  static String shortDate(DateTime dateTime) => '${dateTime.month}/${dateTime.day}/${dateTime.year}';

  static String longDate(DateTime dateTime) {
    final months = [
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
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }

  // Relative time formatting
  static String relativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return date(dateTime);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  // Chat timestamp formatting
  static String chatTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'Yesterday ${time(dateTime)}';
      } else if (difference.inDays < 7) {
        final weekdays = [
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
          'Sunday',
        ];
        return '${weekdays[dateTime.weekday - 1]} ${time(dateTime)}';
      } else {
        return shortDate(dateTime);
      }
    } else {
      return time(dateTime);
    }
  }

  // Proposal duration formatting
  static String proposalDuration(DateTime startTime, DateTime endTime) {
    final duration = endTime.difference(startTime);

    if (duration.inDays > 0) {
      return '${duration.inDays} day${duration.inDays > 1 ? 's' : ''}';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hour${duration.inHours > 1 ? 's' : ''}';
    } else {
      return '${duration.inMinutes} minute${duration.inMinutes > 1 ? 's' : ''}';
    }
  }

  // Time remaining formatting
  static String timeRemaining(DateTime endTime) {
    final now = DateTime.now();
    final remaining = endTime.difference(now);

    if (remaining.isNegative) {
      return 'Ended';
    }

    if (remaining.inDays > 0) {
      return '${remaining.inDays}d ${remaining.inHours % 24}h remaining';
    } else if (remaining.inHours > 0) {
      return '${remaining.inHours}h ${remaining.inMinutes % 60}m remaining';
    } else if (remaining.inMinutes > 0) {
      return '${remaining.inMinutes}m remaining';
    } else {
      return 'Less than 1m remaining';
    }
  }

  // File size formatting
  static String fileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  // Member count formatting
  static String memberCount(int count) {
    if (count < 1000) {
      return count.toString();
    } else if (count < 1000000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
  }

  // Vote count formatting
  static String voteCount(int count) {
    return memberCount(count); // Same logic as member count
  }

  // Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Title case formatting
  static String titleCase(String text) => text.split(' ').map((word) => capitalize(word)).join(' ');
}
