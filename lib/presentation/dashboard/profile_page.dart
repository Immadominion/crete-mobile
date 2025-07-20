import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';

/// Profile page - Settings, wallet, AI manager
/// Shows user profile, wallet management, settings, and AI manager
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
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
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            // Header with user info
            SliverPadding(
              padding: EdgeInsets.only(
                left: 15.8.w,
                right: 15.8.w,
                top: 33.h,
                bottom: 24.h,
              ),
              sliver: SliverToBoxAdapter(child: _buildHeader(isDarkMode)),
            ),

            // Profile Section
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 15.8.w),
              sliver: SliverToBoxAdapter(
                child: _buildProfileSection(isDarkMode),
              ),
            ),

            // Wallet Section
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 15.8.w),
              sliver: SliverToBoxAdapter(
                child: _buildWalletSection(isDarkMode),
              ),
            ),

            // Settings Section
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 15.8.w),
              sliver: SliverToBoxAdapter(
                child: _buildSettingsSection(isDarkMode),
              ),
            ),

            // AI Manager Section
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 15.8.w),
              sliver: SliverToBoxAdapter(
                child: _buildAiManagerSection(isDarkMode),
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
          'Profile',
          style: AppTypography.sfProSemiBold32.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            fontSize: 32.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Settings, wallet, AI manager',
          style: AppTypography.geistRegular14.copyWith(
            color: isDarkMode ? AppColors.darkTextSecondary : AppColors.gray600,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile',
          style: AppTypography.geistSemiBold15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(20.w),
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
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Icon(
                  Icons.person_outlined,
                  color: AppColors.white,
                  size: 30.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: AppTypography.geistSemiBold15.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextPrimary
                            : AppColors.gray900,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'john.doe@example.com',
                      style: AppTypography.geistRegular12.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.gray600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        'Premium Member',
                        style: AppTypography.geistMedium11.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _navigateToProfileEdit(),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.edit_outlined,
                    color: AppColors.primary,
                    size: 16.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildWalletSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Wallet',
          style: AppTypography.geistSemiBold15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 16.h),
        _buildWalletCard(
          'Connected Wallet',
          'Phantom',
          '7x8Y...9mN2',
          '1,234.56 SOL',
          true,
          isDarkMode,
        ),
        SizedBox(height: 12.h),
        _buildOptionCard(
          Icons.account_balance_wallet_outlined,
          'Manage Wallets',
          'Connect or disconnect wallets',
          isDarkMode,
          () => _navigateToWalletManagement(),
        ),
        SizedBox(height: 12.h),
        _buildOptionCard(
          Icons.history_outlined,
          'Transaction History',
          'View all your transactions',
          isDarkMode,
          () => _navigateToTransactionHistory(),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildWalletCard(
    String title,
    String walletType,
    String address,
    String balance,
    bool isConnected,
    bool isDarkMode,
  ) {
    return Container(
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
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              color: AppColors.white,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      walletType,
                      style: AppTypography.geistSemiBold15.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextPrimary
                            : AppColors.gray900,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: isConnected
                            ? AppColors.primary
                            : AppColors.gray400,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  address,
                  style: AppTypography.geistRegular11.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.gray600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                balance,
                style: AppTypography.geistSemiBold13.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.gray900,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                isConnected ? 'Connected' : 'Disconnected',
                style: AppTypography.geistRegular11.copyWith(
                  color: isConnected ? AppColors.primary : AppColors.gray400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: AppTypography.geistSemiBold15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 16.h),
        _buildOptionCard(
          Icons.dark_mode_outlined,
          'Theme',
          'Light, Dark, or System',
          isDarkMode,
          () => _navigateToThemeSettings(),
        ),
        SizedBox(height: 12.h),
        _buildOptionCard(
          Icons.notifications_outlined,
          'Notifications',
          'Manage notification preferences',
          isDarkMode,
          () => _navigateToNotificationSettings(),
        ),
        SizedBox(height: 12.h),
        _buildOptionCard(
          Icons.security_outlined,
          'Security',
          'Privacy and security settings',
          isDarkMode,
          () => _navigateToSecuritySettings(),
        ),
        SizedBox(height: 12.h),
        _buildOptionCard(
          Icons.language_outlined,
          'Language',
          'App language preferences',
          isDarkMode,
          () => _navigateToLanguageSettings(),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildAiManagerSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI Manager',
          style: AppTypography.geistSemiBold15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 16.h),
        _buildAiFeatureCard(
          'Smart Notifications',
          'AI-powered notification filtering',
          'Filter important messages automatically',
          true,
          isDarkMode,
        ),
        SizedBox(height: 12.h),
        _buildAiFeatureCard(
          'Channel Summaries',
          'Catch up on missed conversations',
          'Get AI-generated summaries of channels',
          false,
          isDarkMode,
        ),
        SizedBox(height: 12.h),
        _buildAiFeatureCard(
          'Voice Transcription',
          'Convert voice to text',
          'Automatic transcription of voice messages',
          true,
          isDarkMode,
        ),
        SizedBox(height: 12.h),
        _buildOptionCard(
          Icons.psychology_outlined,
          'AI Preferences',
          'Manage AI features and settings',
          isDarkMode,
          () => _navigateToAiSettings(),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildOptionCard(
    IconData icon,
    String title,
    String description,
    bool isDarkMode,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
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

  Widget _buildAiFeatureCard(
    String title,
    String subtitle,
    String description,
    bool isEnabled,
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
                colors: isEnabled
                    ? [AppColors.primary, AppColors.primaryDark]
                    : [AppColors.gray400, AppColors.gray500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Icon(
              Icons.psychology_outlined,
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
                  title,
                  style: AppTypography.geistSemiBold15.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: AppTypography.geistMedium11.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.gray600,
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
          Switch(
            value: isEnabled,
            onChanged: (value) {
              // Handle AI feature toggle
            },
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  void _navigateToProfileEdit() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => const ProfileEditPage()),
    );
  }

  void _navigateToWalletManagement() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const WalletManagementPage(),
      ),
    );
  }

  void _navigateToTransactionHistory() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const TransactionHistoryPage(),
      ),
    );
  }

  void _navigateToThemeSettings() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => const ThemeSettingsPage()),
    );
  }

  void _navigateToNotificationSettings() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const NotificationSettingsPage(),
      ),
    );
  }

  void _navigateToSecuritySettings() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const SecuritySettingsPage(),
      ),
    );
  }

  void _navigateToLanguageSettings() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const LanguageSettingsPage(),
      ),
    );
  }

  void _navigateToAiSettings() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => const AiSettingsPage()),
    );
  }
}

