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
import 'widgets/emoji_picker_widget.dart';
import 'widgets/enhanced_chat_input.dart';
import 'widgets/enhanced_message_bubble.dart';
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
  ChatMessage? _replyingTo;

  // Get demo messages from ChatDemoData
  final List<ChatMessage> _messages = ChatDemoData.getMessages();

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
                _buildHeader(isDarkMode),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.darkBackgroundSecondary
                          : AppColors.backgroundSecondary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                      ),
                      child: _buildMessagesList(isDarkMode),
                    ),
                  ),
                ),
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
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkBackgroundPrimary
            : AppColors.backgroundPrimary,
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(0, 2),
              blurRadius: 5,
            ),
        ],
      ),
      child: Row(
        children: [
          // Back button with animation
          _buildBackButton(isDarkMode),
          SizedBox(width: 12.w),

          // Channel icon and name
          Icon(_getChannelIcon(), color: AppColors.primary, size: 20.sp),
          SizedBox(width: 8.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Channel name
                    Text(
                      widget.channel.name,
                      style: AppTypography.geistSemiBold15.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextPrimary
                            : AppColors.gray900,
                        fontSize: 17.sp,
                      ),
                    ),
                    SizedBox(width: 6.w),

                    // Embedded online indicator
                    _buildEmbeddedOnlineCount(isDarkMode),
                  ],
                ),
                if (widget.channel.description.isNotEmpty)
                  Text(
                    widget.channel.description,
                    style: AppTypography.geistRegular13.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.gray600,
                      fontSize: 13.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),

          // Consolidated action button
          _buildPopupMenuButton(isDarkMode),
        ],
      ),
    );
  }

  // New method for consolidated actions menu
  Widget _buildPopupMenuButton(bool isDarkMode) {
    return _buildIconButton(
      PhosphorIcons.dotsThreeVertical(PhosphorIconsStyle.bold),
      isDarkMode,
      () {
        final RenderBox button = context.findRenderObject() as RenderBox;
        final RenderBox overlay =
            Navigator.of(context).overlay!.context.findRenderObject()
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
              child: _buildMenuOption(
                PhosphorIcons.usersFour(PhosphorIconsStyle.bold),
                'Members',
                isDarkMode,
              ),
              onTap: _showMembersList,
            ),
            PopupMenuItem<String>(
              value: 'search',
              child: _buildMenuOption(
                PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold),
                'Search',
                isDarkMode,
              ),
              onTap: _showSearch,
            ),
            PopupMenuItem<String>(
              value: 'settings',
              child: _buildMenuOption(
                PhosphorIcons.gear(PhosphorIconsStyle.bold),
                'Channel Settings',
                isDarkMode,
              ),
              onTap: _showChannelMenu,
            ),
          ],
        );
      },
    );
  }

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

  // New method for embedded online count
  Widget _buildEmbeddedOnlineCount(bool isDarkMode) {
    final onlineCount =
        14; // This would come from a real-time service in production

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkContainerBorder.withOpacity(0.2)
            : AppColors.gray100,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            '$onlineCount',
            style: AppTypography.geistRegular13.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkContainerBorder.withOpacity(0.3)
            : AppColors.gray100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.r),
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Icon(
              PhosphorIcons.arrowLeft(PhosphorIconsStyle.bold),
              color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
              size: 20.sp,
            ),
          ),
        ),
      ),
    );
  }

  // This method was renamed to avoid duplication with the previous definition
  Widget _buildIconButton(
    PhosphorIconData icon,
    bool isDarkMode,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkContainerBorder.withOpacity(0.3)
            : AppColors.gray100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Icon(
              icon,
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
              size: 18.sp,
            ),
          ),
        ),
      ),
    );
  }

  // Original _buildOnlineIndicator method removed as it's no longer used

  // Removed unused _buildHeaderAction method

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

  // This method has been removed as it's now handled by EnhancedMessageBubble

  // These methods have been removed as they're now handled by EnhancedMessageBubble

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
    if (_messageController.text.trim().isEmpty) return;

    // Check if widget is still mounted
    if (!mounted) return;

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
    if (!mounted) return;

    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
      if (_showEmojiPicker) _showStickers = false;
    });
  }

  void _toggleStickers() {
    // Check if widget is still mounted before calling setState
    if (!mounted) return;

    setState(() {
      _showStickers = !_showStickers;
      if (_showStickers) _showEmojiPicker = false;
    });
  }

  void _onEmojiSelected(String emoji) {
    // Check if widget is still mounted to avoid setState after dispose errors
    if (!mounted) return;

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
    if (!mounted) return;

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
    if (!mounted) return;

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
}
