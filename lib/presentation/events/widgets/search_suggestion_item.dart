import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

/// Smart search suggestion item types
enum SearchSuggestionType {
  recent,
  community,
  user,
  event,
  session,
  filter,
  action,
}

/// Enhanced search suggestion model
class SearchSuggestion {
  final String text;
  final String? subtitle;
  final SearchSuggestionType type;
  final IconData? icon;
  final Color? iconColor;
  final String? imageUrl;
  final VoidCallback? onTap;
  final bool isVerified;
  final int? memberCount;
  final DateTime? timestamp;
  final bool isLive;

  const SearchSuggestion({
    required this.text,
    this.subtitle,
    required this.type,
    this.icon,
    this.iconColor,
    this.imageUrl,
    this.onTap,
    this.isVerified = false,
    this.memberCount,
    this.timestamp,
    this.isLive = false,
  });

  /// Factory constructor for recent searches
  factory SearchSuggestion.recent(String text) {
    return SearchSuggestion(
      text: text,
      type: SearchSuggestionType.recent,
      icon: PhosphorIcons.clockCounterClockwise(),
    );
  }

  /// Factory constructor for communities
  factory SearchSuggestion.community({
    required String name,
    required int memberCount,
    bool isVerified = false,
    String? imageUrl,
    VoidCallback? onTap,
  }) {
    return SearchSuggestion(
      text: name,
      subtitle: '$memberCount members',
      type: SearchSuggestionType.community,
      icon: PhosphorIcons.users(),
      iconColor: AppColors.primary,
      imageUrl: imageUrl,
      isVerified: isVerified,
      memberCount: memberCount,
      onTap: onTap,
    );
  }

  /// Factory constructor for users
  factory SearchSuggestion.user({
    required String name,
    String? status,
    bool isVerified = false,
    String? imageUrl,
    VoidCallback? onTap,
  }) {
    return SearchSuggestion(
      text: name,
      subtitle: status,
      type: SearchSuggestionType.user,
      icon: PhosphorIcons.user(),
      iconColor: AppColors.success,
      imageUrl: imageUrl,
      isVerified: isVerified,
      onTap: onTap,
    );
  }

  /// Factory constructor for events
  factory SearchSuggestion.event({
    required String title,
    required DateTime timestamp,
    String? hostName,
    bool isLive = false,
    VoidCallback? onTap,
  }) {
    return SearchSuggestion(
      text: title,
      subtitle: hostName != null ? 'by $hostName' : null,
      type: SearchSuggestionType.event,
      icon: PhosphorIcons.calendar(),
      iconColor: isLive ? AppColors.error : AppColors.warning,
      timestamp: timestamp,
      isLive: isLive,
      onTap: onTap,
    );
  }

  /// Factory constructor for sessions
  factory SearchSuggestion.session({
    required String title,
    required int participantCount,
    bool isLive = false,
    VoidCallback? onTap,
  }) {
    return SearchSuggestion(
      text: title,
      subtitle: '$participantCount participants',
      type: SearchSuggestionType.session,
      icon: PhosphorIcons.waveform(),
      iconColor: isLive ? AppColors.error : AppColors.info,
      isLive: isLive,
      onTap: onTap,
    );
  }