/// Profile Edit Page
class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final _nameController = TextEditingController(text: 'John Doe');
  final _emailController = TextEditingController(text: 'john.doe@example.com');
  final _bioController = TextEditingController(
    text: 'Passionate about DeFi and DAOs',
  );

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
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
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
          'Edit Profile',
          style: AppTypography.geistSemiBold15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: Text(
              'Save',
              style: AppTypography.geistSemiBold15.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              // Profile Picture Section
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100.w,
                      height: 100.h,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryDark],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: Icon(
                        Icons.person_outlined,
                        color: AppColors.white,
                        size: 50.sp,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: AppColors.white,
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),

              // Name Field
              _buildInputField(
                label: 'Display Name',
                controller: _nameController,
                isDarkMode: isDarkMode,
              ),
              SizedBox(height: 16.h),

              // Email Field
              _buildInputField(
                label: 'Email',
                controller: _emailController,
                isDarkMode: isDarkMode,
              ),
              SizedBox(height: 16.h),

              // Bio Field
              _buildInputField(
                label: 'Bio',
                controller: _bioController,
                isDarkMode: isDarkMode,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required bool isDarkMode,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.geistSemiBold13.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
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
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: AppTypography.geistRegular14.copyWith(
              color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  void _saveProfile() {
    // Handle profile save
    Navigator.of(context).pop();
  }
}

/// Placeholder pages for navigation
class WalletManagementPage extends StatelessWidget {
  const WalletManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPlaceholderPage(context, 'Wallet Management');
  }
}

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPlaceholderPage(context, 'Transaction History');
  }
}

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPlaceholderPage(context, 'Theme Settings');
  }
}

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPlaceholderPage(context, 'Notification Settings');
  }
}

class SecuritySettingsPage extends StatelessWidget {
  const SecuritySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPlaceholderPage(context, 'Security Settings');
  }
}

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPlaceholderPage(context, 'Language Settings');
  }
}

class AiSettingsPage extends StatelessWidget {
  const AiSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPlaceholderPage(context, 'AI Settings');
  }
}

Widget _buildPlaceholderPage(BuildContext context, String title) {
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
        title,
        style: AppTypography.geistSemiBold15.copyWith(
          color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
        ),
      ),
    ),
    body: Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
                  '$title will be available in a future update',
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
  );
}
