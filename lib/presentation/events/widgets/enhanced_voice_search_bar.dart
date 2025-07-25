import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../models/voice_models.dart';
import '../models/voice_event_models.dart';
import 'search_suggestion_item.dart';
import '../utils/smart_search_suggestions.dart';

/// Enhanced voice search bar with smart suggestions and micro-interactions
class EnhancedVoiceSearchBar extends StatefulWidget {
  final bool isActive;
  final String searchQuery;
  final List<VoiceSession> sessions;
  final List<VoiceEvent> events;
  final List<String> recentSearches;
  final VoidCallback onActivate;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClear;
  final VoidCallback onClose;
  final ValueChanged<String> onSuggestionTap;
  final VoidCallback onClearRecentSearches;
  final VoidCallback? onFilterTap;
  final VoidCallback? onCreateEventTap;

  const EnhancedVoiceSearchBar({
    super.key,
    required this.isActive,
    required this.searchQuery,
    required this.sessions,
    required this.events,
    required this.recentSearches,
    required this.onActivate,
    required this.onQueryChanged,
    required this.onClear,
    required this.onClose,
    required this.onSuggestionTap,
    required this.onClearRecentSearches,
    this.onFilterTap,
    this.onCreateEventTap,
  });

  @override
  State<EnhancedVoiceSearchBar> createState() => _EnhancedVoiceSearchBarState();
}

class _EnhancedVoiceSearchBarState extends State<EnhancedVoiceSearchBar>
    with TickerProviderStateMixin {
  late AnimationController _expandController;
  late AnimationController _pulseController;
  late AnimationController _suggestionsController;
  late AnimationController _shimmerController;

  late Animation<double> _expandAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _suggestionsAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _shimmerAnimation;

  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  List<SearchSuggestion> _suggestions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupTextController();
    _generateSuggestions();
  }

  void _initializeAnimations() {
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

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeOutQuart,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _suggestionsAnimation = CurvedAnimation(
      parent: _suggestionsController,
      curve: Curves.easeOutQuart,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(_suggestionsAnimation);

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
  }

  void _setupTextController() {
    _textController.text = widget.searchQuery;
    _textController.addListener(() {
      widget.onQueryChanged(_textController.text);
      _generateSuggestions();
    });
  }

  void _generateSuggestions() {
    setState(() => _isLoading = true);

    // Simulate async search with slight delay for better UX
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        final suggestions = SmartSearchSuggestions.generateSuggestions(
          query: _textController.text,
          sessions: widget.sessions,
          events: widget.events,
          recentSearches: widget.recentSearches,
        );

        setState(() {
          _suggestions = suggestions;
          _isLoading = false;
        });
      }
    });
  }

  @override
  void didUpdateWidget(EnhancedVoiceSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _expandController.forward();
        _focusNode.requestFocus();
        _showSuggestions();
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
      _generateSuggestions();
    }

    // Regenerate suggestions if data changes
    if (widget.sessions != oldWidget.sessions ||
        widget.events != oldWidget.events) {
      _generateSuggestions();
    }
  }

  void _showSuggestions() {
    if (_suggestions.isNotEmpty || widget.recentSearches.isNotEmpty) {
      _suggestionsController.forward();
    }
  }

  @override
  void dispose() {
    _expandController.dispose();
    _pulseController.dispose();
    _suggestionsController.dispose();
    _shimmerController.dispose();
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
                  ? AppColors.primary.withOpacity(0.4)
                  : (isDarkMode
                        ? AppColors.darkContainerBorder
                        : AppColors.gray300),
              width: widget.isActive ? 1.5 : 1.0,
            ),
            boxShadow: widget.isActive
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.15),
                      blurRadius: 12.r,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              SizedBox(width: 12.w),
              _buildSearchIcon(isDarkMode),
              SizedBox(width: 12.w),
              Expanded(child: _buildSearchInput(isDarkMode)),
              _buildTrailingActions(isDarkMode),
              SizedBox(width: 12.w),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchIcon(bool isDarkMode) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isActive ? _pulseAnimation.value : 1.0,
          child: Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: widget.isActive
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(
              PhosphorIcons.magnifyingGlass(),
              size: 18.sp,
              color: widget.isActive
                  ? AppColors.primary
                  : (isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.gray500),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchInput(bool isDarkMode) {
    if (!widget.isActive) {
      return GestureDetector(
        onTap: widget.onActivate,
        child: Container(
          height: double.infinity,
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Search events, sessions, communities...',
                  style: AppTypography.geistRegular14.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.gray500,
                  ),
                ),
              ),
              if (_isLoading) _buildLoadingShimmer(isDarkMode),
            ],
          ),
        ),
      );
    }

    return TextField(
      controller: _textController,
      focusNode: _focusNode,
      style: AppTypography.geistRegular14.copyWith(
        color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Search events, sessions, communities...',
        hintStyle: AppTypography.geistRegular14.copyWith(
          color: isDarkMode ? AppColors.darkTextSecondary : AppColors.gray500,
        ),
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: (value) {
        if (value.isNotEmpty) {
          widget.onSuggestionTap(value);
        }
      },
    );
  }

  Widget _buildTrailingActions(bool isDarkMode) {
    if (!widget.isActive) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.onFilterTap != null)
            GestureDetector(
              onTap: widget.onFilterTap,
              child: Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(
                  PhosphorIcons.funnelSimple(),
                  size: 16.sp,
                  color: isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.gray500,
                ),
              ),
            ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isLoading) _buildLoadingShimmer(isDarkMode),
        if (widget.searchQuery.isNotEmpty && !_isLoading)
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
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            child: Text(
              'Cancel',
              style: AppTypography.geistMedium13.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingShimmer(bool isDarkMode) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          width: 16.w,
          height: 16.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.transparent,
                AppColors.primary.withOpacity(0.3),
                Colors.transparent,
              ],
              stops: [0.0, _shimmerAnimation.value * 0.5 + 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuggestions(bool isDarkMode) {
    if (!widget.isActive || (_suggestions.isEmpty && !_isLoading)) {
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
              constraints: BoxConstraints(maxHeight: 300.h),
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
                    color: (isDarkMode ? Colors.black : Colors.grey)
                        .withOpacity(0.15),
                    blurRadius: 12.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _isLoading
                  ? _buildLoadingSuggestions(isDarkMode)
                  : _buildSuggestionsList(isDarkMode),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingSuggestions(bool isDarkMode) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.darkContainerBorder
                      : AppColors.gray200,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 12.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppColors.darkContainerBorder
                            : AppColors.gray200,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      height: 10.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppColors.darkContainerBorder
                            : AppColors.gray200,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSuggestionsList(bool isDarkMode) {
    if (_suggestions.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(24.w),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                PhosphorIcons.magnifyingGlass(),
                size: 32.sp,
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray400,
              ),
              SizedBox(height: 8.h),
              Text(
                'No results found',
                style: AppTypography.geistRegular14.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.gray500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: _suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = _suggestions[index];
        return EnhancedSearchSuggestionItem(
          suggestion: suggestion,
          isDarkMode: isDarkMode,
          searchQuery: widget.searchQuery,
          isFirst: index == 0,
          isLast: index == _suggestions.length - 1,
        );
      },
    );
  }
}
