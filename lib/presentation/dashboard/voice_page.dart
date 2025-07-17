import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';

/// Voice page - Active voice channels, calls
/// Shows active voice channels, recent calls, and voice settings
class VoicePage extends StatefulWidget {
  const VoicePage({super.key});

  @override
  State<VoicePage> createState() => _VoicePageState();
}

class _VoicePageState extends State<VoicePage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
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
        child: CustomScrollView(
          slivers: [
            // Header
            SliverPadding(
              padding: EdgeInsets.only(
                left: 15.8.w,
                right: 15.8.w,
                top: 33.h,
                bottom: 24.h,
              ),
              sliver: SliverToBoxAdapter(child: _buildHeader(isDarkMode)),
            ),

            // Active Voice Channels Section
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 15.8.w),
              sliver: SliverToBoxAdapter(
                child: _buildActiveVoiceChannels(isDarkMode),
              ),
            ),

            // Recent Calls Section
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 15.8.w),
              sliver: SliverToBoxAdapter(child: _buildRecentCalls(isDarkMode)),
            ),

            // Voice Settings Section
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 15.8.w),
              sliver: SliverToBoxAdapter(
                child: _buildVoiceSettings(isDarkMode),
              ),
            ),

            // Bottom padding
            SliverPadding(
              padding: EdgeInsets.only(bottom: 100.h),
              sliver: const SliverToBoxAdapter(child: SizedBox()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Voice',
          style: AppTypography.sfProSemiBold32.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            fontSize: 32.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Active voice channels, calls',
          style: AppTypography.geistRegular14.copyWith(
            color: isDarkMode ? AppColors.darkTextSecondary : AppColors.gray600,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveVoiceChannels(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Active Voice Channels',
              style: AppTypography.geistSemiBold15.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
                fontSize: 18.sp,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'See All',
                style: AppTypography.geistMedium13.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildVoiceChannelCard(
          'General Voice',
          'CryptoDAO',
          3,
          true,
          isDarkMode,
        ),
        SizedBox(height: 12.h),
        _buildVoiceChannelCard(
          'Governance Meeting',
          'DeFi Collective',
          7,
          false,
          isDarkMode,
        ),
        SizedBox(height: 12.h),
        _buildVoiceChannelCard(
          'Community Hangout',
          'MetaDAO',
          12,
          false,
          isDarkMode,
        ),
        SizedBox(height: 12.h),
        _buildVoiceChannelCard(
          'Dev Team Standup',
          'BuildDAO',
          5,
          false,
          isDarkMode,
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildVoiceChannelCard(
    String channelName,
    String community,
    int memberCount,
    bool isConnected,
    bool isDarkMode,
  ) {
    return GestureDetector(
      onTap: () => _navigateToVoiceChannel(channelName, community, memberCount),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.black : AppColors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isConnected
                ? AppColors.primary
                : (isDarkMode
                      ? AppColors.darkContainerBorder
                      : AppColors.gray200),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 37.65.w,
              height: 37.65.h,
              decoration: BoxDecoration(
                color: isConnected
                    ? AppColors.primary
                    : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Icon(
                Icons.volume_up_outlined,
                color: isConnected ? AppColors.white : AppColors.primary,
                size: 18.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    channelName,
                    style: AppTypography.geistSemiBold15.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextPrimary
                          : AppColors.gray900,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '$community • $memberCount members',
                    style: AppTypography.geistRegular11.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextHeading
                          : AppColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isConnected ? AppColors.error : AppColors.primary,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                isConnected ? 'Leave' : 'Join',
                style: AppTypography.geistMedium11.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentCalls(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Calls',
          style: AppTypography.geistSemiBold15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 16.h),
        _buildCallCard(
          'Alice Johnson',
          'Voice call',
          '2 min ago',
          '5:23',
          false,
          isDarkMode,
        ),
        SizedBox(height: 12.h),
        _buildCallCard(
          'DeFi Strategy Group',
          'Group call',
          '1 hour ago',
          '45:12',
          true,
          isDarkMode,
        ),
        SizedBox(height: 12.h),
        _buildCallCard(
          'Bob Smith',
          'Voice call',
          '3 hours ago',
          '12:45',
          false,
          isDarkMode,
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildCallCard(
    String name,
    String type,
    String time,
    String duration,
    bool isGroup,
    bool isDarkMode,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.black : AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDarkMode ? AppColors.darkContainerBorder : AppColors.gray200,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 37.65.w,
            height: 37.65.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isGroup
                    ? [AppColors.secondary, AppColors.secondaryDark]
                    : [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Icon(
              isGroup ? Icons.group_outlined : Icons.person_outlined,
              color: AppColors.white,
              size: 18.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.geistSemiBold15.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '$type • $time',
                  style: AppTypography.geistRegular11.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextHeading
                        : AppColors.gray500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                duration,
                style: AppTypography.geistMedium11.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.gray600,
                ),
              ),
              SizedBox(height: 4.h),
              Icon(Icons.call_outlined, color: AppColors.primary, size: 16.sp),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceSettings(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Voice Settings',
          style: AppTypography.geistSemiBold15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 16.h),
        _buildSettingCard(
          Icons.mic_outlined,
          'Microphone',
          'Configure your microphone settings',
          isDarkMode,
        ),
        SizedBox(height: 12.h),
        _buildSettingCard(
          Icons.volume_up_outlined,
          'Audio Quality',
          'Adjust audio quality and noise suppression',
          isDarkMode,
        ),
        SizedBox(height: 12.h),
        _buildSettingCard(
          Icons.push_pin_outlined,
          'Push to Talk',
          'Enable push-to-talk mode',
          isDarkMode,
        ),
        SizedBox(height: 12.h),
        _buildSettingCard(
          Icons.videocam_outlined,
          'Video Settings',
          'Camera and video call preferences',
          isDarkMode,
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildSettingCard(
    IconData icon,
    String title,
    String description,
    bool isDarkMode,
  ) {
    return GestureDetector(
      onTap: () => _navigateToVoiceSettings(title),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.black : AppColors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isDarkMode
                ? AppColors.darkContainerBorder
                : AppColors.gray200,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 37.65.w,
              height: 37.65.h,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Icon(icon, color: AppColors.primary, size: 18.sp),
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
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: AppTypography.geistRegular11.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextHeading
                          : AppColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: isDarkMode ? AppColors.darkTextHeading : AppColors.gray400,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToVoiceChannel(
    String channelName,
    String community,
    int memberCount,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => VoiceChannelDetailPage(
          channelName: channelName,
          community: community,
          memberCount: memberCount,
        ),
      ),
    );
  }

  void _navigateToVoiceSettings(String settingType) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => VoiceSettingsPage(settingType: settingType),
      ),
    );
  }
}

/// Voice Channel Detail Page
class VoiceChannelDetailPage extends StatefulWidget {
  final String channelName;
  final String community;
  final int memberCount;

  const VoiceChannelDetailPage({
    super.key,
    required this.channelName,
    required this.community,
    required this.memberCount,
  });

  @override
  State<VoiceChannelDetailPage> createState() => _VoiceChannelDetailPageState();
}

class _VoiceChannelDetailPageState extends State<VoiceChannelDetailPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isMuted = false;
  bool _isDeafened = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackgroundPrimary
          : AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? AppColors.darkBackgroundPrimary
            : AppColors.backgroundPrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.channelName,
              style: AppTypography.geistSemiBold15.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
              ),
            ),
            Text(
              '${widget.community} • ${widget.memberCount} members',
              style: AppTypography.geistRegular11.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray600,
              ),
            ),
          ],
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.all(16.w),
                    sliver: SliverToBoxAdapter(
                      child: _buildMembersList(isDarkMode),
                    ),
                  ),
                ],
              ),
            ),
            _buildVoiceControls(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildMembersList(bool isDarkMode) {
    final members = [
      {'name': 'Alice Johnson', 'isSpeaking': true, 'isMuted': false},
      {'name': 'Bob Smith', 'isSpeaking': false, 'isMuted': true},
      {'name': 'Charlie Brown', 'isSpeaking': false, 'isMuted': false},
      {'name': 'You', 'isSpeaking': false, 'isMuted': _isMuted},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Members in Voice',
          style: AppTypography.geistSemiBold15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 16.h),
        ...members.map(
          (member) => _buildMemberCard(
            member['name'] as String,
            member['isSpeaking'] as bool,
            member['isMuted'] as bool,
            isDarkMode,
          ),
        ),
      ],
    );
  }

  Widget _buildMemberCard(
    String name,
    bool isSpeaking,
    bool isMuted,
    bool isDarkMode,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.black : AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isSpeaking
              ? AppColors.primary
              : (isDarkMode
                    ? AppColors.darkContainerBorder
                    : AppColors.gray200),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 37.65.w,
            height: 37.65.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isSpeaking
                    ? [AppColors.primary, AppColors.primaryDark]
                    : [AppColors.gray400, AppColors.gray500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Icon(
              Icons.person_outlined,
              color: AppColors.white,
              size: 18.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              name,
              style: AppTypography.geistSemiBold15.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
              ),
            ),
          ),
          if (isSpeaking) ...[
            Icon(
              Icons.graphic_eq_outlined,
              color: AppColors.primary,
              size: 16.sp,
            ),
            SizedBox(width: 8.w),
          ],
          Icon(
            isMuted ? Icons.mic_off_outlined : Icons.mic_outlined,
            color: isMuted ? AppColors.error : AppColors.primary,
            size: 16.sp,
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceControls(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.black : AppColors.white,
        border: Border(
          top: BorderSide(
            color: isDarkMode
                ? AppColors.darkContainerBorder
                : AppColors.gray200,
            width: 1.w,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildVoiceControlButton(
            icon: _isMuted ? Icons.mic_off_outlined : Icons.mic_outlined,
            label: 'Mute',
            isActive: _isMuted,
            onTap: () => setState(() => _isMuted = !_isMuted),
            isDarkMode: isDarkMode,
          ),
          _buildVoiceControlButton(
            icon: _isDeafened
                ? Icons.volume_off_outlined
                : Icons.volume_up_outlined,
            label: 'Deafen',
            isActive: _isDeafened,
            onTap: () => setState(() => _isDeafened = !_isDeafened),
            isDarkMode: isDarkMode,
          ),
          _buildVoiceControlButton(
            icon: Icons.screen_share_outlined,
            label: 'Share',
            isActive: false,
            onTap: () {},
            isDarkMode: isDarkMode,
          ),
          _buildVoiceControlButton(
            icon: Icons.call_end_outlined,
            label: 'Leave',
            isActive: false,
            onTap: () => Navigator.of(context).pop(),
            isDarkMode: isDarkMode,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceControlButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    required bool isDarkMode,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: isActive
                  ? (isDestructive ? AppColors.error : AppColors.primary)
                  : (isDarkMode
                        ? AppColors.darkContainerBorder
                        : AppColors.gray200),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Icon(
              icon,
              color: isActive
                  ? AppColors.white
                  : (isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray600),
              size: 20.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppTypography.geistRegular11.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Voice Settings Page
class VoiceSettingsPage extends StatefulWidget {
  final String settingType;

  const VoiceSettingsPage({super.key, required this.settingType});

  @override
  State<VoiceSettingsPage> createState() => _VoiceSettingsPageState();
}

class _VoiceSettingsPageState extends State<VoiceSettingsPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackgroundPrimary
          : AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? AppColors.darkBackgroundPrimary
            : AppColors.backgroundPrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.settingType,
          style: AppTypography.geistSemiBold15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Text(
                'Voice settings configuration for ${widget.settingType}',
                style: AppTypography.geistRegular14.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.gray600,
                ),
              ),
              SizedBox(height: 24.h),
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.black : AppColors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: isDarkMode
                        ? AppColors.darkContainerBorder
                        : AppColors.gray200,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.settings_outlined,
                      size: 48.sp,
                      color: AppColors.primary,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Coming Soon',
                      style: AppTypography.geistSemiBold15.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextPrimary
                            : AppColors.gray900,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Voice settings will be available in a future update',
                      style: AppTypography.geistRegular12.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.gray600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
