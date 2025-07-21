import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/data/chat_demo_data.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../domain/entities/community.dart';
import '../../../domain/models/chat/chat_message.dart';
import '../community_detail_page.dart';
import 'widgets/asset_selector_dialog.dart';
import 'widgets/attachment_options_dialog.dart';
import 'widgets/channel_header_widget.dart';
import 'widgets/emoji_picker_widget.dart';
import 'widgets/enhanced_chat_input.dart';
import 'widgets/enhanced_online_members_sidebar.dart';
import 'widgets/enhanced_typing_indicator_overlay.dart';
import 'widgets/messages_list_widget.dart';
import 'widgets/reply_bar_widget.dart';
import 'widgets/sticker_picker_widget.dart';

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
  bool _showMembersSidebar = false;
  ChatMessage? _replyingTo;
  bool _isAtBottom = true; // Track if user is at bottom of chat

  // Get demo messages from ChatDemoData
  final List<ChatMessage> _messages = ChatDemoData.getMessages();

  // Demo online members for sidebar
  final List<OnlineMember> _onlineMembers = [
    OnlineMember(
      id: 'user1',
      displayName: 'Sarah Chen',
      avatar: 'https://i.pravatar.cc/150?img=1',
      status: MemberStatus.online,
      isOnline: true,
      role: 'Admin',
      activity: 'Working on proposal #42',
    ),
    OnlineMember(
      id: 'user2',
      displayName: 'Alex Rodriguez',
      avatar: 'https://i.pravatar.cc/150?img=2',
      status: MemberStatus.online,
      isOnline: true,
      role: 'Moderator',
      activity: 'Reviewing governance docs',
    ),
    OnlineMember(
      id: 'user3',
      displayName: 'Maria Santos',
      avatar: 'https://i.pravatar.cc/150?img=3',
      status: MemberStatus.idle,
      isOnline: true,
      role: 'Member',
      customStatus: 'Building the future 🚀',
    ),
    OnlineMember(
      id: 'user4',
      displayName: 'Jordan Kim',
      avatar: 'https://i.pravatar.cc/150?img=4',
      status: MemberStatus.doNotDisturb,
      isOnline: true,
      role: 'Core Team',
      activity: 'In meeting',
    ),
    OnlineMember(
      id: 'user5',
      displayName: 'Chris Wilson',
      avatar: 'https://i.pravatar.cc/150?img=5',
      status: MemberStatus.online,
      isOnline: true,
      role: 'Member',
      activity: 'Exploring new DeFi protocols',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _messageFocusNode.addListener(_onFocusChange);
    _messageController.addListener(_onTextChange);
    _scrollController.addListener(_onScrollChanged);
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

    return GestureDetector(
      // Add tap handling to unfocus when tapping outside input
      onTap: () {
        if (_messageFocusNode.hasFocus) {
          _messageFocusNode.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: isDarkMode
            ? AppColors.darkBackgroundPrimary
            : AppColors.backgroundPrimary,
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SafeArea(
            child: Column(
              children: [
                // Channel header (now modularized)
                _buildHeader(isDarkMode),

                // Messages area with optional sidebar
                Expanded(
                  child: Row(
                    children: [
                      // Main chat area with floating scroll-to-bottom button
                      Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.r),
                              topRight: _showMembersSidebar
                                  ? Radius.zero
                                  : Radius.circular(16.r),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.r),
                              topRight: _showMembersSidebar
                                  ? Radius.zero
                                  : Radius.circular(16.r),
                            ),
                            child: _buildMessagesWithBackground(isDarkMode),
                          ),
                        ),
                      ),

                      // Members sidebar
                      if (_showMembersSidebar)
                        EnhancedOnlineMembersSidebar(
                          onlineMembers: _onlineMembers,
                          isDarkMode: isDarkMode,
                          onMemberTap: _showUserProfileFromMember,
                        ),
                    ],
                  ),
                ),

                // Reply bar (now modularized)
                _buildReplyBar(isDarkMode),

                // Input section
                _buildInputSection(isDarkMode),

                // Emoji & Sticker pickers
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
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return ChannelHeaderWidget(
      channelName: widget.channel.name,
      channelDescription: widget.channel.description,
      channelIcon: _getChannelIcon(),
      onlineCount: 14, // This would come from a real-time service
      isDarkMode: isDarkMode,
      onBackPressed: () => Navigator.pop(context),
      showMenu: () {
        final RenderBox button = context.findRenderObject()! as RenderBox;
        final RenderBox overlay =
            Navigator.of(context).overlay!.context.findRenderObject()!
                as RenderBox;
        final RelativeRect position = RelativeRect.fromRect(
          Rect.fromPoints(
            button.localToGlobal(Offset.zero, ancestor: overlay),
            button.localToGlobal(
              button.size.bottomRight(Offset.zero),
              ancestor: overlay,
            ),
          ),
          Offset.zero & overlay.size,
        );

        showMenu(
          context: context,
          position: position,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          color: isDarkMode
              ? AppColors.darkContainerBorder
              : AppColors.backgroundPrimary,
          items: [
            PopupMenuItem<String>(
              value: 'members',
              onTap: _showMembersList,
              child: _buildMenuOption(
                PhosphorIcons.usersFour(PhosphorIconsStyle.bold),
                'Members',
                isDarkMode,
              ),
            ),
            PopupMenuItem<String>(
              value: 'search',
              onTap: _showSearch,
              child: _buildMenuOption(
                PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold),
                'Search',
                isDarkMode,
              ),
            ),
            PopupMenuItem<String>(
              value: 'settings',
              onTap: _showChannelMenu,
              child: _buildMenuOption(
                PhosphorIcons.gear(PhosphorIconsStyle.bold),
                'Channel Settings',
                isDarkMode,
              ),
            ),
          ],
        );
      },
    );
  }

  // Menu option builder still used in the ChannelHeaderWidget showMenu callback

  Widget _buildMenuOption(
    PhosphorIconData icon,
    String label,
    bool isDarkMode,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18.sp,
          color: isDarkMode ? AppColors.darkTextSecondary : AppColors.gray600,
        ),
        SizedBox(width: 12.w),
        Text(
          label,
          style: AppTypography.geistMedium13.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
          ),
        ),
      ],
    );
  }

  // Methods removed as they're now handled by ChannelHeaderWidget

  // Original _buildOnlineIndicator method removed as it's no longer used

  // Removed unused _buildHeaderAction method

  Widget _buildMessagesWithBackground(bool isDarkMode) {
    return Stack(
      children: [
        // Enhanced Background with customizable community chat backgrounds
        AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          decoration: BoxDecoration(
            // TODO: Replace with community-specific background from community settings
            // Community hosts should be able to upload custom chat backgrounds
            image: const DecorationImage(
              image: AssetImage('assets/images/chat-bg-01.png'),
              fit: BoxFit.cover,
              opacity: 0.08, // Slightly more visible for better ambiance
            ),
            // Gradient overlay for better text readability
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                (isDarkMode
                        ? AppColors.darkBackgroundSecondary
                        : AppColors.backgroundSecondary)
                    .withValues(alpha: 0.85),
                (isDarkMode
                        ? AppColors.darkBackgroundSecondary
                        : AppColors.backgroundSecondary)
                    .withValues(alpha: 0.95),
              ],
            ),
          ),
        ),
        // Subtle pattern overlay for texture
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/images/chat-bg-01.png'),
              fit: BoxFit.cover,
              opacity: isDarkMode ? 0.02 : 0.03,
              colorFilter: ColorFilter.mode(
                isDarkMode
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.primary.withValues(alpha: 0.05),
                BlendMode.overlay,
              ),
            ),
          ),
        ),
        // Messages list with enhanced animations and overlays
        _buildMessagesList(isDarkMode),

        // Floating scroll-to-bottom button
        if (_shouldShowScrollToBottom())
          Positioned(
            bottom: 80.h,
            right: 16.w,
            child: _buildScrollToBottomFAB(isDarkMode),
          ),
      ],
    );
  }

  // Track typing indicator overlay height for proper spacing
  double _typingIndicatorHeight = 0;

  Widget _buildMessagesList(bool isDarkMode) {
    final typingUsers = ChatDemoData.getTypingUsers();

    return Stack(
      children: [
        // Main message list
        MessagesListWidget(
          messages: _messages,
          scrollController: _scrollController,
          isDarkMode: isDarkMode,
          onReply: _replyToMessage,
          onReact: _addReaction,
          onEdit: _editMessage,
          onDelete: _deleteMessage,
          onUserTap: _showUserProfile,
          bottomPadding:
              _typingIndicatorHeight, // Add padding for the typing indicator
        ),

        // Typing indicator overlay positioned at the bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: EnhancedTypingIndicatorOverlay(
            typingUsers: typingUsers,
            isDarkMode: isDarkMode,
            onHeightChanged: (height) {
              // Only update state if height changed to avoid unnecessary rebuilds
              if (height != _typingIndicatorHeight) {
                setState(() {
                  _typingIndicatorHeight = height;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  // This method has been removed as it's now handled by EnhancedMessageBubble

  // These methods have been removed as they're now handled by EnhancedMessageBubble

  Widget _buildReplyBar(bool isDarkMode) {
    if (_replyingTo == null) {
      return const SizedBox();
    }

    return ReplyBarWidget(
      replyingTo: _replyingTo!,
      onCancelReply: _cancelReply,
      isDarkMode: isDarkMode,
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
      onTagTap: () => _showAssetSelector(AssetType.tag),
      onRoleTap: () => _showAssetSelector(AssetType.role),
      onNftTap: () => _showAssetSelector(AssetType.nft),
      onTokenTap: () => _showAssetSelector(AssetType.token),
      isTyping: _isTyping,
      typingUsers: ChatDemoData.getTypingUsers(),
    );
  }

  // This method has been removed as it's no longer used

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

  // This method has been removed as it's now handled by EnhancedMessageBubble

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) {
      return;
    }

    // Check if widget is still mounted
    if (!mounted) {
      return;
    }

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

    // Scroll to bottom using post-frame callback to ensure scroll controller is still attached
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _showMembersList() {
    setState(() {
      _showMembersSidebar = !_showMembersSidebar;
    });
  }

  void _showUserProfileFromMember(OnlineMember member) {
    _showUserProfile(member.id);
  }

  void _showSearch() {
    // Show search
    debugPrint('Show search');
  }

  void _showChannelMenu() {
    // Show channel menu
    debugPrint('Show channel menu');
  }

  // These methods have been removed as they're now handled by EnhancedMessageBubble

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

  // These methods have been removed as they're no longer used

  void _toggleEmojiPicker() {
    // Check if widget is still mounted before calling setState
    if (!mounted) {
      return;
    }

    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
      if (_showEmojiPicker) {
        _showStickers = false;
      }
    });
  }

  void _toggleStickers() {
    // Check if widget is still mounted before calling setState
    if (!mounted) {
      return;
    }

    setState(() {
      _showStickers = !_showStickers;
      if (_showStickers) {
        _showEmojiPicker = false;
      }
    });
  }

  void _onEmojiSelected(String emoji) {
    // Check if widget is still mounted to avoid setState after dispose errors
    if (!mounted) {
      return;
    }

    final currentText = _messageController.text;
    final selection = _messageController.selection;

    if (selection.isValid) {
      // If there's a valid selection, replace it with the emoji
      final newText = currentText.replaceRange(
        selection.start,
        selection.end,
        emoji,
      );
      _messageController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: selection.start + emoji.length,
        ),
      );
    } else {
      // If no selection, just append to end
      _messageController.text = currentText + emoji;
      _messageController.selection = TextSelection.collapsed(
        offset: _messageController.text.length,
      );
    }

    // Close emoji picker after selecting
    setState(() {
      _showEmojiPicker = false;
    });
  }

  void _onStickerSelected(String sticker) {
    // Check if widget is still mounted to avoid setState after dispose errors
    if (!mounted) {
      return;
    }

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

    // Scroll to bottom - using post-frame callback to ensure widget is still mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
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
    // Find the message and toggle the reaction
    final messageIndex = _messages.indexWhere((m) => m.id == message.id);
    if (messageIndex != -1) {
      final List<String> updatedReactions = [...message.reactions];

      // Check if reaction already exists to toggle it
      if (updatedReactions.contains(reaction)) {
        updatedReactions.remove(reaction);
        debugPrint(
          'Removed reaction $reaction from message: ${message.content}',
        );
      } else {
        updatedReactions.add(reaction);
        debugPrint('Added reaction $reaction to message: ${message.content}');
      }

      final updatedMessage = ChatMessage(
        id: message.id,
        userId: message.userId,
        username: message.username,
        avatar: message.avatar,
        content: message.content,
        timestamp: message.timestamp,
        attachments: message.attachments,
        reactions: updatedReactions,
        isBot: message.isBot,
        replyTo: message.replyTo,
        type: message.type,
        sentAsset: message.sentAsset,
        isClaimable: message.isClaimable,
        isClaimed: message.isClaimed,
        claimableUntil: message.claimableUntil,
        mentionedUsers: message.mentionedUsers,
        taggedRoles: message.taggedRoles,
      );

      setState(() {
        _messages[messageIndex] = updatedMessage;
      });
    }
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

  void _showAssetSelector(AssetType assetType) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AssetSelectorDialog(
        assetType: assetType,
        isDarkMode: Theme.of(context).brightness == Brightness.dark,
        onAssetSelected: (asset) {
          _sendAssetMessage(asset);
        },
      ),
    );
  }

  void _sendAssetMessage(SentAsset asset) {
    // Check if widget is still mounted
    if (!mounted) {
      return;
    }

    // Determine message type based on asset type
    final messageType = switch (asset.type) {
      AssetType.token => MessageType.token,
      AssetType.nft => MessageType.nft,
      AssetType.role => MessageType.role,
      AssetType.tag => MessageType.tag,
    };

    // Content message based on asset type
    final content = switch (asset.type) {
      AssetType.token => 'Sent ${asset.value} ${asset.name} tokens',
      AssetType.nft => 'Shared NFT: ${asset.name}',
      AssetType.role => 'Assigned role: ${asset.name}',
      AssetType.tag => 'Tagged as: ${asset.name}',
    };

    // Create the message
    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user',
      username: 'You',
      avatar: 'https://i.pravatar.cc/150?img=6',
      content: content,
      timestamp: DateTime.now(),
      type: messageType,
      sentAsset: asset,
      isClaimable: asset.type == AssetType.token || asset.type == AssetType.nft,
      claimableUntil:
          asset.type == AssetType.token || asset.type == AssetType.nft
          ? DateTime.now().add(const Duration(days: 7))
          : null,
    );

    setState(() {
      _messages.add(newMessage);
    });

    // Scroll to bottom using post-frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onScrollChanged() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      setState(() {
        _isAtBottom = currentScroll >= (maxScroll - 100); // 100px threshold
      });
    }
  }

  bool _shouldShowScrollToBottom() {
    return !_isAtBottom && _messages.isNotEmpty;
  }

  Widget _buildScrollToBottomFAB(bool isDarkMode) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _shouldShowScrollToBottom() ? 1.0 : 0.0,
      child: FloatingActionButton.small(
        onPressed: _scrollToBottom,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(PhosphorIcons.arrowDown(PhosphorIconsStyle.bold), size: 20.sp),
            // Show new message count if there are unread messages
            if (_getUnreadMessageCount() > 0)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(minWidth: 16.w, minHeight: 16.h),
                  child: Text(
                    _getUnreadMessageCount().toString(),
                    style: AppTypography.geistSemiBold15.copyWith(
                      color: Colors.white,
                      fontSize: 10.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  int _getUnreadMessageCount() {
    // In a real app, this would track unread messages below current scroll position
    // For demo purposes, return 3 if not at bottom
    return _shouldShowScrollToBottom() ? 3 : 0;
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}
