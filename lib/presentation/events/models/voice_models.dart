enum VoiceSessionType { voice, video, game, studySession, meeting, event }

enum VoiceSessionStatus { active, scheduled, ended, cancelled }

class VoiceSession {
  final String id;
  final String title;
  final String? communityName;
  final VoiceSessionType type;
  final VoiceSessionStatus status;
  final DateTime startTime;
  final DateTime? endTime;
  final List<VoiceParticipant> participants;
  final int maxParticipants;
  final bool isJoined;
  final bool hasScheduledEvent;
  final String? eventDescription;

  const VoiceSession({
    required this.id,
    required this.title,
    this.communityName,
    required this.type,
    required this.status,
    required this.startTime,
    this.endTime,
    required this.participants,
    this.maxParticipants = 50,
    this.isJoined = false,
    this.hasScheduledEvent = false,
    this.eventDescription,
  });

  String get typeDisplayName {
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

  Duration get duration {
    if (status == VoiceSessionStatus.active) {
      return DateTime.now().difference(startTime);
    }
    if (endTime != null) {
      return endTime!.difference(startTime);
    }
    return Duration.zero;
  }

  String get durationText {
    if (status == VoiceSessionStatus.scheduled) {
      final timeUntil = startTime.difference(DateTime.now());
      if (timeUntil.inHours > 0) {
        return 'Starts in ${timeUntil.inHours}h ${timeUntil.inMinutes % 60}m';
      }
      return 'Starts in ${timeUntil.inMinutes}m';
    }

    final d = duration;
    if (d.inHours > 0) {
      return '${d.inHours}h ${d.inMinutes % 60}m';
    }
    return '${d.inMinutes}m';
  }
}

class VoiceParticipant {
  final String id;
  final String name;
  final String? avatarUrl;
  final bool isSpeaking;
  final bool isMuted;
  final bool isVideoOn;
  final bool isHost;

  const VoiceParticipant({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.isSpeaking = false,
    this.isMuted = false,
    this.isVideoOn = false,
    this.isHost = false,
  });
}

class VoiceHubStats {
  final Duration todayVoiceTime;
  final Duration weekVoiceTime;
  final int totalActiveParticipants;
  final int scheduledEventsCount;
  final int completedSessionsToday;
  final List<String> achievements;

  const VoiceHubStats({
    required this.todayVoiceTime,
    required this.weekVoiceTime,
    required this.totalActiveParticipants,
    required this.scheduledEventsCount,
    required this.completedSessionsToday,
    required this.achievements,
  });
}
