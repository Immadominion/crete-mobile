import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/typography.dart';
import '../../../../domain/models/chat/chat_message.dart';

/// Displays NFT, Token, Role, or Tag messages with enhanced UI
class AssetMessageCard extends StatelessWidget {
  const AssetMessageCard({
    super.key,
    required this.asset,
    required this.type,
    required this.isClaimable,
    required this.claimableUntil,
    required this.isDarkMode,
    this.onClaim,
  });

  final SentAsset asset;
  final MessageType type;
  final bool isClaimable;
  final DateTime? claimableUntil;
  final bool isDarkMode;
  final VoidCallback? onClaim;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 300.w),
      margin: EdgeInsets.symmetric(vertical: 4.h),
      child: _buildCard(),
    );
  }

  Widget _buildCard() {
    switch (type) {
      case MessageType.nft:
        return _buildNftCard();
      case MessageType.token:
        return _buildTokenCard();
      case MessageType.role:
        return _buildRoleCard();
      case MessageType.tag:
        return _buildTagCard();
      default:
        return const SizedBox();
    }
  }

  Widget _buildNftCard() {
    return Container(
      height: 140.h, // Compact height
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Row(
          children: [
            // Compact NFT Preview (left side)
            Container(
              width: 120.w,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    asset.imageUrl ??
                        'https://via.placeholder.com/300x300?text=NFT',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Gradient overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Verified badge
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                        color: Colors.blue,
                        size: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // NFT Details (right side)
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple.shade900, Colors.indigo.shade900],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Collection badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            PhosphorIcons.sparkle(PhosphorIconsStyle.fill),
                            color: Colors.purple.shade300,
                            size: 10.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            (asset.collection?.toUpperCase() ?? 'COLLECTION')
                                .substring(0, 8),
                            style: AppTypography.geistSemiBold15.copyWith(
                              color: Colors.white,
                              fontSize: 8.sp,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // NFT Name
                    Text(
                      asset.name.length > 15
                          ? '${asset.name.substring(0, 15)}...'
                          : asset.name,
                      style: AppTypography.geistSemiBold15.copyWith(
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // NFT ID and Network row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              PhosphorIcons.hash(PhosphorIconsStyle.bold),
                              color: Colors.white.withOpacity(0.6),
                              size: 12.sp,
                            ),
                            Text(
                              asset.id.length > 6
                                  ? '${asset.id.substring(0, 6)}...'
                                  : asset.id,
                              style: AppTypography.geistRegular13.copyWith(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                        // Compact network badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            'Solana', // Always Solana
                            style: AppTypography.geistRegular13.copyWith(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 8.sp,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Claim button if claimable
                    if (isClaimable)
                      SizedBox(
                        width: double.infinity,
                        height: 28.h,
                        child: ElevatedButton(
                          onPressed: onClaim,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Claim',
                            style: AppTypography.geistSemiBold15.copyWith(
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTokenCard() {
    // Determine if it's a bonk token for special styling
    final isBonkToken = asset.name.toLowerCase().contains('bonk');
    final tokenColor = isBonkToken ? Colors.amber : Colors.blue;
    final gradientColors = isBonkToken
        ? [Colors.amber.shade700, Colors.orange.shade600]
        : [Colors.blue.shade700, Colors.cyan.shade600];

    return Container(
      height: 120.h, // Optimized compact height
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: tokenColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle decorative coin (smaller)
          Positioned(
            right: -10,
            bottom: -5,
            child: Icon(
              PhosphorIcons.coin(PhosphorIconsStyle.fill),
              color: Colors.white.withOpacity(0.1),
              size: 45.sp, // Slightly smaller decorative icon
            ),
          ),

          // Content - Highly optimized layout to prevent overflow
          Padding(
            padding: EdgeInsets.all(12.w), // Optimized padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Badge and claim button with proper constraints
                Row(
                  children: [
                    // Token transfer badge (compact)
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          'TOKEN',
                          style: AppTypography.geistSemiBold15.copyWith(
                            color: Colors.white,
                            fontSize: 8.sp,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Compact claim button with fixed constraints
                    if (isClaimable)
                      Container(
                        height: 20.h,
                        constraints: BoxConstraints(maxWidth: 60.w),
                        child: ElevatedButton(
                          onPressed: onClaim,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            elevation: 0,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Claim',
                            style: AppTypography.geistSemiBold15.copyWith(
                              fontSize: 8.sp,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 8.h),

                // Middle section: Token icon, amount and name with flex layout
                Expanded(
                  child: Row(
                    children: [
                      // Token icon
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isBonkToken
                              ? PhosphorIcons.dog(PhosphorIconsStyle.fill)
                              : PhosphorIcons.currencyCircleDollar(
                                  PhosphorIconsStyle.fill,
                                ),
                          color: Colors.white,
                          size: 14.sp, // Optimized icon size
                        ),
                      ),
                      SizedBox(width: 8.w),

                      // Token amount and name with overflow protection
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${asset.value}',
                              style: AppTypography.geistSemiBold15.copyWith(
                                color: Colors.white,
                                fontSize: 20.sp, // Optimized size
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              asset.name.toUpperCase(),
                              style: AppTypography.geistSemiBold15.copyWith(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 10.sp, // Optimized size
                                letterSpacing: 0.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom row: Network badge only
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        PhosphorIcons.globe(PhosphorIconsStyle.bold),
                        color: Colors.white.withOpacity(0.8),
                        size: 10.sp,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Solana', // Always Solana
                        style: AppTypography.geistMedium13.copyWith(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 8.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard() {
    final roleColor = asset.color ?? Colors.indigo;

    return Container(
      height: 100.h, // Compact height
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [roleColor.withOpacity(0.7), roleColor.withOpacity(0.9)],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: roleColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle decorative element
          Positioned(
            top: -15,
            right: -10,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white.withOpacity(0.1),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Role icon
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    PhosphorIcons.crown(PhosphorIconsStyle.fill),
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),

                SizedBox(width: 12.w),

                // Role info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Role badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'ROLE',
                          style: AppTypography.geistSemiBold15.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 9.sp,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),

                      SizedBox(height: 6.h),

                      // Role name
                      Text(
                        asset.name,
                        style: AppTypography.geistSemiBold15.copyWith(
                          color: Colors.white,
                          fontSize: 18.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Benefits count or description
                      if (asset.description != null)
                        Text(
                          asset.description!.length > 30
                              ? '${asset.description!.substring(0, 30)}...'
                              : asset.description!,
                          style: AppTypography.geistRegular13.copyWith(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 11.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),

                // Claim button if claimable
                if (isClaimable)
                  SizedBox(
                    height: 32.h,
                    child: ElevatedButton(
                      onPressed: onClaim,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Claim',
                        style: AppTypography.geistSemiBold15.copyWith(
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagCard() {
    final tagColor = asset.color ?? Colors.teal;

    return Container(
      height: 90.h, // Compact height
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [tagColor.withOpacity(0.8), tagColor.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: tagColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Animated tag decoration
          Positioned(
            top: -10,
            right: -5,
            child: Icon(
              PhosphorIcons.tag(PhosphorIconsStyle.fill),
              color: Colors.white.withOpacity(0.1),
              size: 50.sp,
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Tag icon
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    PhosphorIcons.tag(PhosphorIconsStyle.fill),
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),

                SizedBox(width: 12.w),

                // Tag info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Tag type badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'TAG',
                          style: AppTypography.geistSemiBold15.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 9.sp,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),

                      SizedBox(height: 6.h),

                      // Tag name
                      Text(
                        asset.name,
                        style: AppTypography.geistSemiBold15.copyWith(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Tag description
                      if (asset.description != null)
                        Text(
                          asset.description!.length > 25
                              ? '${asset.description!.substring(0, 25)}...'
                              : asset.description!,
                          style: AppTypography.geistRegular13.copyWith(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 11.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),

                // Claim button if claimable
                if (isClaimable)
                  SizedBox(
                    height: 28.h,
                    child: ElevatedButton(
                      onPressed: onClaim,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Claim',
                        style: AppTypography.geistSemiBold15.copyWith(
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
