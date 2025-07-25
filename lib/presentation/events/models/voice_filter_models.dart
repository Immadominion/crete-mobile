import 'voice_models.dart';

/// Filter criteria for voice sessions
class VoiceFilters {
  final Set<VoiceSessionType> sessionTypes;
  final Set<VoiceSessionStatus> sessionStatuses;
  final bool onlyJoinedSessions;
  final bool onlyWithEvents;
  final DateRange? dateRange;
  final int? minParticipants;
  final int? maxParticipants;

  const VoiceFilters({
    this.sessionTypes = const {},
    this.sessionStatuses = const {},
    this.onlyJoinedSessions = false,
    this.onlyWithEvents = false,
    this.dateRange,
    this.minParticipants,
    this.maxParticipants,
  });

  bool get hasActiveFilters =>
      sessionTypes.isNotEmpty ||
      sessionStatuses.isNotEmpty ||
      onlyJoinedSessions ||
      onlyWithEvents ||
      dateRange != null ||
      minParticipants != null ||
      maxParticipants != null;

  VoiceFilters copyWith({
    Set<VoiceSessionType>? sessionTypes,
    Set<VoiceSessionStatus>? sessionStatuses,
    bool? onlyJoinedSessions,
    bool? onlyWithEvents,
    DateRange? dateRange,
    int? minParticipants,
    int? maxParticipants,
    bool clearDateRange = false,
    bool clearMinParticipants = false,
    bool clearMaxParticipants = false,
  }) {
    return VoiceFilters(
      sessionTypes: sessionTypes ?? this.sessionTypes,
      sessionStatuses: sessionStatuses ?? this.sessionStatuses,
      onlyJoinedSessions: onlyJoinedSessions ?? this.onlyJoinedSessions,
      onlyWithEvents: onlyWithEvents ?? this.onlyWithEvents,
      dateRange: clearDateRange ? null : (dateRange ?? this.dateRange),
      minParticipants: clearMinParticipants
          ? null
          : (minParticipants ?? this.minParticipants),
      maxParticipants: clearMaxParticipants
          ? null
          : (maxParticipants ?? this.maxParticipants),
    );
  }

  VoiceFilters clear() {
    return const VoiceFilters();
  }
}

/// Date range filter for sessions
class DateRange {
  final DateTime start;
  final DateTime end;

  const DateRange({required this.start, required this.end});

  bool contains(DateTime date) {
    return date.isAfter(start) && date.isBefore(end);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateRange &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end;

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}

/// Sort options for voice sessions
enum VoiceSortOption {
  newest,
  oldest,
  mostParticipants,
  leastParticipants,
  alphabetical,
  duration,
}

extension VoiceSortOptionExtension on VoiceSortOption {
  String get displayName {
    switch (this) {
      case VoiceSortOption.newest:
        return 'Newest First';
      case VoiceSortOption.oldest:
        return 'Oldest First';
      case VoiceSortOption.mostParticipants:
        return 'Most Participants';
      case VoiceSortOption.leastParticipants:
        return 'Least Participants';
      case VoiceSortOption.alphabetical:
        return 'A-Z';
      case VoiceSortOption.duration:
        return 'Longest Duration';
    }
  }

  String get description {
    switch (this) {
      case VoiceSortOption.newest:
        return 'Recently started sessions first';
      case VoiceSortOption.oldest:
        return 'Oldest sessions first';
      case VoiceSortOption.mostParticipants:
        return 'Sessions with more participants first';
      case VoiceSortOption.leastParticipants:
        return 'Sessions with fewer participants first';
      case VoiceSortOption.alphabetical:
        return 'Sort by session title';
      case VoiceSortOption.duration:
        return 'Longest running sessions first';
    }
  }
}

/// Search and filter state for voice hub
class VoiceHubState {
  final String searchQuery;
  final VoiceFilters filters;
  final VoiceSortOption sortOption;
  final bool isSearchActive;
  final bool isFilterActive;

  const VoiceHubState({
    this.searchQuery = '',
    this.filters = const VoiceFilters(),
    this.sortOption = VoiceSortOption.newest,
    this.isSearchActive = false,
    this.isFilterActive = false,
  });

  bool get hasActiveSearch => searchQuery.isNotEmpty;
  bool get hasActiveFilters => filters.hasActiveFilters;
  bool get hasAnyFilters => hasActiveSearch || hasActiveFilters;

  VoiceHubState copyWith({
    String? searchQuery,
    VoiceFilters? filters,
    VoiceSortOption? sortOption,
    bool? isSearchActive,
    bool? isFilterActive,
  }) {
    return VoiceHubState(
      searchQuery: searchQuery ?? this.searchQuery,
      filters: filters ?? this.filters,
      sortOption: sortOption ?? this.sortOption,
      isSearchActive: isSearchActive ?? this.isSearchActive,
      isFilterActive: isFilterActive ?? this.isFilterActive,
    );
  }

  VoiceHubState clearSearch() {
    return copyWith(searchQuery: '', isSearchActive: false);
  }

  VoiceHubState clearFilters() {
    return copyWith(filters: const VoiceFilters(), isFilterActive: false);
  }

  VoiceHubState clearAll() {
    return const VoiceHubState();
  }
}
