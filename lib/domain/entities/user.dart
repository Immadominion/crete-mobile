import 'package:equatable/equatable.dart';

class User extends Equatable {

  const User({
    required this.id,
    required this.walletAddress,
    this.displayName,
    this.avatarUrl,
    required this.createdAt,
    this.lastActiveAt,
    this.isVerified = false,
    this.daoIds = const [],
    this.preferences = const UserPreferences(),
  });
  final String id;
  final String walletAddress;
  final String? displayName;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime? lastActiveAt;
  final bool isVerified;
  final List<String> daoIds;
  final UserPreferences preferences;

  @override
  List<Object?> get props => [
    id,
    walletAddress,
    displayName,
    avatarUrl,
    createdAt,
    lastActiveAt,
    isVerified,
    daoIds,
    preferences,
  ];

  User copyWith({
    String? id,
    String? walletAddress,
    String? displayName,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? lastActiveAt,
    bool? isVerified,
    List<String>? daoIds,
    UserPreferences? preferences,
  }) => User(
      id: id ?? this.id,
      walletAddress: walletAddress ?? this.walletAddress,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      isVerified: isVerified ?? this.isVerified,
      daoIds: daoIds ?? this.daoIds,
      preferences: preferences ?? this.preferences,
    );

  String get shortWalletAddress {
    if (walletAddress.length <= 8) return walletAddress;
    return '${walletAddress.substring(0, 4)}...${walletAddress.substring(walletAddress.length - 4)}';
  }

  String get displayNameOrWallet => displayName ?? shortWalletAddress;

  bool get hasCustomDisplayName => displayName != null && displayName!.isNotEmpty;
}

class UserPreferences extends Equatable {

  const UserPreferences({
    this.enableNotifications = true,
    this.enablePushNotifications = true,
    this.enableEmailNotifications = false,
    this.theme = 'system',
    this.language = 'en',
    this.notifications = const NotificationPreferences(),
  });
  final bool enableNotifications;
  final bool enablePushNotifications;
  final bool enableEmailNotifications;
  final String theme; // 'light', 'dark', 'system'
  final String language;
  final NotificationPreferences notifications;

  @override
  List<Object?> get props => [
    enableNotifications,
    enablePushNotifications,
    enableEmailNotifications,
    theme,
    language,
    notifications,
  ];

  UserPreferences copyWith({
    bool? enableNotifications,
    bool? enablePushNotifications,
    bool? enableEmailNotifications,
    String? theme,
    String? language,
    NotificationPreferences? notifications,
  }) => UserPreferences(
      enableNotifications: enableNotifications ?? this.enableNotifications,
      enablePushNotifications:
          enablePushNotifications ?? this.enablePushNotifications,
      enableEmailNotifications:
          enableEmailNotifications ?? this.enableEmailNotifications,
      theme: theme ?? this.theme,
      language: language ?? this.language,
      notifications: notifications ?? this.notifications,
    );
}

class NotificationPreferences extends Equatable {

  const NotificationPreferences({
    this.daoProposals = true,
    this.daoAnnouncements = true,
    this.chatMessages = true,
    this.directMessages = true,
    this.governance = true,
    this.security = true,
  });
  final bool daoProposals;
  final bool daoAnnouncements;
  final bool chatMessages;
  final bool directMessages;
  final bool governance;
  final bool security;

  @override
  List<Object?> get props => [
    daoProposals,
    daoAnnouncements,
    chatMessages,
    directMessages,
    governance,
    security,
  ];

  NotificationPreferences copyWith({
    bool? daoProposals,
    bool? daoAnnouncements,
    bool? chatMessages,
    bool? directMessages,
    bool? governance,
    bool? security,
  }) => NotificationPreferences(
      daoProposals: daoProposals ?? this.daoProposals,
      daoAnnouncements: daoAnnouncements ?? this.daoAnnouncements,
      chatMessages: chatMessages ?? this.chatMessages,
      directMessages: directMessages ?? this.directMessages,
      governance: governance ?? this.governance,
      security: security ?? this.security,
    );
}
