import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

/// Model for stats items
class StatsItem {
  final String title;
  final String value;
  final String subtitle;
  final PhosphorIconData icon;
  final Color iconColor;

  const StatsItem({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });
}

/// Animated stats overview cards with counter animation
class StatsOverviewSection extends StatefulWidget {
  final List<StatsItem> stats;

  const StatsOverviewSection({super.key, required this.stats});

  @override
  State<StatsOverviewSection> createState() => _StatsOverviewSectionState();
}

class _StatsOverviewSectionState extends State<StatsOverviewSection>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _counterAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Disable animations for now to fix the interval issue
    final itemCount = widget.stats.length;
    if (itemCount == 0) return;

    // Create simple animations without intervals
    _scaleAnimations = List.generate(itemCount, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    });

    // Counter animations for the values
    _counterAnimations = List.generate(itemCount, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    });

    // Start animation and repeat it twice
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          _controller.forward();
        }
      });
    });
  }

  @override
  void didUpdateWidget(StatsOverviewSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stats.length != widget.stats.length) {
      _controller.dispose();
      _initializeAnimations();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          children: widget.stats.asMap().entries.map((entry) {
            final index = entry.key;
            final stat = entry.value;

            return Expanded(
              child: Transform.scale(
                scale: _scaleAnimations[index].value,
                child: Container(
                  margin: EdgeInsets.only(
                    right: index < widget.stats.length - 1 ? 12.w : 0,
                  ),
                  child: _buildStatCard(stat, index, isDarkMode),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildStatCard(StatsItem stat, int index, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.black : AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDarkMode ? AppColors.darkContainerBorder : AppColors.gray200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: stat.iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(stat.icon, color: stat.iconColor, size: 16.sp),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  stat.title,
                  style: AppTypography.geistMedium11.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.gray600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          AnimatedBuilder(
            animation: _counterAnimations[index],
            builder: (context, child) {
              // Extract numeric value for animation
              final numericValue = _extractNumericValue(stat.value);
              final animatedValue =
                  (numericValue * _counterAnimations[index].value).toInt();
              final displayValue = stat.value.replaceAll(
                RegExp(r'\d+'),
                animatedValue.toString(),
              );

              return Text(
                displayValue,
                style: AppTypography.geistSemiBold15.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.gray900,
                  fontSize: 18.sp,
                ),
              );
            },
          ),
          SizedBox(height: 4.h),
          Text(
            stat.subtitle,
            style: AppTypography.geistRegular11.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  int _extractNumericValue(String value) {
    final match = RegExp(r'\d+').firstMatch(value);
    return match != null ? int.tryParse(match.group(0)!) ?? 0 : 0;
  }
}
