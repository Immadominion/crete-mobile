import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../models/voice_models.dart';
import '../models/voice_event_models.dart';
import '../widgets/search_suggestion_item.dart';

/// Smart search suggestions generator
class SmartSearchSuggestions {
  /// Generates intelligent search suggestions based on query and context
  static List<SearchSuggestion> generateSuggestions({
    required String query,
    required List<VoiceSession> sessions,
    required List<VoiceEvent> events,
    required List<String> recentSearches,
    int maxSuggestions = 8,
  }) {
    final suggestions = <SearchSuggestion>[];
    final lowerQuery = query.toLowerCase();

    // If no query, show recent searches and quick actions
    if (query.isEmpty) {
      return _generateEmptyQuerySuggestions(recentSearches, sessions, events);
    }

    // Smart matching based on query type
    if (_isUserQuery(query)) {
      suggestions.addAll(_generateUserSuggestions(query, sessions, events));
    }

    if (_isCommunityQuery(query)) {
      suggestions.addAll(
        _generateCommunitySuggestions(query, sessions, events),
      );
    }

    if (_isEventQuery(query)) {
      suggestions.addAll(_generateEventSuggestions(query, events));
    }

    if (_isSessionQuery(query)) {
      suggestions.addAll(_generateSessionSuggestions(query, sessions));
    }

    // Add filter suggestions based on query
    suggestions.addAll(_generateFilterSuggestions(query));

    // Add action suggestions
    suggestions.addAll(_generateActionSuggestions(query));

    // Sort by relevance and limit
    suggestions.sort(
      (a, b) => _calculateRelevance(
        b,
        lowerQuery,
      ).compareTo(_calculateRelevance(a, lowerQuery)),
    );

    return suggestions.take(maxSuggestions).toList();
  }

  /// Generates suggestions for empty query state
  static List<SearchSuggestion> _generateEmptyQuerySuggestions(
    List<String> recentSearches,
    List<VoiceSession> sessions,
    List<VoiceEvent> events,
  ) {
    final suggestions = <SearchSuggestion>[];

    // Recent searches (limit to 3)
    for (final search in recentSearches.take(3)) {
      suggestions.add(SearchSuggestion.recent(search));
    }

    // Quick actions
    suggestions.addAll([
      SearchSuggestion.action(
        text: 'Create new event',
        icon: PhosphorIcons.plus(),
        onTap: () {},
      ),
      SearchSuggestion.action(
        text: 'Browse communities',
        icon: PhosphorIcons.users(),
        onTap: () {},
      ),
      SearchSuggestion.action(
        text: 'Find active calls',
        icon: PhosphorIcons.waveform(),
        onTap: () {},
      ),
    ]);

    // Trending communities (from sessions)
    final communities = _extractCommunities(sessions);
    for (final community in communities.take(2)) {
      suggestions.add(community);
    }

    return suggestions;
  }

  /// Generates user-related suggestions
  static List<SearchSuggestion> _generateUserSuggestions(
    String query,
    List<VoiceSession> sessions,
    List<VoiceEvent> events,
  ) {
    final suggestions = <SearchSuggestion>[];
    final lowerQuery = query.toLowerCase();

    // Extract users from sessions and events
    final users = <String, Map<String, dynamic>>{};

    // From sessions
    for (final session in sessions) {
      for (final participant in session.participants) {
        if (participant.name.toLowerCase().contains(lowerQuery)) {
          users[participant.id] = {
            'name': participant.name,
            'isHost': participant.isHost,
            'isSpeaking': participant.isSpeaking,
            'avatarUrl': participant.avatarUrl,
            'sessionCount':
                (users[participant.id]?['sessionCount'] as int? ?? 0) + 1,
          };
        }
      }
    }

    // From events
    for (final event in events) {
      if (event.hostName.toLowerCase().contains(lowerQuery)) {
        users[event.hostId] = {
          'name': event.hostName,
          'isHost': true,
          'avatarUrl': event.hostAvatarUrl,
          'eventCount': (users[event.hostId]?['eventCount'] as int? ?? 0) + 1,
        };
      }
    }

    // Convert to suggestions
    for (final user in users.values) {
      final isHost = user['isHost'] as bool? ?? false;
      final status = isHost ? 'Host' : 'Member';
      suggestions.add(
        SearchSuggestion.user(
          name: user['name'] as String,
          status: status,
          isVerified: isHost,
          imageUrl: user['avatarUrl'] as String?,
        ),
      );
    }

    return suggestions;
  }

