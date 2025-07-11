import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/theme/spacing.dart';
import '../../core/services/agentic_theme_service.dart';

class ThemeTestPage extends StatefulWidget {
  const ThemeTestPage({super.key});

  @override
  State<ThemeTestPage> createState() => _ThemeTestPageState();
}

class _ThemeTestPageState extends State<ThemeTestPage> {
  final _commandController = TextEditingController();

  @override
  void dispose() {
    _commandController.dispose();
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
        title: Text(
          'Theme Test',
          style: AppTypography.geistSemiBold15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.lg.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Command Input
            Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.md.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Agentic Theme Control',
                      style: AppTypography.geistSemiBold15.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextPrimary
                            : AppColors.gray900,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    Text(
                      'Try commands like: "Make it blue", "Use modern font", "Apply minimal theme"',
                      style: AppTypography.geistRegular12.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.gray600,
                      ),
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    TextField(
                      controller: _commandController,
                      decoration: InputDecoration(
                        hintText: 'Enter theme command...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            if (_commandController.text.isNotEmpty) {
                              AgenticThemeService.instance.processThemeCommand(
                                _commandController.text,
                              );
                              _commandController.clear();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: AppSpacing.lg.h),

            // Typography Examples
            Text(
              'Typography Examples',
              style: AppTypography.geistSemiBold15.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
              ),
            ),
            SizedBox(height: AppSpacing.md.h),

            _buildTypographyExample(
              context,
              'Geist SemiBold 15',
              AppTypography.geistSemiBold15,
            ),
            _buildTypographyExample(
              context,
              'Inter SemiBold 32',
              AppTypography.interSemiBold32,
            ),
            _buildTypographyExample(
              context,
              'DM Sans Regular 14',
              AppTypography.dmSansRegular14,
            ),
            _buildTypographyExample(
              context,
              'SF Pro SemiBold 32',
              AppTypography.sfProSemiBold32,
            ),

            SizedBox(height: AppSpacing.lg.h),

            // Color Examples
            Text(
              'Color Examples',
              style: AppTypography.geistSemiBold15.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
              ),
            ),
            SizedBox(height: AppSpacing.md.h),

            Wrap(
              spacing: AppSpacing.sm.w,
              runSpacing: AppSpacing.sm.h,
              children: [
                _buildColorChip('Primary', AppColors.primary),
                _buildColorChip('Secondary', AppColors.secondary),
                _buildColorChip('DAO Active', AppColors.daoActive),
                _buildColorChip('DAO Voting', AppColors.daoVotingInProgress),
                _buildColorChip('DAO Failed', AppColors.error),
                _buildColorChip('Secondary Button', AppColors.secondaryButton),
                _buildColorChip('Tertiary Button', AppColors.tertiaryButton),
              ],
            ),

            SizedBox(height: AppSpacing.lg.h),

            // Quick Actions
            Text(
              'Quick Actions',
              style: AppTypography.geistSemiBold15.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
              ),
            ),
            SizedBox(height: AppSpacing.md.h),

            Wrap(
              spacing: AppSpacing.sm.w,
              runSpacing: AppSpacing.sm.h,
              children: [
                _buildQuickActionButton('Blue Theme', () {
                  AgenticThemeService.instance.processThemeCommand(
                    'Make it blue',
                  );
                }),
                _buildQuickActionButton('Modern Font', () {
                  AgenticThemeService.instance.processThemeCommand(
                    'Use modern font',
                  );
                }),
                _buildQuickActionButton('Minimal Theme', () {
                  AgenticThemeService.instance.processThemeCommand(
                    'Apply minimal theme',
                  );
                }),
                _buildQuickActionButton('Reset', () {
                  AgenticThemeService.instance.processThemeCommand(
                    'Reset to default',
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypographyExample(
    BuildContext context,
    String name,
    TextStyle style,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: AppTypography.geistRegular11.copyWith(
              color: AppColors.gray500,
            ),
          ),
          Text('The quick brown fox jumps over the lazy dog', style: style),
        ],
      ),
    );
  }

  Widget _buildColorChip(String name, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm.w,
        vertical: AppSpacing.xs.h,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        name,
        style: AppTypography.geistMedium11.copyWith(
          color: _getContrastColor(color),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md.w,
          vertical: AppSpacing.sm.h,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Text(text, style: AppTypography.geistMedium11),
    );
  }

  Color _getContrastColor(Color color) {
    // Simple contrast color calculation
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
