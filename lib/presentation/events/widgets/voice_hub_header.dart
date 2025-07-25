import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

class VoiceHubHeader extends StatefulWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onFilterTap;

  const VoiceHubHeader({super.key, this.onSearchTap, this.onFilterTap});

  @override
  State<VoiceHubHeader> createState() => _VoiceHubHeaderState();
}

class _VoiceHubHeaderState extends State<VoiceHubHeader>
    with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late AnimationController _headerController;
  late Animation<double> _gradientAnimation;
  late Animation<double> _headerSlideAnimation;

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _gradientAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _gradientController, curve: Curves.easeInOut),
    );

    _headerSlideAnimation = Tween<double>(begin: -50.0, end: 0.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOutQuart),
    );

    _gradientController.repeat(reverse: true);
    _headerController.forward();
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: Listenable.merge([_gradientAnimation, _headerSlideAnimation]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _headerSlideAnimation.value),
          child: Container(
            padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDarkMode
                    ? [
                        AppColors.darkBackgroundPrimary,
                        AppColors.darkBackgroundSecondary.withOpacity(
                          0.8 + _gradientAnimation.value * 0.2,
                        ),
                      ]
                    : [
                        AppColors.backgroundPrimary,
                        AppColors.backgroundSecondary.withOpacity(
                          0.5 + _gradientAnimation.value * 0.3,
                        ),
                      ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_buildHeaderRow(isDarkMode)],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderRow(bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Events',
                style: AppTypography.heading2.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.gray900,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.h,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Online',
                    style: AppTypography.geistMedium13.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.gray600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        _buildActionButtons(isDarkMode),
      ],
    );
  }

  Widget _buildActionButtons(bool isDarkMode) {
    return Row(
      children: [
        _buildActionButton(
          icon: PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold),
          onTap: widget.onSearchTap,
          isDarkMode: isDarkMode,
        ),
        SizedBox(width: 8.w),
        _buildActionButton(
          icon: PhosphorIcons.funnelSimple(PhosphorIconsStyle.bold),
          onTap: widget.onFilterTap,
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback? onTap,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color:
              (isDarkMode
                      ? AppColors.darkBackgroundSecondary
                      : AppColors.backgroundSecondary)
                  .withOpacity(0.8),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isDarkMode
                ? AppColors.darkContainerBorder
                : AppColors.gray200,
          ),
        ),
        child: Icon(
          icon,
          size: 20.sp,
          color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray700,
        ),
      ),
    );
  }
}
