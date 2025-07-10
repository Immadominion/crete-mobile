import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';

/// A service for formatting dates and times with localization support
class LocalizedDateTimeFormatter {

  LocalizedDateTimeFormatter(this._l10n);
  final AppLocalizations _l10n;

  /// Format a time ago string with proper localization
  String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return _l10n.justNow;
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return minutes == 1 
        ? _l10n.minuteAgo(minutes)
        : _l10n.minutesAgo(minutes);
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return hours == 1
        ? _l10n.hourAgo(hours)
        : _l10n.hoursAgo(hours);
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return days == 1
        ? _l10n.dayAgo(days)
        : _l10n.daysAgo(days);
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return weeks == 1
        ? _l10n.weekAgo(weeks)
        : _l10n.weeksAgo(weeks);
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return months == 1
        ? _l10n.monthAgo(months)
        : _l10n.monthsAgo(months);
    } else {
      final years = (difference.inDays / 365).floor();
      return years == 1
        ? _l10n.yearAgo(years)
        : _l10n.yearsAgo(years);
    }
  }

  /// Format a time remaining string with proper localization
  String formatTimeRemaining(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.isNegative) {
      return _l10n.ended;
    }

    if (difference.inDays > 0) {
      return '${difference.inDays}d ${difference.inHours % 24}h ${_l10n.remaining}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ${difference.inMinutes % 60}m ${_l10n.remaining}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ${_l10n.remaining}';
    } else {
      return _l10n.lessThanMinute;
    }
  }

  /// Format a date for display based on how recent it is
  String formatDisplayDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));
    final targetDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (targetDate == today) {
      return _l10n.today;
    } else if (targetDate == yesterday) {
      return _l10n.yesterday;
    } else if (targetDate == tomorrow) {
      return _l10n.tomorrow;
    } else {
      // Return formatted date
      return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
    }
  }

  /// Format a chat timestamp
  String formatChatTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return '${_l10n.yesterday} ${_formatTime(dateTime)}';
      } else if (difference.inDays < 7) {
        final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
        return '${weekdays[dateTime.weekday - 1]} ${_formatTime(dateTime)}';
      } else {
        return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
      }
    } else {
      return _formatTime(dateTime);
    }
  }

  /// Format time in 12-hour format
  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12
        ? dateTime.hour - 12
        : (dateTime.hour == 0 ? 12 : dateTime.hour);
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}

/// Extension to easily get a localized formatter from BuildContext
extension LocalizedDateTimeFormatterExtension on BuildContext {
  LocalizedDateTimeFormatter get dateTimeFormatter {
    final l10n = AppLocalizations.of(this);
    return LocalizedDateTimeFormatter(l10n);
  }
}
