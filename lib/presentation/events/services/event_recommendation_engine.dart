import 'dart:math';

import '../models/voice_event_models.dart';
import '../models/voice_models.dart';

/// AI-powered event recommendation engine that suggests events based on
/// user behavior, preferences, and community activity
class EventRecommendationEngine {
  static const List<String> _interestCategories = [
    'Technology',
    'DeFi',
    'NFTs',
    'Gaming',
    'Art',
    'Music',
    'Education',
    'Governance',
    'Trading',
    'Development',
  ];

  static const List<String> _eventTypes = [
    'Community Call',
    'AMA Session',
    'Workshop',
    'Governance Meeting',
    'Social Hour',
    'Demo Day',
    'Study Group',
    'Trading Discussion',
  ];

  /// Generate personalized event recommendations based on user activity
  static List<EventRecommendation> getPersonalizedRecommendations({
    required String userId,
    required List<VoiceEvent> recentEvents,
    required List<VoiceSession> recentSessions,
    required Map<String, int> userInterests,
    int maxRecommendations = 5,
  }) {
    final recommendations = <EventRecommendation>[];
    final random = Random();

    // Analyze user patterns
    final preferredTimeSlots = _analyzePreferredTimes(recentSessions);
    final preferredCategories = _analyzePreferredCategories(
      recentEvents,
      userInterests,
    );
    final socialConnections = _analyzeSocialConnections(recentSessions);

    // Generate recommendations based on patterns
    for (int i = 0; i < maxRecommendations; i++) {
      final category = preferredCategories.isNotEmpty
          ? preferredCategories[random.nextInt(preferredCategories.length)]
          : _interestCategories[random.nextInt(_interestCategories.length)];

      final eventType = _eventTypes[random.nextInt(_eventTypes.length)];
      final confidence = _calculateConfidence(
        category,
        preferredCategories,
        eventType,
      );

      recommendations.add(
        EventRecommendation(
          id: 'rec_${DateTime.now().millisecondsSinceEpoch}_$i',
          title: _generateEventTitle(category, eventType),
          description: _generateEventDescription(category, eventType),
          category: category,
          eventType: eventType,
          confidence: confidence,
          reason: _generateRecommendationReason(
            category,
            eventType,
            confidence,
          ),
          suggestedTime: _suggestOptimalTime(preferredTimeSlots),
          estimatedDuration: Duration(minutes: 30 + random.nextInt(90)),
          potentialAttendees: socialConnections
              .take(3 + random.nextInt(5))
              .toList(),
          tags: _generateTags(category, eventType),
          gamificationRewards: GameRewards(
            xpReward: 50 + random.nextInt(100),
            badgeEligible: confidence > 0.7,
            streakBonus: random.nextBool(),
          ),
        ),
      );
    }

    // Sort by confidence score
    recommendations.sort((a, b) => b.confidence.compareTo(a.confidence));
    return recommendations;
  }

  /// Generate trending event suggestions based on community activity
  static List<EventRecommendation> getTrendingRecommendations({
    required List<VoiceEvent> communityEvents,
    required Map<String, int> globalTrends,
    int maxRecommendations = 3,
  }) {
    final recommendations = <EventRecommendation>[];
    final random = Random();

    // Analyze trending topics
    final trendingTopics = globalTrends.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (int i = 0; i < maxRecommendations && i < trendingTopics.length; i++) {
      final topic = trendingTopics[i].key;
      final trendScore = trendingTopics[i].value;

      recommendations.add(
        EventRecommendation(
          id: 'trending_${DateTime.now().millisecondsSinceEpoch}_$i',
          title: _generateTrendingEventTitle(topic),
          description: _generateTrendingEventDescription(topic, trendScore),
          category: topic,
          eventType: 'Trending Discussion',
          confidence: 0.8 + (trendScore / 1000) * 0.2,
          reason: '🔥 Trending in community • ${trendScore} mentions',
          suggestedTime: DateTime.now().add(
            Duration(hours: 2 + random.nextInt(6)),
          ),
          estimatedDuration: Duration(minutes: 45 + random.nextInt(45)),
          potentialAttendees: [],
          tags: [topic.toLowerCase(), 'trending', 'community'],
          gamificationRewards: GameRewards(
            xpReward: 75 + random.nextInt(75),
            badgeEligible: true,
            streakBonus: true,
          ),
          isTrending: true,
          trendScore: trendScore,
        ),
      );
    }

    return recommendations;
  }

  /// Suggest optimal times for events based on community activity patterns
  static List<DateTime> suggestOptimalEventTimes({
    required List<VoiceSession> historicalSessions,
    required DateTime startDate,
    required DateTime endDate,
    int maxSuggestions = 5,
  }) {
    final suggestions = <DateTime>[];
    final hourActivity = <int, int>{};

    // Analyze historical activity patterns
    for (final session in historicalSessions) {
      final hour = session.startTime.hour;
      hourActivity[hour] = (hourActivity[hour] ?? 0) + 1;
    }

    // Find peak hours
    final peakHours = hourActivity.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Generate suggestions for peak hours within the date range
    var currentDate = startDate;
    while (currentDate.isBefore(endDate) &&
        suggestions.length < maxSuggestions) {
      for (final entry in peakHours.take(3)) {
        if (suggestions.length >= maxSuggestions) break;

        final suggestedTime = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
          entry.key,
          0,
        );

        if (suggestedTime.isAfter(DateTime.now()) &&
            suggestedTime.isBefore(endDate)) {
          suggestions.add(suggestedTime);
        }
      }
      currentDate = currentDate.add(const Duration(days: 1));
    }

