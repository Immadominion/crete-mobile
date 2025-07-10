class DeepLinkUtils {
  static const String scheme = 'crete';
  static const String host = 'app.crete.dao';

  /// Generates a deep link URL for joining a DAO
  static String generateDaoJoinLink(String daoId) => '$scheme://dao/join/$daoId';

  /// Generates a deep link URL for viewing a proposal
  static String generateProposalLink(String daoId, String proposalId) => '$scheme://dao/$daoId/proposal/$proposalId';

  /// Generates a deep link URL for viewing a chat room
  static String generateChatRoomLink(String daoId, String roomId) => '$scheme://dao/$daoId/chat/$roomId';

  /// Generates a deep link URL for user profile
  static String generateProfileLink(String userId) => '$scheme://profile/$userId';

  /// Generates a deep link URL for wallet connection
  static String generateWalletConnectLink() => '$scheme://wallet/connect';

  /// Generates a universal link for sharing
  static String generateUniversalLink(String path) => 'https://$host/$path';

  /// Parses a deep link and extracts route information
  static DeepLinkData? parseDeepLink(String url) {
    try {
      final uri = Uri.parse(url);

      if (uri.scheme != scheme && uri.host != host) {
        return null;
      }

      final segments = uri.pathSegments;
      if (segments.isEmpty) {
        return const DeepLinkData(type: DeepLinkType.home);
      }

      switch (segments[0]) {
        case 'dao':
          return _parseDaoLink(segments, uri.queryParameters);
        case 'profile':
          return _parseProfileLink(segments, uri.queryParameters);
        case 'wallet':
          return _parseWalletLink(segments, uri.queryParameters);
        case 'invite':
          return _parseInviteLink(segments, uri.queryParameters);
        default:
          return const DeepLinkData(type: DeepLinkType.unknown);
      }
    } catch (e) {
      return null;
    }
  }

  static DeepLinkData _parseDaoLink(
    List<String> segments,
    Map<String, String> params,
  ) {
    if (segments.length < 2) {
      return const DeepLinkData(type: DeepLinkType.daoList);
    }

    if (segments[1] == 'join' && segments.length >= 3) {
      return DeepLinkData(
        type: DeepLinkType.daoJoin,
        daoId: segments[2],
        params: params,
      );
    }

    final daoId = segments[1];

    if (segments.length == 2) {
      return DeepLinkData(
        type: DeepLinkType.daoDetail,
        daoId: daoId,
        params: params,
      );
    }

    if (segments.length >= 4) {
      switch (segments[2]) {
        case 'proposal':
          return DeepLinkData(
            type: DeepLinkType.proposal,
            daoId: daoId,
            proposalId: segments[3],
            params: params,
          );
        case 'chat':
          return DeepLinkData(
            type: DeepLinkType.chatRoom,
            daoId: daoId,
            roomId: segments[3],
            params: params,
          );
        case 'members':
          return DeepLinkData(
            type: DeepLinkType.daoMembers,
            daoId: daoId,
            params: params,
          );
        case 'settings':
          return DeepLinkData(
            type: DeepLinkType.daoSettings,
            daoId: daoId,
            params: params,
          );
      }
    }

    return DeepLinkData(
      type: DeepLinkType.daoDetail,
      daoId: daoId,
      params: params,
    );
  }

  static DeepLinkData _parseProfileLink(
    List<String> segments,
    Map<String, String> params,
  ) {
    if (segments.length < 2) {
      return const DeepLinkData(type: DeepLinkType.profile);
    }

    return DeepLinkData(
      type: DeepLinkType.userProfile,
      userId: segments[1],
      params: params,
    );
  }

  static DeepLinkData _parseWalletLink(
    List<String> segments,
    Map<String, String> params,
  ) {
    if (segments.length < 2) {
      return const DeepLinkData(type: DeepLinkType.wallet);
    }

    switch (segments[1]) {
      case 'connect':
        return DeepLinkData(type: DeepLinkType.walletConnect, params: params);
      case 'disconnect':
        return DeepLinkData(
          type: DeepLinkType.walletDisconnect,
          params: params,
        );
      default:
        return const DeepLinkData(type: DeepLinkType.wallet);
    }
  }

  static DeepLinkData _parseInviteLink(
    List<String> segments,
    Map<String, String> params,
  ) {
    if (segments.length < 2) {
      return const DeepLinkData(type: DeepLinkType.unknown);
    }

    return DeepLinkData(
      type: DeepLinkType.invite,
      inviteCode: segments[1],
      params: params,
    );
  }

  /// Validates if a URL is a valid Crete deep link
  static bool isValidDeepLink(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.scheme == scheme || uri.host == host;
    } catch (e) {
      return false;
    }
  }

  /// Extracts query parameters from a deep link
  static Map<String, String> extractParams(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.queryParameters;
    } catch (e) {
      return {};
    }
  }

  /// Builds a URL with query parameters
  static String buildUrlWithParams(String baseUrl, Map<String, String> params) {
    if (params.isEmpty) return baseUrl;

    final uri = Uri.parse(baseUrl);
    final newUri = uri.replace(
      queryParameters: {...uri.queryParameters, ...params},
    );

    return newUri.toString();
  }
}

enum DeepLinkType {
  home,
  daoList,
  daoDetail,
  daoJoin,
  daoMembers,
  daoSettings,
  proposal,
  chatRoom,
  profile,
  userProfile,
  wallet,
  walletConnect,
  walletDisconnect,
  invite,
  unknown,
}

class DeepLinkData {

  const DeepLinkData({
    required this.type,
    this.daoId,
    this.proposalId,
    this.roomId,
    this.userId,
    this.inviteCode,
    this.params = const {},
  });
  final DeepLinkType type;
  final String? daoId;
  final String? proposalId;
  final String? roomId;
  final String? userId;
  final String? inviteCode;
  final Map<String, String> params;

  @override
  String toString() => 'DeepLinkData(type: $type, daoId: $daoId, proposalId: $proposalId, roomId: $roomId, userId: $userId, inviteCode: $inviteCode, params: $params)';
}
