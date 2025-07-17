class Community {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final int memberCount;
  final int onlineCount;
  final bool isJoined;
  final int unreadCount;
  final bool isPublic;
  final DateTime? lastActivity;
  final List<String> tags;

  const Community({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.memberCount,
    required this.onlineCount,
    required this.isJoined,
    this.unreadCount = 0,
    this.isPublic = true,
    this.lastActivity,
    this.tags = const [],
  });

  Community copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    int? memberCount,
    int? onlineCount,
    bool? isJoined,
    int? unreadCount,
    bool? isPublic,
    DateTime? lastActivity,
    List<String>? tags,
  }) {
    return Community(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      memberCount: memberCount ?? this.memberCount,
      onlineCount: onlineCount ?? this.onlineCount,
      isJoined: isJoined ?? this.isJoined,
      unreadCount: unreadCount ?? this.unreadCount,
      isPublic: isPublic ?? this.isPublic,
      lastActivity: lastActivity ?? this.lastActivity,
      tags: tags ?? this.tags,
    );
  }
}
