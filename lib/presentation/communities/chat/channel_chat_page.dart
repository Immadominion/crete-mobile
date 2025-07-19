import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../domain/entities/community.dart';
import '../community_detail_page.dart';
import 'widgets/attachment_options_dialog.dart';
import 'widgets/emoji_picker_widget.dart';
import 'widgets/enhanced_chat_input.dart';
import 'widgets/enhanced_message_bubble.dart';
import 'widgets/game_activities_widget.dart';
import 'widgets/sticker_picker_widget.dart';

/// Model for chat messages
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.userId,
    required this.username,
    required this.avatar,
    required this.content,
    required this.timestamp,
    this.attachments = const [],
    this.reactions = const [],
    this.isBot = false,
    this.replyTo,
    this.type = MessageType.text,
  });
  final String id;
  final String userId;
  final String username;
  final String avatar;
  final String content;
  final DateTime timestamp;
  final List<String> attachments;
  final List<String> reactions;
  final bool isBot;
  final String? replyTo;
  final MessageType type;
}

enum MessageType { text, image, video, audio, file, sticker, system }

/// Channel chat interface similar to Discord
class ChannelChatPage extends StatefulWidget {
  const ChannelChatPage({
    super.key,
    required this.community,
    required this.channel,
  });
  final Community community;
  final Channel channel;

  @override
  State<ChannelChatPage> createState() => _ChannelChatPageState();
}

