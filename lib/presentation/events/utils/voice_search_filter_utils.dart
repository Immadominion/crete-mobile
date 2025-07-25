import '../models/voice_models.dart';
import '../models/voice_filter_models.dart';
import '../models/voice_event_models.dart';

class VoiceSearchAndFilterUtils {
  /// Filters and sorts a list of voice sessions based on search query and filters
  static List<VoiceSession> filterAndSortSessions({
    required List<VoiceSession> sessions,
    required String searchQuery,
    required VoiceFilters filters,
    required VoiceSortOption sortOption,
  }) {
    var filteredSessions = sessions;

    // Apply text search
    if (searchQuery.isNotEmpty) {
      filteredSessions = _applyTextSearch(filteredSessions, searchQuery);
    }

    // Apply filters
    filteredSessions = _applyFilters(filteredSessions, filters);

    // Apply sorting
    filteredSessions = _applySorting(filteredSessions, sortOption);

    return filteredSessions;
  }

  /// Applies text search to filter sessions
  static List<VoiceSession> _applyTextSearch(
    List<VoiceSession> sessions,
    String query,
  ) {
    final lowerQuery = query.toLowerCase();
    return sessions.where((session) {
      return session.title.toLowerCase().contains(lowerQuery) ||
          (session.communityName?.toLowerCase().contains(lowerQuery) ??
              false) ||
          session.typeDisplayName.toLowerCase().contains(lowerQuery) ||
          (session.eventDescription?.toLowerCase().contains(lowerQuery) ??
              false) ||
          session.participants.any(
            (participant) =>
                participant.name.toLowerCase().contains(lowerQuery),
          );
    }).toList();
  }

