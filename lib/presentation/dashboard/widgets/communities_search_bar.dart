import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

class CommunitiesSearchBar extends StatefulWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onFilterTap;
  final bool enabled;

  const CommunitiesSearchBar({
    super.key,
    this.hintText,
    this.onChanged,
    this.onTap,
    this.onFilterTap,
    this.enabled = true,
  });

  @override
  State<CommunitiesSearchBar> createState() => _CommunitiesSearchBarState();
}

class _CommunitiesSearchBarState extends State<CommunitiesSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.9, curve: Curves.easeOut),
      ),
    );

    // Start animation after a delay
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Transform.translate(
        offset: Offset(0, _slideAnimation.value),
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.black : AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isDarkMode
                  ? AppColors.darkContainerBorder
                  : AppColors.gray200,
            ),
            boxShadow: [
              if (!isDarkMode)
                BoxShadow(
                  color: AppColors.gray900.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  enabled: widget.enabled,
                  onChanged: widget.onChanged,
                  onTap: widget.onTap,
                  style: AppTypography.geistRegular14.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText ?? 'Search communities...',
                    hintStyle: AppTypography.geistRegular14.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.gray500,
                    ),
                    border: InputBorder.none,
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: PhosphorIcon(
                        PhosphorIcons.magnifyingGlass(
                          PhosphorIconsStyle.regular,
                        ),
                        size: 20.sp,
                        color: isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.gray500,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                  ),
                ),
              ),
              if (widget.onFilterTap != null)
                GestureDetector(
                  onTap: widget.onFilterTap,
                  child: Container(
                    margin: EdgeInsets.only(right: 8.w),
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: PhosphorIcon(
                      PhosphorIcons.funnelSimple(PhosphorIconsStyle.regular),
                      size: 16.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