  /// Generates community-related suggestions
  static List<SearchSuggestion> _generateCommunitySuggestions(
    String query,
    List<VoiceSession> sessions,
    List<VoiceEvent> events,
  ) {
    final suggestions = <SearchSuggestion>[];
    final lowerQuery = query.toLowerCase();
    final communities = <String, Map<String, dynamic>>{};

    // Extract communities from sessions
    for (final session in sessions) {
      if (session.communityName != null &&
          session.communityName!.toLowerCase().contains(lowerQuery)) {
        final name = session.communityName!;
        communities[name] = {
          'name': name,
          'memberCount':
              (communities[name]?['memberCount'] as int? ?? 0) +
              session.participants.length,
          'sessionCount': (communities[name]?['sessionCount'] as int? ?? 0) + 1,
          'hasActiveSession': session.status == VoiceSessionStatus.active,
        };
      }
    }

    // Extract communities from events
    for (final event in events) {
      if (event.communityName != null &&
          event.communityName!.toLowerCase().contains(lowerQuery)) {
        final name = event.communityName!;
        communities[name] = {
          'name': name,
          'memberCount':
              (communities[name]?['memberCount'] as int? ?? 0) +
              event.goingCount,
          'eventCount': (communities[name]?['eventCount'] as int? ?? 0) + 1,
        };
      }
    }

    // Convert to suggestions
    for (final community in communities.values) {
      suggestions.add(
        SearchSuggestion.community(
          name: community['name'] as String,
          memberCount: community['memberCount'] as int? ?? 0,
          isVerified: (community['sessionCount'] as int? ?? 0) > 2,
        ),
      );
    }

    return suggestions;
  }

  /// Generates event-related suggestions
  static List<SearchSuggestion> _generateEventSuggestions(
    String query,
    List<VoiceEvent> events,
  ) {
    final suggestions = <SearchSuggestion>[];
    final lowerQuery = query.toLowerCase();

    for (final event in events) {
      if (_eventMatchesQuery(event, lowerQuery)) {
        suggestions.add(
          SearchSuggestion.event(
            title: event.title,
            timestamp:
                event.startTime, // Using startTime instead of scheduledTime
            hostName: event.hostName,
            isLive:
                event.status ==
                EventStatus.active, // Using active instead of live
          ),
        );
      }
    }

    return suggestions;
  }

  /// Generates session-related suggestions
  static List<SearchSuggestion> _generateSessionSuggestions(
    String query,
    List<VoiceSession> sessions,
  ) {
    final suggestions = <SearchSuggestion>[];
    final lowerQuery = query.toLowerCase();

    for (final session in sessions) {
      if (session.title.toLowerCase().contains(lowerQuery) ||
          (session.eventDescription?.toLowerCase().contains(lowerQuery) ??
              false)) {
        suggestions.add(
          SearchSuggestion.session(
            title: session.title,
            participantCount: session.participants.length,
            isLive:
                session.status ==
                VoiceSessionStatus.active, // Using active instead of live
          ),
        );
      }
    }

    return suggestions;
  }

  /// Generates filter suggestions based on query
  static List<SearchSuggestion> _generateFilterSuggestions(String query) {
    final suggestions = <SearchSuggestion>[];
    final lowerQuery = query.toLowerCase();

    final filterOptions = [
      {
        'text': 'Live sessions only',
        'icon': PhosphorIcons.radioButton(),
        'keywords': ['live', 'active', 'now'],
      },
      {
        'text': 'Upcoming events',
        'icon': PhosphorIcons.calendar(),
        'keywords': ['upcoming', 'scheduled', 'future'],
      },
      {
        'text': 'My communities',
        'icon': PhosphorIcons.users(),
        'keywords': ['my', 'joined', 'member'],
      },
      {
        'text': 'Large sessions (10+ people)',
        'icon': PhosphorIcons.usersFour(),
        'keywords': ['large', 'big', 'popular', '10'],
      },
    ];

    for (final option in filterOptions) {
      final keywords = option['keywords'] as List<String>;
      if (keywords.any((keyword) => keyword.contains(lowerQuery))) {
        suggestions.add(
          SearchSuggestion.filter(
            text: option['text'] as String,
            icon: option['icon'] as IconData,
          ),
        );
      }
    }

    return suggestions;
  }

