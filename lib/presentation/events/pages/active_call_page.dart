import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/colors.dart';
import '../models/voice_models.dart';
import '../widgets/call_chat_overlay.dart';
import '../widgets/call_controls.dart';
import '../widgets/call_header.dart';
import '../widgets/call_participants_grid.dart';

class ActiveCallPage extends StatefulWidget {
  const ActiveCallPage({
    super.key,
    required this.session,
    this.isMinimized = false,
  });
  final VoiceSession session;
  final bool isMinimized;

  @override
  State<ActiveCallPage> createState() => _ActiveCallPageState();
}

class _ActiveCallPageState extends State<ActiveCallPage>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  bool _isMuted = false;
  bool _isVideoOn = false;
  bool _isSpeakerOn = true;
  bool _isChatVisible = false;
  bool _isScreenSharing = false;

  @override
  void initState() {
    super.initState();

    // Setup animations
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_fadeController);

    // Start animations
    _slideController.forward();
    _fadeController.forward();

    // Set system UI style for full-screen experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
      ),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();

    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    super.dispose();
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    HapticFeedback.lightImpact();
  }

  void _toggleVideo() {
    setState(() {
      _isVideoOn = !_isVideoOn;
    });
    HapticFeedback.lightImpact();
  }

  void _toggleSpeaker() {
    setState(() {
      _isSpeakerOn = !_isSpeakerOn;
    });
    HapticFeedback.lightImpact();
  }

  void _toggleScreenShare() {
    setState(() {
      _isScreenSharing = !_isScreenSharing;
    });
    HapticFeedback.lightImpact();
  }

  void _toggleChat() {
    setState(() {
      _isChatVisible = !_isChatVisible;
    });
    HapticFeedback.lightImpact();
  }

  void _endCall() {
    HapticFeedback.mediumImpact();
    _slideController.reverse().then((_) {
      Navigator.of(context).pop();
    });
  }

  void _minimizeCall() {
    HapticFeedback.lightImpact();
    Navigator.of(context).pop();
    // TODO: Show mini player overlay
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackgroundPrimary
          : AppColors.black,
      body: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Stack(
            children: [
              // Background gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      (isDark
                              ? AppColors.darkBackgroundPrimary
                              : AppColors.black)
                          .withOpacity(0.95),
                      AppColors.primary.withOpacity(0.1),
                      (isDark
                          ? AppColors.darkBackgroundPrimary
                          : AppColors.black),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),

              // Main content
              SafeArea(
                child: Column(
                  children: [
                    // Header
                    CallHeader(
                      session: widget.session,
                      onMinimize: _minimizeCall,
                      onEndCall: _endCall,
                      isScreenSharing: _isScreenSharing,
                    ),

                    // Participants grid
                    Expanded(
                      child: CallParticipantsGrid(
                        participants: widget.session.participants,
                        isVideoCall:
                            widget.session.type == VoiceSessionType.video,
                        isScreenSharing: _isScreenSharing,
                        screenShareParticipant: _isScreenSharing
                            ? widget.session.participants.first
                            : null,
                      ),
                    ),

                    // Controls
                    CallControls(
                      isMuted: _isMuted,
                      isVideoOn: _isVideoOn,
                      isSpeakerOn: _isSpeakerOn,
                      isScreenSharing: _isScreenSharing,
                      isChatVisible: _isChatVisible,
                      onToggleMute: _toggleMute,
                      onToggleVideo: _toggleVideo,
                      onToggleSpeaker: _toggleSpeaker,
                      onToggleScreenShare: _toggleScreenShare,
                      onToggleChat: _toggleChat,
                      onEndCall: _endCall,
                      sessionType: widget.session.type,
                    ),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),

              // Chat overlay
              if (_isChatVisible)
                CallChatOverlay(
                  onClose: () => _toggleChat(),
                  sessionId: widget.session.id,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
