import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/spacing.dart';
import 'dao_card.dart';

/// Modular DAO section widget for displaying lists of DAOs
class DaoSection extends StatelessWidget {
  const DaoSection({
    super.key,
    required this.sectionHeader,
    required this.itemCount,
    this.isHorizontal = true,
    this.itemBuilder,
    this.onSeeAll,
  });

  final Widget sectionHeader;
  final int itemCount;
  final bool isHorizontal;
  final Widget Function(BuildContext, int)? itemBuilder;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        sectionHeader,
        SizedBox(height: AppSpacing.md.h),
        if (isHorizontal)
          SizedBox(
            height: 206.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: itemCount,
              itemBuilder: itemBuilder ?? _defaultItemBuilder,
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: itemBuilder ?? _defaultItemBuilder,
          ),
      ],
    );
  }

  Widget _defaultItemBuilder(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.only(
        right: isHorizontal
            ? 0
            : AppSpacing.md.w, // Removed right padding for horizontal scrolling
        bottom: isHorizontal ? 0 : AppSpacing.md.h,
      ),
      child: const DaoCard(isMyDao: false),
    );
  }
}
