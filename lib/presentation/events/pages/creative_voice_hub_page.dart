import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../../shared/widgets/floating_header_card.dart';
import '../data/voice_hub_demo_data.dart';
import '../models/voice_models.dart';
import '../widgets/floating_action_cluster.dart';

class CreativeVoiceHubPage extends StatefulWidget {
  const CreativeVoiceHubPage({super.key});

  @override
  State<CreativeVoiceHubPage> createState() => _CreativeVoiceHubPageState();
}

class _CreativeVoiceHubPageState extends State<CreativeVoiceHubPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  List<VoiceSession> _activeSessions = [];
  List<CommunityData> _communities = [];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _loadData();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _loadData() {
    _activeSessions = VoiceHubDemoData.getActiveSessions();
    _communities = _generateCommunityData();
  }

  List<CommunityData> _generateCommunityData() {
    return [
      CommunityData(
        name: 'Crete Core Team',
        logo:
            'https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=100',
        activeCount: 3,
        activeSessions: _activeSessions.take(2).toList(),
      ),
      CommunityData(
        name: 'Design Guild',
        logo:
            'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=100',
        activeCount: 7,
        activeSessions: _activeSessions.skip(2).take(1).toList(),
      ),
      CommunityData(
        name: 'Dev Community',
        logo:
            'https://images.unsplash.com/photo-1605379399642-870262d3d051?w=100',
        activeCount: 0,
        activeSessions: [],
      ),
    ];
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
        child: Stack(
          children: [
            // Animated background with floating particles
            _buildAnimatedBackground(isDarkMode),

            // Main timeline content
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Creative floating header
                SliverToBoxAdapter(
                  child: FloatingHeaderCard(
                    title: 'Events Universe',
                    subtitle: 'Your timeline across the multiverse',
                    isDarkMode: isDarkMode,
                  ),
                ),

                // Timeline section with bubble events
                SliverToBoxAdapter(child: _buildTimelineBubbles(isDarkMode)),

                // Community galaxy section
                SliverToBoxAdapter(child: _buildCommunityGalaxy(isDarkMode)),

                // Recent activity constellation
                SliverToBoxAdapter(
                  child: _buildActivityConstellation(isDarkMode),
                ),

                // Bottom padding for FAB
                SliverToBoxAdapter(child: SizedBox(height: 120.h)),
              ],
            ),

            // Floating timeline indicator
            _buildTimelineIndicator(isDarkMode),

            // Floating action cluster
            FloatingActionCluster(
              onVoiceTap: _startVoiceCall,
              onVideoTap: _startVideoCall,
              onScreenShareTap: _startScreenShare,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground(bool isDarkMode) {
    return Positioned.fill(
      child: CustomPaint(
        painter: FloatingParticlesPainter(
          color: isDarkMode
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.primary.withValues(alpha: 0.05),
          animation: _fadeAnimation,
        ),
      ),
    );
  }

  Widget _buildTimelineBubbles(bool isDarkMode) {
    if (_activeSessions.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline header with glowing dot
          Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFED4245),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFED4245).withValues(alpha: 0.6),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Live Timeline',
                style: AppTypography.heading4.copyWith(
                  color: isDarkMode ? Colors.white : AppColors.gray900,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Bubble timeline
          SizedBox(
            height: 110.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              itemCount: _activeSessions.length,
              itemBuilder: (context, index) {
                final session = _activeSessions[index];
                return _buildEventBubble(session, index, isDarkMode);
              },
            ),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildEventBubble(VoiceSession session, int index, bool isDarkMode) {
    final colors = [
      const Color(0xFF00D4AA),
      const Color(0xFF5865F2),
      const Color(0xFFED4245),
      const Color(0xFFFAA61A),
      const Color(0xFF9146FF),
    ];
    final bubbleColor = colors[index % colors.length];

    return GestureDetector(
      onTap: () => _viewSessionDetails(session),
      child: Container(
        width: 80.w,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          children: [
            // Bubble container
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    bubbleColor.withValues(alpha: 0.8),
                    bubbleColor.withValues(alpha: 0.3),
                  ],
                ),
                border: Border.all(
                  color: bubbleColor.withValues(alpha: 0.6),
                  width: 2,
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: BubblePatternPainter(
                        color: Colors.white.withValues(alpha: 0.1),
                        sessionType: session.type,
                      ),
                    ),
                  ),
                  // Content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getSessionIcon(session.type),
                          color: Colors.white,
                          size: 24.sp,
                        ),
                        Text(
                          '${session.participants.length}',
                          style: AppTypography.geistSemiBold15.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            // Event info
            Text(
              session.title,
              style: AppTypography.geistMedium13.copyWith(
                color: isDarkMode ? Colors.white : AppColors.gray900,
                fontWeight: FontWeight.w600,
                height: .9,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,

              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityGalaxy(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Community Galaxy',
            style: AppTypography.heading4.copyWith(
              color: isDarkMode ? Colors.white : AppColors.gray900,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24.h),

          // Galaxy grid
          ..._communities.asMap().entries.map((entry) {
            final index = entry.key;
            final community = entry.value;
            return _buildCommunityPlanet(community, index, isDarkMode);
          }),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildCommunityPlanet(
    CommunityData community,
    int index,
    bool isDarkMode,
  ) {
    final isLeft = index % 2 == 0;

    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      child: Row(
        children: [
          if (!isLeft) const Expanded(child: SizedBox()),
          Container(
            width: 280.w,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28.r),
              gradient: LinearGradient(
                begin: isLeft ? Alignment.topLeft : Alignment.topRight,
                end: isLeft ? Alignment.bottomRight : Alignment.bottomLeft,
                colors: [
                  (isDarkMode ? Colors.white : Colors.black).withValues(
                    alpha: 0.1,
                  ),
                  (isDarkMode ? Colors.white : Colors.black).withValues(
                    alpha: 0.05,
                  ),
                ],
              ),
              border: Border.all(
                color: community.activeCount > 0
                    ? AppColors.primary.withValues(alpha: 0.4)
                    : (isDarkMode ? Colors.white : Colors.black).withValues(
                        alpha: 0.1,
                      ),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: community.activeCount > 0
                      ? AppColors.primary.withValues(alpha: 0.2)
                      : Colors.black.withValues(alpha: 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                // Planet avatar
                Stack(
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(community.logo),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: community.activeCount > 0
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    if (community.activeCount > 0)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF57F287),
                            border: Border.all(
                              color: isDarkMode
                                  ? AppColors.darkBackgroundPrimary
                                  : Colors.white,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${community.activeCount}',
                              style: AppTypography.geistMedium11.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        community.name,
                        style: AppTypography.geistSemiBold15.copyWith(
                          color: isDarkMode ? Colors.white : AppColors.gray900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        community.activeCount > 0
                            ? '${community.activeCount} active sessions'
                            : 'No active sessions',
                        style: AppTypography.geistRegular13.copyWith(
                          color: community.activeCount > 0
                              ? AppColors.primary
                              : (isDarkMode
                                    ? AppColors.darkTextSecondary
                                    : AppColors.gray500),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isLeft) const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  Widget _buildActivityConstellation(bool isDarkMode) {
    final recentSessions = VoiceHubDemoData.getRecentSessions()
        .take(3)
        .toList();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Constellation',
            style: AppTypography.heading4.copyWith(
              color: isDarkMode ? Colors.white : AppColors.gray900,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24.h),

          // Constellation stars
          ...recentSessions.asMap().entries.map((entry) {
            final index = entry.key;
            final session = entry.value;
            return _buildConstellationStar(session, index, isDarkMode);
          }),
        ],
      ),
    );
  }

  Widget _buildConstellationStar(
    VoiceSession session,
    int index,
    bool isDarkMode,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            (isDarkMode ? Colors.white : Colors.black).withValues(alpha: 0.05),
            (isDarkMode ? Colors.white : Colors.black).withValues(alpha: 0.02),
          ],
        ),
        border: Border.all(
          color: (isDarkMode ? Colors.white : Colors.black).withValues(
            alpha: 0.08,
          ),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getSessionTypeColor(session.type).withValues(alpha: 0.2),
            ),
            child: Icon(
              _getSessionIcon(session.type),
              color: _getSessionTypeColor(session.type),
              size: 20.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.title,
                  style: AppTypography.geistMedium15.copyWith(
                    color: isDarkMode ? Colors.white : AppColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  _getTimeAgo(session.endTime),
                  style: AppTypography.geistRegular13.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.gray500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatDuration(session.startTime, session.endTime),
            style: AppTypography.geistMedium13.copyWith(
              color: _getSessionTypeColor(session.type),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineIndicator(bool isDarkMode) {
    return Positioned(
      left: 4.w,
      top: 200.h,
      bottom: 200.h,
      child: Container(
        width: 2,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withValues(alpha: 0.0),
              AppColors.primary.withValues(alpha: 0.6),
              AppColors.primary.withValues(alpha: 0.0),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getSessionIcon(VoiceSessionType type) {
    switch (type) {
      case VoiceSessionType.voice:
        return PhosphorIcons.microphone(PhosphorIconsStyle.bold);
      case VoiceSessionType.video:
        return PhosphorIcons.videoCamera(PhosphorIconsStyle.bold);
      case VoiceSessionType.game:
        return PhosphorIcons.gameController(PhosphorIconsStyle.bold);
      case VoiceSessionType.studySession:
        return PhosphorIcons.book(PhosphorIconsStyle.bold);
      case VoiceSessionType.meeting:
        return PhosphorIcons.users(PhosphorIconsStyle.bold);
      case VoiceSessionType.event:
        return PhosphorIcons.calendar(PhosphorIconsStyle.bold);
    }
  }

  Color _getSessionTypeColor(VoiceSessionType type) {
    switch (type) {
      case VoiceSessionType.voice:
        return const Color(0xFF00D4AA);
      case VoiceSessionType.video:
        return const Color(0xFF5865F2);
      case VoiceSessionType.game:
        return const Color(0xFFED4245);
      case VoiceSessionType.studySession:
        return const Color(0xFFFAA61A);
      case VoiceSessionType.meeting:
        return const Color(0xFF9146FF);
      case VoiceSessionType.event:
        return AppColors.primary;
    }
  }

  String _getTimeAgo(DateTime? endTime) {
    if (endTime == null) return 'Recently';
    final diff = DateTime.now().difference(endTime);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return '${diff.inMinutes}m ago';
  }

  String _formatDuration(DateTime? startTime, DateTime? endTime) {
    if (startTime == null || endTime == null) return '0m';
    final duration = endTime.difference(startTime);
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    }
    return '${duration.inMinutes}m';
  }

  void _startVoiceCall() {
    // TODO: Implement voice call
  }

  void _startVideoCall() {
    // TODO: Implement video call
  }

  void _startScreenShare() {
    // TODO: Implement screen share
  }

  void _viewSessionDetails(VoiceSession session) {
    // TODO: Navigate to session details
  }
}

class CommunityData {
  final String name;
  final String logo;
  final int activeCount;
  final List<VoiceSession> activeSessions;

  CommunityData({
    required this.name,
    required this.logo,
    required this.activeCount,
    required this.activeSessions,
  });
}

class FloatingParticlesPainter extends CustomPainter {
  final Color color;
  final Animation<double> animation;

  FloatingParticlesPainter({required this.color, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final random = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < 20; i++) {
      final x = (size.width * ((random + i * 137) % 100) / 100);
      final y = (size.height * ((random + i * 73) % 100) / 100);
      final radius = 2 + (i % 3);

      canvas.drawCircle(Offset(x, y), radius * animation.value, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BubblePatternPainter extends CustomPainter {
  final Color color;
  final VoiceSessionType sessionType;

  BubblePatternPainter({required this.color, required this.sessionType});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw pattern based on session type
    switch (sessionType) {
      case VoiceSessionType.voice:
        _drawWavePattern(canvas, size, paint);
        break;
      case VoiceSessionType.video:
        _drawGridPattern(canvas, size, paint);
        break;
      case VoiceSessionType.game:
        _drawStarPattern(canvas, size, paint);
        break;
      case VoiceSessionType.studySession:
        _drawBookPattern(canvas, size, paint);
        break;
      case VoiceSessionType.meeting:
        _drawCirclePattern(canvas, size, paint);
        break;
      case VoiceSessionType.event:
        _drawDiamondPattern(canvas, size, paint);
        break;
    }
  }

  void _drawWavePattern(Canvas canvas, Size size, Paint paint) {
    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(size.width * 0.3 + i * 10, size.height * 0.5),
        2 + i * 0.5,
        paint,
      );
    }
  }

  void _drawGridPattern(Canvas canvas, Size size, Paint paint) {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        canvas.drawRect(
          Rect.fromLTWH(
            size.width * 0.2 + i * 8,
            size.height * 0.2 + j * 8,
            4,
            4,
          ),
          paint,
        );
      }
    }
  }

  void _drawStarPattern(Canvas canvas, Size size, Paint paint) {
    final center = Offset(size.width * 0.5, size.height * 0.5);
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * 3.14159) / 5;
      final x = center.dx + 15 * math.cos(angle * 0.5);
      final y = center.dy + 15 * math.sin(angle * 0.5);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawBookPattern(Canvas canvas, Size size, Paint paint) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.3, size.height * 0.3, 20, 15),
        const Radius.circular(2),
      ),
      paint,
    );
  }

  void _drawCirclePattern(Canvas canvas, Size size, Paint paint) {
    for (int i = 0; i < 4; i++) {
      final angle = (i * 2 * 3.14159) / 4;
      final x = size.width * 0.5 + 12 * math.cos(angle);
      final y = size.height * 0.5 + 12 * math.sin(angle);
      canvas.drawCircle(Offset(x, y), 3, paint);
    }
  }

  void _drawDiamondPattern(Canvas canvas, Size size, Paint paint) {
    final center = Offset(size.width * 0.5, size.height * 0.5);
    final path = Path()
      ..moveTo(center.dx, center.dy - 10)
      ..lineTo(center.dx + 8, center.dy)
      ..lineTo(center.dx, center.dy + 10)
      ..lineTo(center.dx - 8, center.dy)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