    return suggestions;
  }

  // Private helper methods
  static List<int> _analyzePreferredTimes(List<VoiceSession> sessions) {
    final hourCounts = <int, int>{};
    for (final session in sessions) {
      final hour = session.startTime.hour;
      hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
    }

    return hourCounts.entries
        .where((entry) => entry.value > 1)
        .map((entry) => entry.key)
        .toList()
      ..sort();
  }

  static List<String> _analyzePreferredCategories(
    List<VoiceEvent> events,
    Map<String, int> userInterests,
  ) {
    final categoryScores = <String, int>{};

    // Add user interest scores
    userInterests.forEach((category, score) {
      categoryScores[category] = score;
    });

    // Add event participation scores
    for (final event in events) {
      if (event.tags.isNotEmpty) {
        for (final tag in event.tags) {
          final category = _mapTagToCategory(tag);
          if (category != null) {
            categoryScores[category] = (categoryScores[category] ?? 0) + 10;
          }
        }
      }
    }

    final sortedEntries =
        categoryScores.entries.where((entry) => entry.value > 5).toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries.map((entry) => entry.key).toList();
  }

  static List<String> _analyzeSocialConnections(List<VoiceSession> sessions) {
    final connections = <String>{};
    for (final session in sessions) {
      for (final participant in session.participants) {
        connections.add(participant.name);
      }
    }
    return connections.toList();
  }

  static double _calculateConfidence(
    String category,
    List<String> preferredCategories,
    String eventType,
  ) {
    double confidence = 0.5; // Base confidence

    if (preferredCategories.contains(category)) {
      confidence += 0.3;
    }

    // Add randomness for variety
    confidence += (Random().nextDouble() - 0.5) * 0.2;

    return confidence.clamp(0.1, 1.0);
  }

  static String? _mapTagToCategory(String tag) {
    final tagLower = tag.toLowerCase();
    for (final category in _interestCategories) {
      if (tagLower.contains(category.toLowerCase())) {
        return category;
      }
    }
    return null;
  }

  static String _generateEventTitle(String category, String eventType) {
    final titles = {
      'Technology': [
        'Tech Innovation Roundtable',
        'Future of Web3 Discussion',
        'Developer Community Call',
        'Tech Stack Deep Dive',
      ],
      'DeFi': [
        'DeFi Strategies Workshop',
        'Yield Farming Discussion',
        'Protocol Analysis Session',
        'DeFi Security Talk',
      ],
      'NFTs': [
        'NFT Creator Showcase',
        'Digital Art Discussion',
        'NFT Market Analysis',
        'Creator Economy Talk',
      ],
      'Gaming': [
        'GameFi Community Call',
        'Gaming Guild Strategy',
        'P2E Game Review',
        'Gaming Development Chat',
      ],
    };

    final categoryTitles = titles[category] ?? ['Community Discussion'];
    return categoryTitles[Random().nextInt(categoryTitles.length)];
  }

  static String _generateEventDescription(String category, String eventType) {
    return 'Join fellow community members for an engaging $eventType focused on $category. '
        'Share insights, ask questions, and connect with like-minded individuals.';
  }

  static String _generateRecommendationReason(
    String category,
    String eventType,
    double confidence,
  ) {
    if (confidence > 0.8) {
      return '🎯 Perfect match based on your activity';
    } else if (confidence > 0.6) {
      return '✨ Recommended based on your interests';
    } else {
      return '🌟 Popular in your communities';
    }
  }

  static DateTime _suggestOptimalTime(List<int> preferredHours) {
    final now = DateTime.now();
    final preferredHour = preferredHours.isNotEmpty
        ? preferredHours[Random().nextInt(preferredHours.length)]
        : 14 + Random().nextInt(6); // Default to afternoon

    var suggestedTime = DateTime(
      now.year,
      now.month,
      now.day + 1,
      preferredHour,
    );

    // If it's in the past, add a day
    if (suggestedTime.isBefore(now)) {
      suggestedTime = suggestedTime.add(const Duration(days: 1));
    }

    return suggestedTime;
  }

  static String _generateTrendingEventTitle(String topic) {
    return '🔥 Hot Topic: $topic Discussion';
  }

  static String _generateTrendingEventDescription(
    String topic,
    int trendScore,
  ) {
    return 'Join the conversation about $topic! This topic is trending with $trendScore mentions '
        'across the community. Don\'t miss out on the latest developments and discussions.';
  }

  static List<String> _generateTags(String category, String eventType) {
    return [
      category.toLowerCase(),
      eventType.toLowerCase().replaceAll(' ', '_'),
      'community',
      'discussion',
    ];
  }
}

/// Event recommendation data model
class EventRecommendation {
  const EventRecommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.eventType,
    required this.confidence,
    required this.reason,
    required this.suggestedTime,
    required this.estimatedDuration,
    required this.potentialAttendees,
    required this.tags,
    required this.gamificationRewards,
    this.isTrending = false,
    this.trendScore = 0,
  });

  final String id;
  final String title;
  final String description;
  final String category;
  final String eventType;
  final double confidence;
  final String reason;
  final DateTime suggestedTime;
  final Duration estimatedDuration;
  final List<String> potentialAttendees;
  final List<String> tags;
  final GameRewards gamificationRewards;
  final bool isTrending;
  final int trendScore;
}

/// Gamification rewards for events
class GameRewards {
  const GameRewards({
    required this.xpReward,
    required this.badgeEligible,
    required this.streakBonus,
  });

  final int xpReward;
  final bool badgeEligible;
  final bool streakBonus;
}
