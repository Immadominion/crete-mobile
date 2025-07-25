import 'package:flutter/material.dart';

import 'voice_models.dart';

/// Comprehensive event model for the event management system
class VoiceEvent {
  final String id;
  final String title;
  final String description;
  final String? communityId;
  final String? communityName;
  final VoiceSessionType type;
  final EventStatus status;
  final DateTime startTime;
  final DateTime? endTime;
  final Duration? duration;
  final int maxParticipants;
  final EventRecurrence? recurrence;
  final EventPrivacy privacy;
  final String hostId;
  final String hostName;
  final String? hostAvatarUrl;
  final List<String> coHostIds;
  final List<EventRSVP> rsvps;
  final List<String> tags;
  final String? imageUrl;
  final String? locationUrl;
  final EventReminder? reminder;
  final bool allowWaitlist;
  final int waitlistCount;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? metadata;

  const VoiceEvent({
    required this.id,
    required this.title,
    required this.description,
    this.communityId,
    this.communityName,
    required this.type,
    required this.status,
    required this.startTime,
    this.endTime,
    this.duration,
    this.maxParticipants = 50,
    this.recurrence,
    this.privacy = EventPrivacy.community,
    required this.hostId,
    required this.hostName,
    this.hostAvatarUrl,
    this.coHostIds = const [],
    this.rsvps = const [],
    this.tags = const [],
    this.imageUrl,
    this.locationUrl,
    this.reminder,
    this.allowWaitlist = false,
    this.waitlistCount = 0,
    required this.createdAt,
    this.updatedAt,
    this.metadata,
  });

  /// Get the number of participants who have RSVP'd as 'going'
  int get goingCount =>
      rsvps.where((rsvp) => rsvp.response == RSVPResponse.going).length;

  /// Get the number of participants who have RSVP'd as 'maybe'
  int get maybeCount =>
      rsvps.where((rsvp) => rsvp.response == RSVPResponse.maybe).length;

  /// Get the number of participants who have RSVP'd as 'not going'
  int get notGoingCount =>
      rsvps.where((rsvp) => rsvp.response == RSVPResponse.notGoing).length;

  /// Check if the event is full
  bool get isFull => goingCount >= maxParticipants;

  /// Check if the event has a waitlist
  bool get hasWaitlist => allowWaitlist && isFull;

  /// Get time until event starts
  Duration get timeUntilStart => startTime.difference(DateTime.now());

  /// Get human readable time until start
  String get timeUntilStartText {
    final duration = timeUntilStart;

    if (duration.isNegative) {
      if (status == EventStatus.active) {
        return 'Live now';
      } else {
        return 'Event has passed';
      }
    }

    if (duration.inDays > 7) {
      return 'In ${(duration.inDays / 7).floor()} week${(duration.inDays / 7).floor() > 1 ? 's' : ''}';
    } else if (duration.inDays > 0) {
      return 'In ${duration.inDays} day${duration.inDays > 1 ? 's' : ''}';
    } else if (duration.inHours > 0) {
      return 'In ${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return 'In ${duration.inMinutes}m';
    } else {
      return 'Starting soon';
    }
  }

  /// Get formatted date and time
  String get formattedDateTime {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDay = DateTime(startTime.year, startTime.month, startTime.day);

    String dateText;
    if (eventDay == today) {
      dateText = 'Today';
    } else if (eventDay == today.add(const Duration(days: 1))) {
      dateText = 'Tomorrow';
    } else if (eventDay.difference(today).inDays < 7) {
      const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      dateText = weekdays[eventDay.weekday - 1];
    } else {
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
      dateText = '${months[startTime.month - 1]} ${startTime.day}';
    }

    final hour = startTime.hour;
    final minute = startTime.minute;
    final ampm = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final timeText = '$displayHour:${minute.toString().padLeft(2, '0')} $ampm';

    return '$dateText at $timeText';
  }

  /// Check if user has RSVP'd to this event
  RSVPResponse? getUserRSVP(String userId) {
    final rsvp = rsvps.where((r) => r.userId == userId).firstOrNull;
    return rsvp?.response;
  }

  /// Check if user is the host or co-host
  bool isUserHost(String userId) {
    return hostId == userId || coHostIds.contains(userId);
  }

