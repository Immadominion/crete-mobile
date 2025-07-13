import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/data/dao_ui_demo_data.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/dao_card.dart';
import '../../../core/widgets/dao_section.dart';
import '../../../core/widgets/section_header.dart';
import '../../daos/dao_page_service.dart';

/// Modular DAO sections for the home page
/// These are reusable components that can be used across different pages
class HomeDaoSections {
  /// Build My DAOs section for home page
  static Widget buildMyDaosSection(
    BuildContext context,
    DaoPageService daoService,
  ) {
    final myDaos = DaoUiDemoData.myDaos;

    return DaoSection(
      sectionHeader: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
        child: SectionHeader(
          title: 'My DAOs',
          iconPath: 'assets/icons/svgs/pinned.svg',
          onSeeAll: () => daoService.navigateToMyDaos(context),
        ),
      ),
      itemCount: myDaos.length,
      itemBuilder: (context, index) {
        final dao = myDaos[index];
        return Padding(
          padding: EdgeInsets.only(
            right: index == myDaos.length - 1 ? 0 : AppSpacing.sm.w,
          ),
          child: DaoCard(
            dao: dao,
            isMyDao: dao.isMyDao,
            onTap: () => daoService.navigateToDaoDetail(context, dao),
          ),
        );
      },
    );
  }

  /// Build Featured DAOs section for home page
  static Widget buildFeaturedDaosSection(
    BuildContext context,
    DaoPageService daoService,
  ) {
    final featuredDaos = DaoUiDemoData.featuredDaos.take(3).toList();

    return Column(
      children: [
        SizedBox(height: AppSpacing.lg.h),
        DaoSection(
          sectionHeader: SectionHeader(
            title: 'Featured DAOs',
            iconPath: 'assets/icons/svgs/pinned.svg',
            onSeeAll: () => daoService.navigateToFeaturedDaos(context),
          ),
          itemCount: featuredDaos.length,
          isHorizontal: false,
          itemBuilder: (context, index) {
            final dao = featuredDaos[index];
            return Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.md.h),
              child: DaoCard(
                dao: dao,
                isMyDao: dao.isMyDao,
                onTap: () => daoService.navigateToDaoDetail(context, dao),
              ),
            );
          },
        ),
      ],
    );
  }
}
