import '../models/voice_event_models.dart';
import '../models/voice_models.dart';

class EventDemoData {
  static List<VoiceEvent> getUpcomingEvents() {
    return [
      VoiceEvent(
        id: 'event_1',
        title: 'Community AMA with Founders',
        description:
            'Join us for an interactive AMA session with the founding team. We\'ll discuss the roadmap, upcoming features, and answer your questions about the future of our platform.',
        communityId: 'crypto_dao',
        communityName: 'CryptoDAO',
        type: VoiceSessionType.event,
        status: EventStatus.scheduled,
        startTime: DateTime.now().add(const Duration(hours: 2)),
        duration: const Duration(hours: 1, minutes: 30),
        maxParticipants: 100,
        privacy: EventPrivacy.community,
        hostId: 'host_1',
        hostName: 'Sarah Johnson',
        hostAvatarUrl: null,
        coHostIds: ['host_2', 'host_3'],
        rsvps: [
          EventRSVP(
            userId: 'user_1',
            userName: 'Alice Chen',
            response: RSVPResponse.going,
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          ),
          EventRSVP(
            userId: 'user_2',
            userName: 'Bob Wilson',
            response: RSVPResponse.going,
            timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
          ),
          EventRSVP(
            userId: 'user_3',
            userName: 'Carol Davis',
            response: RSVPResponse.maybe,
            timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          ),
          EventRSVP(
            userId: 'user_4',
            userName: 'David Kim',
            response: RSVPResponse.going,
            timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
          ),
        ],
        tags: ['AMA', 'Founders', 'Community', 'Q&A'],
        reminder: const EventReminder(
          beforeEvent: Duration(minutes: 15),
          type: ReminderType.notification,
        ),
        allowWaitlist: true,
        waitlistCount: 0,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      VoiceEvent(
        id: 'event_2',
        title: 'Weekly Gaming Tournament',
        description:
            'Join our weekly gaming tournament! This week we\'re playing the latest strategy games. Prizes for top 3 players including rare NFTs and tokens.',
        communityId: 'gaming_guild',
        communityName: 'Gaming Guild',
        type: VoiceSessionType.game,
        status: EventStatus.scheduled,
        startTime: DateTime.now().add(const Duration(days: 1, hours: 3)),
        duration: const Duration(hours: 3),
        maxParticipants: 50,
        privacy: EventPrivacy.community,
        hostId: 'host_4',
        hostName: 'Gaming Master',
        rsvps: [
          EventRSVP(
            userId: 'user_5',
            userName: 'Emma Rodriguez',
            response: RSVPResponse.going,
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          EventRSVP(
            userId: 'user_6',
            userName: 'Frank Miller',
            response: RSVPResponse.going,
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          ),
        ],
        tags: ['Gaming', 'Tournament', 'NFT', 'Prizes'],
        recurrence: const EventRecurrence(
          type: RecurrenceType.weekly,
          interval: 1,
          daysOfWeek: [6], // Saturday
        ),
        reminder: const EventReminder(
          beforeEvent: Duration(hours: 1),
          type: ReminderType.notification,
        ),
        allowWaitlist: false,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      VoiceEvent(
        id: 'event_3',
        title: 'DeFi Study Group',
        description:
            'Deep dive into decentralized finance protocols. This week we\'re studying yield farming strategies and risk management. Bring your questions!',
        communityId: 'defi_learners',
        communityName: 'DeFi Learners',
        type: VoiceSessionType.studySession,
        status: EventStatus.scheduled,
        startTime: DateTime.now().add(const Duration(days: 2, hours: 1)),
        duration: const Duration(hours: 2),
        maxParticipants: 25,
        privacy: EventPrivacy.community,
        hostId: 'host_5',
        hostName: 'DeFi Expert',
        rsvps: [
          EventRSVP(
            userId: 'user_7',
            userName: 'Grace Wong',
            response: RSVPResponse.going,
            timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          ),
          EventRSVP(
            userId: 'user_8',
            userName: 'Henry James',
            response: RSVPResponse.maybe,
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          EventRSVP(
            userId: 'user_9',
            userName: 'Iris Li',
            response: RSVPResponse.going,
            timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          ),
        ],
        tags: ['DeFi', 'Study', 'Learning', 'Yield Farming'],
        recurrence: const EventRecurrence(
          type: RecurrenceType.weekly,
          interval: 1,
          daysOfWeek: [3], // Wednesday
        ),
        reminder: const EventReminder(
          beforeEvent: Duration(minutes: 30),
          type: ReminderType.notification,
        ),
        allowWaitlist: true,
        waitlistCount: 2,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      VoiceEvent(
        id: 'event_4',
        title: 'Product Roadmap Discussion',
        description:
            'Join the product team for a discussion about our Q2 roadmap. We\'ll share updates on upcoming features and gather community feedback.',
        communityId: 'product_community',
        communityName: 'Product Community',
        type: VoiceSessionType.meeting,
        status: EventStatus.scheduled,
        startTime: DateTime.now().add(const Duration(days: 3, hours: 2)),
        duration: const Duration(hours: 1),
        maxParticipants: 75,
        privacy: EventPrivacy.community,
        hostId: 'host_6',
        hostName: 'Product Manager',
        rsvps: [
          EventRSVP(
            userId: 'user_10',
            userName: 'Jack Turner',
            response: RSVPResponse.going,
            timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          ),
        ],
        tags: ['Product', 'Roadmap', 'Feedback', 'Community'],
        reminder: const EventReminder(
          beforeEvent: Duration(minutes: 10),
          type: ReminderType.notification,
        ),
        allowWaitlist: false,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  static List<VoiceEvent> getActiveEvents() {
    return [
      VoiceEvent(
        id: 'active_event_1',
        title: 'Live Podcast Recording',
        description:
            'We\'re recording our weekly podcast live! Join us as we discuss the latest trends in blockchain technology and interview special guests.',
        communityId: 'podcast_community',
        communityName: 'Blockchain Podcast',
        type: VoiceSessionType.event,
        status: EventStatus.active,
        startTime: DateTime.now().subtract(const Duration(minutes: 30)),
        duration: const Duration(hours: 1, minutes: 30),
        maxParticipants: 200,
        privacy: EventPrivacy.public,
        hostId: 'host_7',
        hostName: 'Podcast Host',
        rsvps: [
          EventRSVP(
            userId: 'user_11',
            userName: 'Kelly Zhang',
            response: RSVPResponse.going,
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          EventRSVP(
            userId: 'user_12',
            userName: 'Liam Brown',
            response: RSVPResponse.going,
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          ),
        ],
        tags: ['Podcast', 'Live', 'Blockchain', 'Interview'],
        allowWaitlist: false,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }

  static List<VoiceEvent> getRecentEvents() {
    return [
      VoiceEvent(
        id: 'recent_event_1',
        title: 'NFT Marketplace Demo',
        description:
            'Demo of the new NFT marketplace features including bulk operations, advanced filtering, and creator tools.',
        communityId: 'nft_community',
        communityName: 'NFT Creators',
        type: VoiceSessionType.event,
        status: EventStatus.ended,
        startTime: DateTime.now().subtract(const Duration(hours: 3)),
        endTime: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        maxParticipants: 60,
        privacy: EventPrivacy.community,
        hostId: 'host_8',
        hostName: 'NFT Developer',
        rsvps: [
          EventRSVP(
            userId: 'user_13',
            userName: 'Maya Patel',
            response: RSVPResponse.going,
            timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          ),
          EventRSVP(
            userId: 'user_14',
            userName: 'Noah Johnson',
            response: RSVPResponse.going,
            timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          ),
        ],
        tags: ['NFT', 'Demo', 'Marketplace', 'Features'],
        allowWaitlist: false,
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        updatedAt: DateTime.now().subtract(
          const Duration(hours: 1, minutes: 30),
        ),
      ),
      VoiceEvent(
        id: 'recent_event_2',
        title: 'Community Governance Vote',
        description:
            'Important governance vote on the new tokenomics proposal. All community members encouraged to participate.',
        communityId: 'governance_dao',
        communityName: 'Governance DAO',
        type: VoiceSessionType.meeting,
        status: EventStatus.ended,
        startTime: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        endTime: DateTime.now().subtract(const Duration(days: 1)),
        maxParticipants: 150,
        privacy: EventPrivacy.community,
        hostId: 'host_9',
        hostName: 'DAO Coordinator',
        rsvps: [
          EventRSVP(
            userId: 'user_15',
            userName: 'Oliver Smith',
            response: RSVPResponse.going,
            timestamp: DateTime.now().subtract(const Duration(days: 2)),
          ),
        ],
        tags: ['Governance', 'Vote', 'Tokenomics', 'DAO'],
        allowWaitlist: false,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  static List<VoiceEvent> getAllEvents() {
    return [...getActiveEvents(), ...getUpcomingEvents(), ...getRecentEvents()];
  }

  static VoiceEvent? getEventById(String id) {
    try {
      return getAllEvents().firstWhere((event) => event.id == id);
    } catch (e) {
      return null;
    }
  }

  // Helper method to convert VoiceEvent to VoiceSession for backward compatibility
  static VoiceSession eventToSession(VoiceEvent event) {
    return VoiceSession(
      id: event.id,
      title: event.title,
      communityName: event.communityName,
      type: event.type,
      status: _eventStatusToSessionStatus(event.status),
      startTime: event.startTime,
      endTime: event.endTime,
      participants: _rsvpsToParticipants(event.rsvps),
      maxParticipants: event.maxParticipants,
      eventDescription: event.description,
    );
  }

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
        return VoiceSessionStatus.ended; // Map cancelled to ended for now
    }
  }

  static List<VoiceParticipant> _rsvpsToParticipants(List<EventRSVP> rsvps) {
    return rsvps
        .where((rsvp) => rsvp.response == RSVPResponse.going)
        .map(
          (rsvp) => VoiceParticipant(
            id: rsvp.userId,
            name: rsvp.userName,
            avatarUrl: rsvp.userAvatarUrl,
          ),
        )
        .toList();
  }
}