  /// Factory constructor for filter suggestions
  factory SearchSuggestion.filter({
    required String text,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return SearchSuggestion(
      text: text,
      type: SearchSuggestionType.filter,
      icon: icon,
      iconColor: AppColors.secondary,
      onTap: onTap,
    );
  }

  /// Factory constructor for action suggestions
  factory SearchSuggestion.action({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SearchSuggestion(
      text: text,
      type: SearchSuggestionType.action,
      icon: icon,
      iconColor: AppColors.primary,
      onTap: onTap,
    );
  }
}

/// Enhanced search suggestion widget with animations and micro-interactions
class EnhancedSearchSuggestionItem extends StatefulWidget {
  final SearchSuggestion suggestion;
  final bool isDarkMode;
  final String searchQuery;
  final bool isFirst;
  final bool isLast;

  const EnhancedSearchSuggestionItem({
    super.key,
    required this.suggestion,
    required this.isDarkMode,
    required this.searchQuery,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  State<EnhancedSearchSuggestionItem> createState() =>
      _EnhancedSearchSuggestionItemState();
}

class _EnhancedSearchSuggestionItemState
    extends State<EnhancedSearchSuggestionItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _backgroundAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));

    _backgroundAnimation = ColorTween(
      begin: Colors.transparent,
      end: widget.isDarkMode
          ? AppColors.primary.withOpacity(0.08)
          : AppColors.primary.withOpacity(0.05),
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _hoverController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: widget.suggestion.onTap,
            child: MouseRegion(
              onEnter: (_) => _onHover(true),
              onExit: (_) => _onHover(false),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: _backgroundAnimation.value,
                  borderRadius: BorderRadius.vertical(
                    top: widget.isFirst ? Radius.circular(8.r) : Radius.zero,
                    bottom: widget.isLast ? Radius.circular(8.r) : Radius.zero,
                  ),
                ),
                child: Row(
                  children: [
                    _buildLeadingIcon(),
                    SizedBox(width: 12.w),
                    Expanded(child: _buildContent()),
                    _buildTrailingElements(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLeadingIcon() {
    if (widget.suggestion.imageUrl != null) {
      return Container(
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          image: DecorationImage(
            image: NetworkImage(widget.suggestion.imageUrl!),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        color: (widget.suggestion.iconColor ?? AppColors.primary).withOpacity(
          _isHovered ? 0.2 : 0.1,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(
        widget.suggestion.icon,
        size: 16.sp,
        color: widget.suggestion.iconColor ?? AppColors.primary,
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: RichText(
                text: _buildHighlightedText(
                  widget.suggestion.text,
                  widget.searchQuery,
                ),
              ),
            ),
            if (widget.suggestion.isVerified) ...[
              SizedBox(width: 4.w),
              Icon(
                PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                size: 14.sp,
                color: AppColors.primary,
              ),
            ],
            if (widget.suggestion.isLive) ...[
              SizedBox(width: 4.w),
              _buildLiveBadge(),
            ],
          ],
        ),
        if (widget.suggestion.subtitle != null) ...[
          SizedBox(height: 2.h),
          Text(
            widget.suggestion.subtitle!,
            style: AppTypography.geistRegular12.copyWith(
              color: widget.isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTrailingElements() {
    switch (widget.suggestion.type) {
      case SearchSuggestionType.recent:
        return Icon(
          PhosphorIcons.x(),
          size: 14.sp,
          color: widget.isDarkMode
              ? AppColors.darkTextSecondary
              : AppColors.gray400,
        );
      case SearchSuggestionType.community:
      case SearchSuggestionType.user:
        return Icon(
          PhosphorIcons.arrowUpRight(),
          size: 14.sp,
          color: widget.isDarkMode
              ? AppColors.darkTextSecondary
              : AppColors.gray400,
        );
      case SearchSuggestionType.event:
        if (widget.suggestion.timestamp != null) {
          return Text(
            _formatEventTime(widget.suggestion.timestamp!),
            style: AppTypography.geistRegular11.copyWith(
              color: widget.isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray500,
            ),
          );
        }
        break;
      default:
        break;
    }
    return const SizedBox.shrink();
  }

  Widget _buildLiveBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        'LIVE',
        style: AppTypography.geistMedium11.copyWith(
          color: AppColors.white,
          fontSize: 9.sp,
        ),
      ),
    );
  }

  TextSpan _buildHighlightedText(String text, String query) {
    if (query.isEmpty) {
      return TextSpan(
        text: text,
        style: AppTypography.geistMedium13.copyWith(
          color: widget.isDarkMode
              ? AppColors.darkTextPrimary
              : AppColors.gray900,
        ),
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final index = lowerText.indexOf(lowerQuery);

    if (index == -1) {
      return TextSpan(
        text: text,
        style: AppTypography.geistMedium13.copyWith(
          color: widget.isDarkMode
              ? AppColors.darkTextPrimary
              : AppColors.gray900,
        ),
      );
    }

    return TextSpan(
      children: [
        TextSpan(
          text: text.substring(0, index),
          style: AppTypography.geistMedium13.copyWith(
            color: widget.isDarkMode
                ? AppColors.darkTextPrimary
                : AppColors.gray900,
          ),
        ),
        TextSpan(
          text: text.substring(index, index + query.length),
          style: AppTypography.geistSemiBold13.copyWith(
            color: AppColors.primary,
            backgroundColor: AppColors.primary.withOpacity(0.15),
          ),
        ),
        TextSpan(
          text: text.substring(index + query.length),
          style: AppTypography.geistMedium13.copyWith(
            color: widget.isDarkMode
                ? AppColors.darkTextPrimary
                : AppColors.gray900,
          ),
        ),
      ],
    );
  }

  String _formatEventTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = timestamp.difference(now);

    if (difference.isNegative) {
      return 'Past';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inMinutes}m';
    }
  }
}