class _ChannelChatPageState extends State<ChannelChatPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  bool _isTyping = false;
  bool _showEmojiPicker = false;
  bool _showStickers = false;
  ChatMessage? _replyingTo;

  // Demo messages
  final List<ChatMessage> _messages = [
    ChatMessage(
      id: '1',
      userId: 'user1',
      username: 'Sarah Chen',
      avatar: 'https://i.pravatar.cc/150?img=1',
      content: 'Hey everyone! Just joined this amazing community 🎉',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      reactions: ['🔥', '👋', '🎉'],
    ),
    ChatMessage(
      id: '2',
      userId: 'user2',
      username: 'Alex Rodriguez',
      avatar: 'https://i.pravatar.cc/150?img=2',
      content:
          'Welcome Sarah! Great to have you here. Make sure to check out the governance channel for the latest proposals.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
      reactions: ['👍', '❤️'],
    ),
    ChatMessage(
      id: '3',
      userId: 'user3',
      username: 'Maria Santos',
      avatar: 'https://i.pravatar.cc/150?img=3',
      content: 'Anyone else excited about the upcoming token launch? 🚀',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      reactions: ['🚀', '💎', '🔥'],
    ),
    ChatMessage(
      id: '4',
      userId: 'user4',
      username: 'Jordan Kim',
      avatar: 'https://i.pravatar.cc/150?img=4',
      content:
          'Just dropped some new artwork in the showcase channel. Would love your feedback!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
      attachments: ['artwork.jpg'],
      reactions: ['🎨', '😍', '👏'],
    ),
    ChatMessage(
      id: '5',
      userId: 'user5',
      username: 'Chris Wilson',
      avatar: 'https://i.pravatar.cc/150?img=5',
      content: 'GM everyone! Ready for another productive day in the DAO 💪',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      reactions: ['☀️', '💪', '🚀'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _messageFocusNode.addListener(_onFocusChange);
    _messageController.addListener(_onTextChange);
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
  }

  void _onFocusChange() {
    // Focus handling is now managed by EnhancedChatInput
  }

  void _onTextChange() {
    final hasText = _messageController.text.isNotEmpty;
    if (hasText != _isTyping) {
      setState(() {
        _isTyping = hasText;
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _messageController.dispose();
    _messageFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackgroundPrimary
          : AppColors.backgroundPrimary,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildHeader(isDarkMode),
            Expanded(child: _buildMessagesList(isDarkMode)),
            _buildReplyBar(isDarkMode),
            _buildInputSection(isDarkMode),
            if (_showEmojiPicker)
              EmojiPickerWidget(
                onEmojiSelected: _onEmojiSelected,
                isDarkMode: isDarkMode,
              ),
            if (_showStickers)
              StickerPickerWidget(
                onStickerSelected: _onStickerSelected,
                isDarkMode: isDarkMode,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.h,
        left: 16.w,
        right: 16.w,
        bottom: 12.h,
      ),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.black : AppColors.white,
        border: Border(
          bottom: BorderSide(
            color: isDarkMode
                ? AppColors.darkContainerBorder
                : AppColors.gray200,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              PhosphorIcons.arrowLeft(PhosphorIconsStyle.bold),
              color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Icon(_getChannelIcon(), color: AppColors.primary, size: 18.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.channel.name,
                  style: AppTypography.geistSemiBold15.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                    fontSize: 16.sp,
                  ),
                ),
                if (widget.channel.description.isNotEmpty)
                  Text(
                    widget.channel.description,
                    style: AppTypography.geistRegular11.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.gray600,
                      fontSize: 12.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Row(
            children: [
              _buildHeaderAction(
                PhosphorIcons.usersFour(PhosphorIconsStyle.bold),
                isDarkMode,
                () => _showMembersList(),
              ),
              SizedBox(width: 8.w),
              _buildHeaderAction(
                PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold),
                isDarkMode,
                () => _showSearch(),
              ),
              SizedBox(width: 8.w),
              _buildHeaderAction(
                PhosphorIcons.dotsThreeVertical(PhosphorIconsStyle.bold),
                isDarkMode,
                () => _showChannelMenu(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderAction(
    PhosphorIconData icon,
    bool isDarkMode,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.darkContainerBorder.withOpacity(0.3)
              : AppColors.gray100,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          icon,
          color: isDarkMode ? AppColors.darkTextSecondary : AppColors.gray600,
          size: 16.sp,
        ),
      ),
    );
  }

  Widget _buildMessagesList(bool isDarkMode) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isConsecutive =
            index > 0 &&
            _messages[index - 1].userId == message.userId &&
            message.timestamp
                    .difference(_messages[index - 1].timestamp)
                    .inMinutes <
                5;

        return EnhancedMessageBubble(
          message: message,
          isCurrentUser: message.userId == 'current_user',
          isGrouped: isConsecutive,
          showAvatar: !isConsecutive,
          showTimestamp: !isConsecutive,
          onReply: _replyToMessage,
          onReact: _addReaction,
          onEdit: _editMessage,
          onDelete: _deleteMessage,
          onUserTap: _showUserProfile,
          isDarkMode: isDarkMode,
        );
      },
    );
  }

  Widget _buildMessageItem(
    ChatMessage message,
    bool isDarkMode,
    bool isConsecutive,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: isConsecutive ? 2.h : 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar or timestamp
          SizedBox(
            width: 40.w,
            child: isConsecutive
                ? Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _formatTime(message.timestamp),
                      style: AppTypography.geistRegular11.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.gray600,
                        fontSize: 10.sp,
                      ),
                    ),
                  )
                : CircleAvatar(
                    radius: 20.r,
                    backgroundImage: NetworkImage(message.avatar),
                  ),
          ),
          SizedBox(width: 12.w),
          // Message content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isConsecutive)
                  Row(
                    children: [
                      Text(
                        message.username,
                        style: AppTypography.geistSemiBold15.copyWith(
                          color: isDarkMode
                              ? AppColors.darkTextPrimary
                              : AppColors.gray900,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        _formatTime(message.timestamp),
                        style: AppTypography.geistRegular11.copyWith(
                          color: isDarkMode
                              ? AppColors.darkTextSecondary
                              : AppColors.gray600,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                if (!isConsecutive) SizedBox(height: 4.h),
                // Message content
                GestureDetector(
                  onLongPress: () => _showMessageOptions(message),
                  child: message.type == MessageType.sticker
                      ? Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? AppColors.darkContainerBorder.withOpacity(0.3)
                                : AppColors.gray100,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            message.content,
                            style: TextStyle(fontSize: 64.sp),
                          ),
                        )
                      : Text(
                          message.content,
                          style: AppTypography.geistRegular13.copyWith(
                            color: isDarkMode
                                ? AppColors.darkTextSecondary
                                : AppColors.gray700,
                            fontSize: 14.sp,
                          ),
                        ),
                ),
                // Attachments
                if (message.attachments.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(top: 8.h),
                    child: _buildAttachments(message.attachments, isDarkMode),
                  ),
                // Reactions
                if (message.reactions.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(top: 8.h),
                    child: _buildReactions(message.reactions, isDarkMode),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachments(List<String> attachments, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkContainerBorder.withOpacity(0.3)
            : AppColors.gray100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(
            PhosphorIcons.image(PhosphorIconsStyle.bold),
            color: AppColors.primary,
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            attachments.first,
            style: AppTypography.geistMedium13.copyWith(
              color: AppColors.primary,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReactions(List<String> reactions, bool isDarkMode) {
    return Wrap(
      spacing: 6.w,
      children: reactions.map((reaction) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppColors.darkContainerBorder.withOpacity(0.3)
                : AppColors.gray100,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(reaction, style: TextStyle(fontSize: 14.sp)),
        );
      }).toList(),
    );
  }

  Widget _buildReplyBar(bool isDarkMode) {
    if (_replyingTo == null) return const SizedBox();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkContainerBorder.withOpacity(0.3)
            : AppColors.gray100,
        border: Border(
          top: BorderSide(
            color: isDarkMode
                ? AppColors.darkContainerBorder
                : AppColors.gray200,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            PhosphorIcons.arrowBendUpLeft(PhosphorIconsStyle.bold),
            color: AppColors.primary,
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'Replying to ${_replyingTo!.username}',
              style: AppTypography.geistMedium13.copyWith(
                color: AppColors.primary,
                fontSize: 13.sp,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _replyingTo = null),
            child: Icon(
              PhosphorIcons.x(PhosphorIconsStyle.bold),
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
              size: 16.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection(bool isDarkMode) {
    return EnhancedChatInput(
      controller: _messageController,
      focusNode: _messageFocusNode,
      onSendMessage: _sendMessage,
      onAttachmentTap: _showAttachmentOptions,
      onEmojiTap: _toggleEmojiPicker,
      onStickerTap: _toggleStickers,
      isDarkMode: isDarkMode,
      hintText: 'Message #${widget.channel.name}',
      replyingTo: _replyingTo?.content,
      onCancelReply: _cancelReply,
      onMentionTap: _showMentionPicker,
      isTyping: _isTyping,
      typingUsers: const [], // TODO: Implement typing users from WebSocket
    );
  }

  Widget _buildInputAction(
    PhosphorIconData icon,
    bool isDarkMode,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.darkContainerBorder.withOpacity(0.3)
              : AppColors.gray100,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          icon,
          color: isDarkMode ? AppColors.darkTextSecondary : AppColors.gray600,
          size: 20.sp,
        ),
      ),
    );
  }

  PhosphorIconData _getChannelIcon() {
    switch (widget.channel.type) {
      case ChannelType.text:
        return PhosphorIcons.hash(PhosphorIconsStyle.bold);
      case ChannelType.voice:
        return PhosphorIcons.speakerHigh(PhosphorIconsStyle.bold);
      case ChannelType.announcement:
        return PhosphorIcons.megaphone(PhosphorIconsStyle.bold);
      case ChannelType.stage:
        return PhosphorIcons.microphone(PhosphorIconsStyle.bold);
      case ChannelType.forum:
        return PhosphorIcons.chatCircle(PhosphorIconsStyle.bold);
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return 'now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h';
    } else {
      return '${diff.inDays}d';
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    // Add message to list (in real app, this would be sent to backend)
    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user',
      username: 'You',
      avatar: 'https://i.pravatar.cc/150?img=6',
      content: _messageController.text.trim(),
      timestamp: DateTime.now(),
      replyTo: _replyingTo?.id,
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
      _replyingTo = null;
    });

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _showMembersList() {
    // Show members list
    debugPrint('Show members list');
  }

  void _showSearch() {
    // Show search
    debugPrint('Show search');
  }

  void _showChannelMenu() {
    // Show channel menu
    debugPrint('Show channel menu');
  }

  void _showMessageOptions(ChatMessage message) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.black
              : AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12.h),
            Container(
              width: 32.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkTextSecondary
                    : AppColors.gray400,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            _buildMessageAction(
              icon: PhosphorIcons.arrowBendUpLeft(PhosphorIconsStyle.bold),
              label: 'Reply',
              onTap: () {
                Navigator.pop(context);
                setState(() => _replyingTo = message);
                _messageFocusNode.requestFocus();
              },
            ),
            _buildMessageAction(
              icon: PhosphorIcons.copy(PhosphorIconsStyle.bold),
              label: 'Copy Text',
              onTap: () {
                Navigator.pop(context);
                // Copy to clipboard
                debugPrint('Copy text: ${message.content}');
              },
            ),
            _buildMessageAction(
              icon: PhosphorIcons.smiley(PhosphorIconsStyle.bold),
              label: 'Add Reaction',
              onTap: () {
                Navigator.pop(context);
                // Show quick reactions
                _showQuickReactions(message);
              },
            ),
            if (message.userId == 'current_user') ...[
              _buildMessageAction(
                icon: PhosphorIcons.pencil(PhosphorIconsStyle.bold),
                label: 'Edit',
                onTap: () {
                  Navigator.pop(context);
                  // Edit message
                  debugPrint('Edit message: ${message.id}');
                },
              ),
              _buildMessageAction(
                icon: PhosphorIcons.trash(PhosphorIconsStyle.bold),
                label: 'Delete',
                color: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  // Delete message
                  _deleteMessage(message);
                },
              ),
            ],
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageAction({
    required PhosphorIconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final actionColor =
        color ?? (isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          children: [
            Icon(icon, color: actionColor, size: 20.sp),
            SizedBox(width: 16.w),
            Text(
              label,
              style: AppTypography.geistMedium13.copyWith(
                color: actionColor,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickReactions(ChatMessage message) {
    // Show quick reactions
    debugPrint('Show quick reactions for message: ${message.id}');
  }

  void _showAttachmentOptions() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AttachmentOptionsDialog(
        isDarkMode: Theme.of(context).brightness == Brightness.dark,
        onCamera: () {
          Navigator.pop(context);
          _handleCameraCapture();
        },
        onGallery: () {
          Navigator.pop(context);
          _handleGalleryPick();
        },
        onFile: () {
          Navigator.pop(context);
          _handleFilePick();
        },
        onVideo: () {
          Navigator.pop(context);
          _handleVideoPick();
        },
        onAudio: () {
          Navigator.pop(context);
          _handleAudioPick();
        },
      ),
    );
  }

  void _handleCameraCapture() {
    // Handle camera capture
    debugPrint('Camera capture');
  }

  void _handleGalleryPick() {
    // Handle gallery pick
    debugPrint('Gallery pick');
  }

  void _handleFilePick() {
    // Handle file pick
    debugPrint('File pick');
  }

  void _handleVideoPick() {
    // Handle video pick
    debugPrint('Video pick');
  }

  void _handleAudioPick() {
    // Handle audio pick
    debugPrint('Audio pick');
  }

  void _showGameActivities() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GameActivitiesWidget(
        isDarkMode: Theme.of(context).brightness == Brightness.dark,
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  void _startThread() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.black
            : AppColors.white,
        title: Text(
          'Start Thread',
          style: AppTypography.geistSemiBold15.copyWith(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkTextPrimary
                : AppColors.gray900,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose who to start a private conversation with:',
              style: AppTypography.geistRegular13.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkTextSecondary
                    : AppColors.gray600,
              ),
            ),
            SizedBox(height: 16.h),
            _buildThreadOption(
              icon: PhosphorIcons.user(PhosphorIconsStyle.bold),
              title: 'Direct Message',
              description: 'Start a private conversation with someone',
              onTap: () {
                Navigator.pop(context);
                _startDirectMessage();
              },
            ),
            SizedBox(height: 12.h),
            _buildThreadOption(
              icon: PhosphorIcons.users(PhosphorIconsStyle.bold),
              title: 'Group Chat',
              description: 'Create a small group conversation',
              onTap: () {
                Navigator.pop(context);
                _startGroupChat();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTypography.geistMedium13.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkTextSecondary
                    : AppColors.gray600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThreadOption({
    required PhosphorIconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.darkContainerBorder.withOpacity(0.3)
              : AppColors.gray100,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.geistSemiBold15.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextPrimary
                          : AppColors.gray900,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    description,
                    style: AppTypography.geistRegular12.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.gray600,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startDirectMessage() {
    // Start direct message
    debugPrint('Start direct message');
  }

  void _startGroupChat() {
    // Start group chat
    debugPrint('Start group chat');
  }

  void _toggleEmojiPicker() {
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
      if (_showEmojiPicker) _showStickers = false;
    });
  }

  void _toggleStickers() {
    setState(() {
      _showStickers = !_showStickers;
      if (_showStickers) _showEmojiPicker = false;
    });
  }

  void _onEmojiSelected(String emoji) {
    _messageController.text += emoji;
    _messageController.selection = TextSelection.fromPosition(
      TextPosition(offset: _messageController.text.length),
    );
  }

  void _onStickerSelected(String sticker) {
    // Send sticker as message
    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user',
      username: 'You',
      avatar: 'https://i.pravatar.cc/150?img=6',
      content: sticker,
      timestamp: DateTime.now(),
      type: MessageType.sticker,
      replyTo: _replyingTo?.id,
    );

    setState(() {
      _messages.add(newMessage);
      _replyingTo = null;
      _showStickers = false;
    });

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  // Message interaction methods
  void _replyToMessage(ChatMessage message) {
    setState(() {
      _replyingTo = message;
    });
    _messageFocusNode.requestFocus();
  }

  void _addReaction(ChatMessage message, String reaction) {
    // Find the message and add the reaction
    final messageIndex = _messages.indexWhere((m) => m.id == message.id);
    if (messageIndex != -1) {
      final updatedMessage = ChatMessage(
        id: message.id,
        userId: message.userId,
        username: message.username,
        avatar: message.avatar,
        content: message.content,
        timestamp: message.timestamp,
        attachments: message.attachments,
        reactions: [...message.reactions, reaction],
        isBot: message.isBot,
        replyTo: message.replyTo,
        type: message.type,
      );
      setState(() {
        _messages[messageIndex] = updatedMessage;
      });
    }
    debugPrint('Added reaction $reaction to message: ${message.content}');
  }

  void _editMessage(ChatMessage message) {
    // TODO: Implement message editing
    debugPrint('Edit message: ${message.content}');
  }

  void _deleteMessage(ChatMessage message) {
    setState(() {
      _messages.removeWhere((m) => m.id == message.id);
    });
    debugPrint('Deleted message: ${message.content}');
  }

  void _showUserProfile(String userId) {
    // TODO: Show user profile modal
    debugPrint('Show profile for user: $userId');
  }

  void _cancelReply() {
    setState(() {
      _replyingTo = null;
    });
  }

  void _showMentionPicker() {
    // TODO: Show user mention picker
    debugPrint('Show mention picker');
  }
}
