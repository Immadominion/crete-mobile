import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/voice_models.dart';
import '../../../core/theme/colors.dart';

class CallControls extends StatefulWidget {
  final bool isMuted;
  final bool isVideoOn;
  final bool isSpeakerOn;
  final bool isScreenSharing;
  final bool isChatVisible;
  final VoidCallback onToggleMute;
  final VoidCallback onToggleVideo;
  final VoidCallback onToggleSpeaker;
  final VoidCallback onToggleScreenShare;
  final VoidCallback onToggleChat;
  final VoidCallback onEndCall;
  final VoiceSessionType sessionType;

  const CallControls({
    super.key,
    required this.isMuted,
    required this.isVideoOn,
    required this.isSpeakerOn,
    required this.isScreenSharing,
    required this.isChatVisible,
    required this.onToggleMute,
    required this.onToggleVideo,
    required this.onToggleSpeaker,
    required this.onToggleScreenShare,
    required this.onToggleChat,
    required this.onEndCall,
    required this.sessionType,
  });

  @override
  State<CallControls> createState() => _CallControlsState();
}

class _CallControlsState extends State<CallControls>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isActive,
    Color? activeColor,
    Color? inactiveColor,
    bool isDestructive = false,
    String? tooltip,
  }) {
    final color = isDestructive
        ? AppColors.error
        : isActive
        ? (activeColor ?? AppColors.success)
        : (inactiveColor ?? Colors.white.withOpacity(0.8));

    return Tooltip(
      message: tooltip ?? '',
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 56.w,
          height: 56.h,
          decoration: BoxDecoration(
            color: isDestructive
                ? AppColors.error.withOpacity(0.2)
                : isActive
                ? Colors.white.withOpacity(0.2)
                : Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
            border: isActive && !isDestructive
                ? Border.all(color: activeColor ?? AppColors.success, width: 2)
                : null,
          ),
          child: Icon(icon, color: color, size: 24.sp),
        ),
      ),
    );
  }

  Widget _buildMainControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Mute/Unmute
        _buildControlButton(
          icon: widget.isMuted ? Icons.mic_off : Icons.mic,
          onTap: widget.onToggleMute,
          isActive: !widget.isMuted,
          tooltip: widget.isMuted ? 'Unmute' : 'Mute',
        ),

        // Video toggle (only for video calls)
        if (widget.sessionType == VoiceSessionType.video)
          _buildControlButton(
            icon: widget.isVideoOn ? Icons.videocam : Icons.videocam_off,
            onTap: widget.onToggleVideo,
            isActive: widget.isVideoOn,
            tooltip: widget.isVideoOn ? 'Turn off camera' : 'Turn on camera',
          ),

        // Speaker toggle
        _buildControlButton(
          icon: widget.isSpeakerOn ? Icons.volume_up : Icons.volume_off,
          onTap: widget.onToggleSpeaker,
          isActive: widget.isSpeakerOn,
          tooltip: widget.isSpeakerOn ? 'Turn off speaker' : 'Turn on speaker',
        ),

        // Screen share (only for video calls and meetings)
        if (widget.sessionType == VoiceSessionType.video ||
            widget.sessionType == VoiceSessionType.meeting)
          _buildControlButton(
            icon: widget.isScreenSharing
                ? Icons.stop_screen_share
                : Icons.screen_share,
            onTap: widget.onToggleScreenShare,
            isActive: widget.isScreenSharing,
            activeColor: AppColors.secondary,
            tooltip: widget.isScreenSharing ? 'Stop sharing' : 'Share screen',
          ),

        // Chat toggle
        _buildControlButton(
          icon: Icons.chat_bubble_outline,
          onTap: widget.onToggleChat,
          isActive: widget.isChatVisible,
          activeColor: AppColors.primaryLight,
          tooltip: 'Toggle chat',
        ),

        // End call
        _buildControlButton(
          icon: Icons.call_end,
          onTap: widget.onEndCall,
          isActive: false,
          isDestructive: true,
          tooltip: 'End call',
        ),
      ],
    );
  }

  Widget _buildSecondaryControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // More options
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            _showMoreOptions();
          },
          child: Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.more_horiz,
              color: Colors.white.withOpacity(0.8),
              size: 20.sp,
            ),
          ),
        ),
      ],
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkBackgroundSecondary
              : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(top: 12.h),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            SizedBox(height: 20.h),

            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Audio Settings'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Open audio settings
              },
            ),

            ListTile(
              leading: Icon(Icons.people),
              title: Text('Manage Participants'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Open participants management
              },
            ),

            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Call Info'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Show call info
              },
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMainControls(),

              SizedBox(height: 16.h),

              _buildSecondaryControls(),
            ],
          ),
        ),
      ),
    );
  }
}
