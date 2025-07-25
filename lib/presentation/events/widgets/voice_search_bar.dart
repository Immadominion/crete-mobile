import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

class VoiceSearchBar extends StatefulWidget {
  const VoiceSearchBar({
    super.key,
    required this.isActive,
    required this.searchQuery,
    required this.suggestions,
    required this.recentSearches,
    required this.onActivate,
    required this.onQueryChanged,
    required this.onClear,
    required this.onClose,
    required this.onSuggestionTap,
    required this.onClearRecentSearches,
  });

  final bool isActive;
  final String searchQuery;
  final List<String> suggestions;
  final List<String> recentSearches;
  final VoidCallback onActivate;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClear;
  final VoidCallback onClose;
  final ValueChanged<String> onSuggestionTap;
  final VoidCallback onClearRecentSearches;

  @override
  State<VoiceSearchBar> createState() => _VoiceSearchBarState();
}

class _VoiceSearchBarState extends State<VoiceSearchBar>
    with TickerProviderStateMixin {
  late AnimationController _expandController;
  late AnimationController _pulseController;
  late AnimationController _suggestionsController;
  late Animation<double> _expandAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _suggestionsAnimation;
  late Animation<Offset> _slideAnimation;

  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _suggestionsController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeOutQuart,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _suggestionsAnimation = CurvedAnimation(
      parent: _suggestionsController,
      curve: Curves.easeOutQuart,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(_suggestionsAnimation);

    _textController.text = widget.searchQuery;
    _textController.addListener(() {
      widget.onQueryChanged(_textController.text);
    });

    _pulseController.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(VoiceSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _expandController.forward();
        _focusNode.requestFocus();
        if (widget.searchQuery.isEmpty &&
            (widget.suggestions.isNotEmpty ||
                widget.recentSearches.isNotEmpty)) {
          _suggestionsController.forward();
        }
      } else {
        _expandController.reverse();
        _suggestionsController.reverse();
        _focusNode.unfocus();
      }
    }

    if (widget.searchQuery != oldWidget.searchQuery) {
      if (_textController.text != widget.searchQuery) {
        _textController.text = widget.searchQuery;
      }

      if (widget.searchQuery.isNotEmpty || widget.suggestions.isNotEmpty) {
        _suggestionsController.forward();
      } else {
        _suggestionsController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _expandController.dispose();
    _pulseController.dispose();
    _suggestionsController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [_buildSearchBar(isDarkMode), _buildSuggestions(isDarkMode)],
    );
  }

  Widget _buildSearchBar(bool isDarkMode) {
    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) {
        return Container(
          height: 48.h,
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppColors.darkBackgroundSecondary
                : AppColors.backgroundSecondary,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: widget.isActive
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : (isDarkMode
                        ? AppColors.darkContainerBorder
                        : AppColors.gray300),
              width: widget.isActive ? 1.5 : 1.0,
            ),
            boxShadow: widget.isActive
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      blurRadius: 8.r,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              SizedBox(width: 12.w),
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: widget.isActive ? _pulseAnimation.value : 1.0,
                    child: Icon(
                      PhosphorIcons.magnifyingGlass(),
                      size: 20.sp,
                      color: widget.isActive
                          ? AppColors.primary
                          : (isDarkMode
                                ? AppColors.darkTextSecondary
                                : AppColors.gray500),
                    ),
                  );
                },
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: widget.isActive
                    ? TextField(
                        controller: _textController,
                        focusNode: _focusNode,
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDarkMode
                              ? AppColors.darkTextPrimary
                              : AppColors.gray900,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search sessions, communities, people...',
                          hintStyle: AppTypography.bodyMedium.copyWith(
                            color: isDarkMode
                                ? AppColors.darkTextSecondary
                                : AppColors.gray500,
                          ),
                        ),
                        textInputAction: TextInputAction.search,
                      )
                    : GestureDetector(
                        onTap: widget.onActivate,
                        child: Container(
                          height: double.infinity,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Search sessions, communities, people...',
                            style: AppTypography.bodyMedium.copyWith(
                              color: isDarkMode
                                  ? AppColors.darkTextSecondary
                                  : AppColors.gray500,
                            ),
                          ),
                        ),
                      ),
              ),
              if (widget.isActive) ...[
                if (widget.searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: widget.onClear,
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      child: Icon(
                        PhosphorIcons.x(),
                        size: 16.sp,
                        color: isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.gray500,
                      ),
                    ),
                  ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: widget.onClose,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    child: Text(
                      'Cancel',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
              SizedBox(width: 12.w),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSuggestions(bool isDarkMode) {
    if (!widget.isActive) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _suggestionsAnimation,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _suggestionsAnimation,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.darkBackgroundSecondary
                    : AppColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isDarkMode
                      ? AppColors.darkContainerBorder
                      : AppColors.gray300,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isDarkMode ? Colors.black : Colors.grey).withValues(
                      alpha: 0.1,
                    ),
                    blurRadius: 8.r,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.searchQuery.isEmpty &&
                      widget.recentSearches.isNotEmpty) ...[
                    _buildSuggestionHeader('Recent Searches', isDarkMode),
                    ...widget.recentSearches.map(
                      (search) => _buildSuggestionItem(
                        search,
                        PhosphorIcons.clockCounterClockwise(),
                        isDarkMode,
                        isRecent: true,
                      ),
                    ),
                    if (widget.recentSearches.isNotEmpty)
                      _buildClearRecentButton(isDarkMode),
                  ],
                  if (widget.suggestions.isNotEmpty) ...[
                    _buildSuggestionHeader(
                      widget.searchQuery.isEmpty
                          ? 'Suggestions'
                          : 'Search Results',
                      isDarkMode,
                    ),
                    ...widget.suggestions.map(
                      (suggestion) => _buildSuggestionItem(
                        suggestion,
                        PhosphorIcons.magnifyingGlass(),
                        isDarkMode,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuggestionHeader(String title, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Text(
        title,
        style: AppTypography.labelMedium.copyWith(
          color: isDarkMode ? AppColors.darkTextSecondary : AppColors.gray500,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSuggestionItem(
    String text,
    IconData icon,
    bool isDarkMode, {
    bool isRecent = false,
  }) {
    return GestureDetector(
      onTap: () => widget.onSuggestionTap(text),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray500,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                text,
                style: AppTypography.bodyMedium.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.gray900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClearRecentButton(bool isDarkMode) {
    return GestureDetector(
      onTap: widget.onClearRecentSearches,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
        child: Text(
          'Clear Recent Searches',
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