  /// Generates action suggestions
  static List<SearchSuggestion> _generateActionSuggestions(String query) {
    final suggestions = <SearchSuggestion>[];
    final lowerQuery = query.toLowerCase();

    final actions = [
      {
        'text': 'Create "$query" event',
        'icon': PhosphorIcons.plus(),
        'keywords': ['create', 'new', 'make'],
      },
      {
        'text': 'Search "$query" in communities',
        'icon': PhosphorIcons.magnifyingGlass(),
        'keywords': ['search', 'find', 'look'],
      },
    ];

    for (final action in actions) {
      final keywords = action['keywords'] as List<String>;
      if (keywords.any((keyword) => keyword.contains(lowerQuery)) ||
          query.length > 2) {
        suggestions.add(
          SearchSuggestion.action(
            text: action['text'] as String,
            icon: action['icon'] as IconData,
            onTap: () {},
          ),
        );
      }
    }

    return suggestions;
  }

  /// Extracts community suggestions from sessions
  static List<SearchSuggestion> _extractCommunities(
    List<VoiceSession> sessions,
  ) {
    final communities = <String, int>{};

    for (final session in sessions) {
      if (session.communityName != null) {
        communities[session.communityName!] =
            (communities[session.communityName!] ?? 0) +
            session.participants.length;
      }
    }

    return communities.entries
        .map(
          (entry) => SearchSuggestion.community(
            name: entry.key,
            memberCount: entry.value,
            isVerified: entry.value > 10,
          ),
        )
        .toList();
  }

  /// Query type detection helpers
  static bool _isUserQuery(String query) {
    return query.startsWith('@') ||
        ['user', 'member', 'host', 'speaker'].any(query.toLowerCase().contains);
  }

  static bool _isCommunityQuery(String query) {
    return query.startsWith('#') ||
        ['community', 'server', 'group'].any(query.toLowerCase().contains);
  }

  static bool _isEventQuery(String query) {
    return [
      'event',
      'meeting',
      'call',
      'session',
      'scheduled',
    ].any(query.toLowerCase().contains);
  }

  static bool _isSessionQuery(String query) {
    return [
      'voice',
      'audio',
      'talk',
      'conversation',
    ].any(query.toLowerCase().contains);
  }

  /// Event matching helper
  static bool _eventMatchesQuery(VoiceEvent event, String lowerQuery) {
    return event.title.toLowerCase().contains(lowerQuery) ||
        event.description.toLowerCase().contains(lowerQuery) ||
        event.hostName.toLowerCase().contains(lowerQuery) ||
        event.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
  }

  /// Calculate relevance score for sorting
  static double _calculateRelevance(SearchSuggestion suggestion, String query) {
    double score = 0.0;

    // Exact match bonus
    if (suggestion.text.toLowerCase() == query) {
      score += 100.0;
    }

    // Starts with bonus
    if (suggestion.text.toLowerCase().startsWith(query)) {
      score += 50.0;
    }

    // Contains bonus
    if (suggestion.text.toLowerCase().contains(query)) {
      score += 25.0;
    }

    // Type-based scoring
    switch (suggestion.type) {
      case SearchSuggestionType.recent:
        score += 20.0;
        break;
      case SearchSuggestionType.action:
        score += 15.0;
        break;
      case SearchSuggestionType.community:
        score += 10.0;
        break;
      case SearchSuggestionType.event:
        if (suggestion.isLive) score += 30.0;
        score += 8.0;
        break;
      case SearchSuggestionType.session:
        if (suggestion.isLive) score += 25.0;
        score += 6.0;
        break;
      case SearchSuggestionType.user:
        score += 5.0;
        break;
      case SearchSuggestionType.filter:
        score += 3.0;
        break;
    }

    // Verified bonus
    if (suggestion.isVerified) {
      score += 10.0;
    }

    return score;
  }
}