  VoiceEvent copyWith({
    String? id,
    String? title,
    String? description,
    String? communityId,
    String? communityName,
    VoiceSessionType? type,
    EventStatus? status,
    DateTime? startTime,
    DateTime? endTime,
    Duration? duration,
    int? maxParticipants,
    EventRecurrence? recurrence,
    EventPrivacy? privacy,
    String? hostId,
    String? hostName,
    String? hostAvatarUrl,
    List<String>? coHostIds,
    List<EventRSVP>? rsvps,
    List<String>? tags,
    String? imageUrl,
    String? locationUrl,
    EventReminder? reminder,
    bool? allowWaitlist,
    int? waitlistCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return VoiceEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      communityId: communityId ?? this.communityId,
      communityName: communityName ?? this.communityName,
      type: type ?? this.type,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      recurrence: recurrence ?? this.recurrence,
      privacy: privacy ?? this.privacy,
      hostId: hostId ?? this.hostId,
      hostName: hostName ?? this.hostName,
      hostAvatarUrl: hostAvatarUrl ?? this.hostAvatarUrl,
      coHostIds: coHostIds ?? this.coHostIds,
      rsvps: rsvps ?? this.rsvps,
      tags: tags ?? this.tags,
      imageUrl: imageUrl ?? this.imageUrl,
      locationUrl: locationUrl ?? this.locationUrl,
      reminder: reminder ?? this.reminder,
      allowWaitlist: allowWaitlist ?? this.allowWaitlist,
      waitlistCount: waitlistCount ?? this.waitlistCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Event status enumeration
enum EventStatus {
  draft,
  scheduled,
  active,
  ended,
  cancelled;

  String get displayName {
    switch (this) {
      case EventStatus.draft:
        return 'Draft';
      case EventStatus.scheduled:
        return 'Scheduled';
      case EventStatus.active:
        return 'Live';
      case EventStatus.ended:
        return 'Ended';
      case EventStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case EventStatus.draft:
        return const Color(0xFF6B7280);
      case EventStatus.scheduled:
        return const Color(0xFF3B82F6);
      case EventStatus.active:
        return const Color(0xFF10B981);
      case EventStatus.ended:
        return const Color(0xFF6B7280);
      case EventStatus.cancelled:
        return const Color(0xFFEF4444);
    }
  }
}

/// Event privacy settings
enum EventPrivacy {
  public,
  community,
  private;

  String get displayName {
    switch (this) {
      case EventPrivacy.public:
        return 'Public';
      case EventPrivacy.community:
        return 'Community Only';
      case EventPrivacy.private:
        return 'Private';
    }
  }

  String get description {
    switch (this) {
      case EventPrivacy.public:
        return 'Anyone can join';
      case EventPrivacy.community:
        return 'Community members only';
      case EventPrivacy.private:
        return 'Invite only';
    }
  }
}

/// RSVP response types
enum RSVPResponse {
  going,
  maybe,
  notGoing;

  String get displayName {
    switch (this) {
      case RSVPResponse.going:
        return 'Going';
      case RSVPResponse.maybe:
        return 'Maybe';
      case RSVPResponse.notGoing:
        return 'Not Going';
    }
  }

  String get emoji {
    switch (this) {
      case RSVPResponse.going:
        return '✅';
      case RSVPResponse.maybe:
        return '❓';
      case RSVPResponse.notGoing:
        return '❌';
    }
  }
}

/// RSVP model
class EventRSVP {
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final RSVPResponse response;
  final DateTime timestamp;
  final String? note;

  const EventRSVP({
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.response,
    required this.timestamp,
    this.note,
  });

  EventRSVP copyWith({
    String? userId,
    String? userName,
    String? userAvatarUrl,
    RSVPResponse? response,
    DateTime? timestamp,
    String? note,
  }) {
    return EventRSVP(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      response: response ?? this.response,
      timestamp: timestamp ?? this.timestamp,
      note: note ?? this.note,
    );
  }
}

/// Event recurrence settings
class EventRecurrence {
  final RecurrenceType type;
  final int interval;
  final List<int>? daysOfWeek; // 1-7 for Monday-Sunday
  final int? dayOfMonth;
  final DateTime? endDate;
  final int? maxOccurrences;

  const EventRecurrence({
    required this.type,
    this.interval = 1,
    this.daysOfWeek,
    this.dayOfMonth,
    this.endDate,
    this.maxOccurrences,
  });

  String get displayText {
    switch (type) {
      case RecurrenceType.none:
        return 'No recurrence';
      case RecurrenceType.daily:
        return interval == 1 ? 'Daily' : 'Every $interval days';
      case RecurrenceType.weekly:
        return interval == 1 ? 'Weekly' : 'Every $interval weeks';
      case RecurrenceType.monthly:
        return interval == 1 ? 'Monthly' : 'Every $interval months';
      case RecurrenceType.yearly:
        return interval == 1 ? 'Yearly' : 'Every $interval years';
    }
  }
}

enum RecurrenceType { none, daily, weekly, monthly, yearly }

/// Event reminder settings
class EventReminder {
  final Duration beforeEvent;
  final ReminderType type;
  final bool isEnabled;

  const EventReminder({
    required this.beforeEvent,
    required this.type,
    this.isEnabled = true,
  });

  String get displayText {
    final duration = beforeEvent;
    if (duration.inDays > 0) {
      return '${duration.inDays} day${duration.inDays > 1 ? 's' : ''} before';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hour${duration.inHours > 1 ? 's' : ''} before';
    } else {
      return '${duration.inMinutes} minute${duration.inMinutes > 1 ? 's' : ''} before';
    }
  }
}

enum ReminderType {
  notification,
  email,
  both;

  String get displayName {
    switch (this) {
      case ReminderType.notification:
        return 'Push Notification';
      case ReminderType.email:
        return 'Email';
      case ReminderType.both:
        return 'Both';
    }
  }
}

/// Event notification model
class EventNotification {
  final String id;
  final String eventId;
  final String userId;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime scheduledTime;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? data;

  const EventNotification({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    required this.scheduledTime,
    this.isRead = false,
    required this.createdAt,
    this.data,
  });
}

enum NotificationType {
  eventReminder,
  eventStarting,
  eventCancelled,
  eventUpdated,
  rsvpUpdate,
  hostChange;

  String get displayName {
    switch (this) {
      case NotificationType.eventReminder:
        return 'Event Reminder';
      case NotificationType.eventStarting:
        return 'Event Starting';
      case NotificationType.eventCancelled:
        return 'Event Cancelled';
      case NotificationType.eventUpdated:
        return 'Event Updated';
      case NotificationType.rsvpUpdate:
        return 'RSVP Update';
      case NotificationType.hostChange:
        return 'Host Change';
    }
  }
}

/// Event series model for recurring events
class EventSeries {
  final String id;
  final String title;
  final EventRecurrence recurrence;
  final List<String> eventIds;
  final DateTime createdAt;
  final bool isActive;

  const EventSeries({
    required this.id,
    required this.title,
    required this.recurrence,
    required this.eventIds,
    required this.createdAt,
    this.isActive = true,
  });
}
