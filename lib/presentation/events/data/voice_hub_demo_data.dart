import '../models/voice_models.dart';

class VoiceHubDemoData {
  static VoiceHubStats getHubStats() {
    return const VoiceHubStats(
      todayVoiceTime: Duration(hours: 2, minutes: 30),
      weekVoiceTime: Duration(hours: 12, minutes: 45),
      totalActiveParticipants: 127,
      scheduledEventsCount: 3,
      completedSessionsToday: 2,
      achievements: ['Voice Enthusiast', 'Community Builder', 'Early Bird'],
    );
  }

  static List<VoiceSession> getActiveSessions() {
    return [
      VoiceSession(
        id: '1',
        title: 'DAO Strategy Discussion',
        communityName: 'CryptoDAO',
        type: VoiceSessionType.meeting,
        status: VoiceSessionStatus.active,
        startTime: DateTime.now().subtract(
          const Duration(hours: 1, minutes: 30),
        ),
        participants: [
          const VoiceParticipant(
            id: '1',
            name: 'Alice Chen',
            isSpeaking: true,
            isHost: true,
          ),
          const VoiceParticipant(id: '2', name: 'Bob Wilson', isMuted: true),
          const VoiceParticipant(id: '3', name: 'Carol Davis'),
        ],
        maxParticipants: 20,
      ),
      VoiceSession(
        id: '2',
        title: 'Study Session: Solana Development',
        communityName: 'DevCommunity',
        type: VoiceSessionType.studySession,
        status: VoiceSessionStatus.active,
        startTime: DateTime.now().subtract(const Duration(minutes: 45)),
        participants: [
          const VoiceParticipant(id: '4', name: 'David Kim', isHost: true),
          const VoiceParticipant(
            id: '5',
            name: 'Emma Rodriguez',
            isSpeaking: true,
          ),
          const VoiceParticipant(id: '6', name: 'Frank Johnson'),
          const VoiceParticipant(id: '7', name: 'Grace Lee', isMuted: true),
        ],
        maxParticipants: 15,
      ),
      VoiceSession(
        id: '3',
        title: 'Gaming: Among Us',
        communityName: 'GameNight',
        type: VoiceSessionType.game,
        status: VoiceSessionStatus.active,
        startTime: DateTime.now().subtract(const Duration(minutes: 20)),
        participants: [
          const VoiceParticipant(
            id: '8',
            name: 'Henry Zhang',
            isSpeaking: true,
            isHost: true,
          ),
          const VoiceParticipant(id: '9', name: 'Iris Thompson'),
          const VoiceParticipant(
            id: '10',
            name: 'Jack Brown',
            isSpeaking: true,
          ),
        ],
        maxParticipants: 10,
      ),
    ];
  }

  static List<VoiceSession> getScheduledSessions() {
    return [
      VoiceSession(
        id: '4',
        title: 'Weekly Community Standup',
        communityName: 'CryptoDAO',
        type: VoiceSessionType.meeting,
        status: VoiceSessionStatus.scheduled,
        startTime: DateTime.now().add(const Duration(hours: 2)),
        endTime: DateTime.now().add(const Duration(hours: 3)),
        participants: [],
        maxParticipants: 50,
        hasScheduledEvent: true,
        eventDescription: 'Weekly progress updates and community announcements',
      ),
      VoiceSession(
        id: '5',
        title: 'NFT Art Showcase',
        communityName: 'ArtistsDAO',
        type: VoiceSessionType.event,
        status: VoiceSessionStatus.scheduled,
        startTime: DateTime.now().add(const Duration(days: 1, hours: 3)),
        endTime: DateTime.now().add(const Duration(days: 1, hours: 5)),
        participants: [],
        maxParticipants: 100,
        hasScheduledEvent: true,
        eventDescription:
            'Community artists showcase their latest NFT collections',
      ),
      VoiceSession(
        id: '6',
        title: 'Late Night Coding Session',
        communityName: 'DevCommunity',
        type: VoiceSessionType.studySession,
        status: VoiceSessionStatus.scheduled,
        startTime: DateTime.now().add(const Duration(hours: 8)),
        participants: [],
        maxParticipants: 25,
        hasScheduledEvent: true,
        eventDescription: 'Collaborative coding session for ongoing projects',
      ),
    ];
  }

  static List<VoiceSession> getRecentSessions() {
    return [
      VoiceSession(
        id: '7',
        title: 'Morning Meditation',
        communityName: 'Wellness DAO',
        type: VoiceSessionType.event,
        status: VoiceSessionStatus.ended,
        startTime: DateTime.now().subtract(const Duration(hours: 3)),
        endTime: DateTime.now().subtract(const Duration(hours: 2)),
        participants: [
          const VoiceParticipant(id: '11', name: 'Luna Martinez'),
          const VoiceParticipant(id: '12', name: 'Max Williams'),
        ],
        isJoined: true,
      ),
      VoiceSession(
        id: '8',
        title: 'Quick Standup',
        communityName: 'StartupDAO',
        type: VoiceSessionType.meeting,
        status: VoiceSessionStatus.ended,
        startTime: DateTime.now().subtract(const Duration(hours: 5)),
        endTime: DateTime.now().subtract(const Duration(hours: 4, minutes: 30)),
        participants: [
          const VoiceParticipant(id: '13', name: 'Nina Patel'),
          const VoiceParticipant(id: '14', name: 'Oscar Chen'),
          const VoiceParticipant(id: '15', name: 'Paul Johnson'),
        ],
        isJoined: true,
      ),
      VoiceSession(
        id: '9',
        title: 'Casual Chat',
        type: VoiceSessionType.voice,
        status: VoiceSessionStatus.ended,
        startTime: DateTime.now().subtract(const Duration(days: 1)),
        endTime: DateTime.now().subtract(const Duration(days: 1, hours: -1)),
        participants: [const VoiceParticipant(id: '16', name: 'Quinn Davis')],
        isJoined: false,
      ),
    ];
  }
}