  /// Applies filters to sessions
  static List<VoiceSession> _applyFilters(
    List<VoiceSession> sessions,
    VoiceFilters filters,
  ) {
    return sessions.where((session) {
      // Filter by session types
      if (filters.sessionTypes.isNotEmpty &&
          !filters.sessionTypes.contains(session.type)) {
        return false;
      }

      // Filter by session status
      if (filters.sessionStatuses.isNotEmpty &&
          !filters.sessionStatuses.contains(session.status)) {
        return false;
      }

      // Filter by joined sessions only
      if (filters.onlyJoinedSessions && !session.isJoined) {
        return false;
      }

      // Filter by events only
      if (filters.onlyWithEvents && !session.hasScheduledEvent) {
        return false;
      }

      // Filter by minimum participants
      if (filters.minParticipants != null &&
          session.participants.length < filters.minParticipants!) {
        return false;
      }

      // Filter by maximum participants
      if (filters.maxParticipants != null &&
          session.participants.length > filters.maxParticipants!) {
        return false;
      }

      // Filter by date range
      if (filters.dateRange != null) {
        if (!filters.dateRange!.contains(session.startTime)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  /// Applies sorting to sessions
  static List<VoiceSession> _applySorting(
    List<VoiceSession> sessions,
    VoiceSortOption sortOption,
  ) {
    final sortedSessions = List<VoiceSession>.from(sessions);

    switch (sortOption) {
      case VoiceSortOption.newest:
        sortedSessions.sort((a, b) => b.startTime.compareTo(a.startTime));
        break;
      case VoiceSortOption.oldest:
        sortedSessions.sort((a, b) => a.startTime.compareTo(b.startTime));
        break;
      case VoiceSortOption.mostParticipants:
        sortedSessions.sort(
          (a, b) => b.participants.length.compareTo(a.participants.length),
        );
        break;
      case VoiceSortOption.leastParticipants:
        sortedSessions.sort(
          (a, b) => a.participants.length.compareTo(b.participants.length),
        );
        break;
      case VoiceSortOption.alphabetical:
        sortedSessions.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        break;
      case VoiceSortOption.duration:
        sortedSessions.sort((a, b) => b.duration.compareTo(a.duration));
        break;
    }

    return sortedSessions;
  }

  /// Generates search suggestions based on recent searches and available data
  static List<String> generateSearchSuggestions({
    required List<VoiceSession> sessions,
    required List<String> recentSearches,
    required String currentQuery,
  }) {
    final suggestions = <String>[];

    if (currentQuery.isEmpty) {
      // Return recent searches when no query
      suggestions.addAll(recentSearches.take(5));
    } else {
      // Generate suggestions based on current query
      final lowerQuery = currentQuery.toLowerCase();

      // Add matching session titles
      final titleMatches = sessions
          .where((session) => session.title.toLowerCase().contains(lowerQuery))
          .map((session) => session.title)
          .toSet()
          .take(3);
      suggestions.addAll(titleMatches);

      // Add matching community names
      final communityMatches = sessions
          .where(
            (session) =>
                session.communityName?.toLowerCase().contains(lowerQuery) ??
                false,
          )
          .map((session) => session.communityName!)
          .toSet()
          .take(2);
      suggestions.addAll(communityMatches);

      // Add matching session types
      final typeMatches = VoiceSessionType.values
          .where(
            (type) => _getSessionTypeDisplayName(
              type,
            ).toLowerCase().contains(lowerQuery),
          )
          .map((type) => _getSessionTypeDisplayName(type))
          .take(2);
      suggestions.addAll(typeMatches);
    }

    return suggestions.take(8).toList();
  }

  /// Gets display name for session type
  static String _getSessionTypeDisplayName(VoiceSessionType type) {
    switch (type) {
      case VoiceSessionType.voice:
        return 'Voice Chat';
      case VoiceSessionType.video:
        return 'Video Call';
      case VoiceSessionType.game:
        return 'Gaming Session';
      case VoiceSessionType.studySession:
        return 'Study Together';
      case VoiceSessionType.meeting:
        return 'Meeting';
      case VoiceSessionType.event:
        return 'Community Event';
    }
  }

  /// Checks if any filters are currently active
  static bool hasActiveFilters({
    required String searchQuery,
    required VoiceFilters filters,
    required VoiceSortOption sortOption,
  }) {
    return searchQuery.isNotEmpty ||
        filters.hasActiveFilters ||
        sortOption != VoiceSortOption.newest;
  }

  /// Gets a description of currently active filters
  static String getActiveFiltersDescription({
    required String searchQuery,
    required VoiceFilters filters,
    required VoiceSortOption sortOption,
  }) {
    final descriptions = <String>[];

    if (searchQuery.isNotEmpty) {
      descriptions.add('Search: "$searchQuery"');
    }

    if (filters.sessionTypes.isNotEmpty) {
      final types = filters.sessionTypes
          .map((type) => _getSessionTypeDisplayName(type))
          .join(', ');
      descriptions.add('Types: $types');
    }

    if (filters.sessionStatuses.isNotEmpty) {
      final statuses = filters.sessionStatuses
          .map((status) {
            switch (status) {
              case VoiceSessionStatus.active:
                return 'Active';
              case VoiceSessionStatus.scheduled:
                return 'Scheduled';
              case VoiceSessionStatus.ended:
                return 'Ended';
              case VoiceSessionStatus.cancelled:
                return 'Cancelled';
            }
          })
          .join(', ');
      descriptions.add('Status: $statuses');
    }

    if (filters.onlyJoinedSessions) {
      descriptions.add('Only joined sessions');
    }

    if (filters.onlyWithEvents) {
      descriptions.add('Only events');
    }

    if (filters.minParticipants != null) {
      descriptions.add('Min ${filters.minParticipants}+ participants');
    }

    if (sortOption != VoiceSortOption.newest) {
      descriptions.add('Sort: ${sortOption.displayName}');
    }

    return descriptions.join(' • ');
  }

  /// Separates sessions by categories for better organization
  static Map<String, List<VoiceSession>> categorizeFilteredSessions(
    List<VoiceSession> sessions,
  ) {
    final categories = <String, List<VoiceSession>>{};

    // Separate active sessions
    final activeSessions = sessions
        .where((s) => s.status == VoiceSessionStatus.active)
        .toList();
    if (activeSessions.isNotEmpty) {
      categories['Active Sessions'] = activeSessions;
    }

    // Separate scheduled sessions
    final scheduledSessions = sessions
        .where((s) => s.status == VoiceSessionStatus.scheduled)
        .toList();
    if (scheduledSessions.isNotEmpty) {
      categories['Scheduled Events'] = scheduledSessions;
    }

    // Separate recent sessions
    final recentSessions = sessions
        .where((s) => s.status == VoiceSessionStatus.ended)
        .toList();
    if (recentSessions.isNotEmpty) {
      categories['Recent Activity'] = recentSessions;
    }

    return categories;
  }

  /// Filters and sorts a list of voice events based on search query and filters
  static List<VoiceEvent> filterAndSortEvents({
    required List<VoiceEvent> events,
    required String searchQuery,
    required VoiceFilters filters,
    required VoiceSortOption sortOption,
  }) {
    var filteredEvents = events;

    // Apply text search
    if (searchQuery.isNotEmpty) {
      filteredEvents = _applyEventTextSearch(filteredEvents, searchQuery);
    }

    // Apply filters (reuse session filters logic where applicable)
    filteredEvents = _applyEventFilters(filteredEvents, filters);

    // Apply sorting
    filteredEvents = _applyEventSorting(filteredEvents, sortOption);

    return filteredEvents;
  }

  /// Applies text search to filter events
  static List<VoiceEvent> _applyEventTextSearch(
    List<VoiceEvent> events,
    String query,
  ) {
    final lowerQuery = query.toLowerCase();
    return events.where((event) {
      return event.title.toLowerCase().contains(lowerQuery) ||
          event.description.toLowerCase().contains(lowerQuery) ||
          (event.communityName?.toLowerCase().contains(lowerQuery) ?? false) ||
          event.hostName.toLowerCase().contains(lowerQuery) ||
          event.tags.any((tag) => tag.toLowerCase().contains(lowerQuery)) ||
          event.rsvps.any(
            (rsvp) => rsvp.userName.toLowerCase().contains(lowerQuery),
          );
    }).toList();
  }

  /// Applies filters to events
  static List<VoiceEvent> _applyEventFilters(
    List<VoiceEvent> events,
    VoiceFilters filters,
  ) {
    var filtered = events;

    // Filter by types
    if (filters.sessionTypes.isNotEmpty) {
      filtered = filtered.where((event) {
        return filters.sessionTypes.contains(event.type);
      }).toList();
    }

    // Filter by status
    if (filters.sessionStatuses.isNotEmpty) {
      filtered = filtered.where((event) {
        final sessionStatus = _eventStatusToSessionStatus(event.status);
        return filters.sessionStatuses.contains(sessionStatus);
      }).toList();
    }

    // Filter by participant count
    if (filters.minParticipants != null && filters.minParticipants! > 0) {
      filtered = filtered.where((event) {
        return event.goingCount >= filters.minParticipants!;
      }).toList();
    }

    // Filter by max participant count
    if (filters.maxParticipants != null) {
      filtered = filtered.where((event) {
        return event.goingCount <= filters.maxParticipants!;
      }).toList();
    }

    // Filter by joined events only
    if (filters.onlyJoinedSessions) {
      // In a real app, check if current user has RSVP'd as going
      filtered = filtered.where((event) {
        return event.rsvps.any(
          (rsvp) =>
              rsvp.userId == 'current_user' &&
              rsvp.response == RSVPResponse.going,
        );
      }).toList();
    }

    // Filter by only events with specific criteria
    if (filters.onlyWithEvents) {
      // Filter to only events (not voice sessions)
      filtered = filtered
          .where((event) => event.type == VoiceSessionType.event)
          .toList();
    }

    return filtered;
  }

  /// Applies sorting to events
  static List<VoiceEvent> _applyEventSorting(
    List<VoiceEvent> events,
    VoiceSortOption sortOption,
  ) {
    switch (sortOption) {
      case VoiceSortOption.newest:
        return events..sort((a, b) => b.startTime.compareTo(a.startTime));
      case VoiceSortOption.oldest:
        return events..sort((a, b) => a.startTime.compareTo(b.startTime));
      case VoiceSortOption.mostParticipants:
        return events..sort((a, b) => b.goingCount.compareTo(a.goingCount));
      case VoiceSortOption.leastParticipants:
        return events..sort((a, b) => a.goingCount.compareTo(b.goingCount));
      case VoiceSortOption.alphabetical:
        return events..sort((a, b) => a.title.compareTo(b.title));
      case VoiceSortOption.duration:
        return events..sort((a, b) {
          final aDuration = a.duration ?? Duration.zero;
          final bDuration = b.duration ?? Duration.zero;
          return bDuration.compareTo(aDuration);
        });
    }
  }

  /// Helper method to convert event status to session status
  static VoiceSessionStatus _eventStatusToSessionStatus(EventStatus status) {
    switch (status) {
      case EventStatus.draft:
        return VoiceSessionStatus.scheduled;
      case EventStatus.active:
        return VoiceSessionStatus.active;
      case EventStatus.scheduled:
        return VoiceSessionStatus.scheduled;
      case EventStatus.ended:
        return VoiceSessionStatus.ended;
      case EventStatus.cancelled:
        return VoiceSessionStatus.ended;
    }
  }

  /// Categorizes events for display
  static Map<String, List<VoiceEvent>> categorizeEvents(
    List<VoiceEvent> events,
  ) {
    final categories = <String, List<VoiceEvent>>{};

    // Separate active events
    final activeEvents = events
        .where((e) => e.status == EventStatus.active)
        .toList();
    if (activeEvents.isNotEmpty) {
      categories['Live Events'] = activeEvents;
    }

    // Separate upcoming events
    final upcomingEvents = events
        .where((e) => e.status == EventStatus.scheduled)
        .toList();
    if (upcomingEvents.isNotEmpty) {
      categories['Upcoming Events'] = upcomingEvents;
    }

    // Separate recent events
    final recentEvents = events
        .where((e) => e.status == EventStatus.ended)
        .toList();
    if (recentEvents.isNotEmpty) {
      categories['Recent Events'] = recentEvents;
    }

    return categories;
  }
}
