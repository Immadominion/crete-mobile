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
      height: 120.h, // Compact height
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
              size: 50.sp,
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Token icon and amount (left side)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Token transfer badge (compact)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          'TOKEN',
                          style: AppTypography.geistSemiBold15.copyWith(
                            color: Colors.white,
                            fontSize: 9.sp,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),

                      // Token amount and name
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
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
                              size: 18.sp,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${asset.value}',
                                  style: AppTypography.geistSemiBold15.copyWith(
                                    color: Colors.white,
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  asset.name.toUpperCase(),
                                  style: AppTypography.geistSemiBold15.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12.sp,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Network and claim row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Network badge (compact)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  PhosphorIcons.globe(PhosphorIconsStyle.bold),
                                  color: Colors.white.withOpacity(0.8),
                                  size: 12.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'Solana', // Always Solana
                                  style: AppTypography.geistMedium13.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Compact claim button
                          if (isClaimable)
                            SizedBox(
                              height: 24.h,
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
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ),
                            ),
                        ],
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

  // Helper to format remaining claim time
  String _getTimeRemaining() {
    if (claimableUntil == null) return '';
    final difference = claimableUntil!.difference(DateTime.now());
    if (difference.inDays > 0) {
      return '${difference.inDays}d ${difference.inHours % 24}h';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ${difference.inMinutes % 60}m';
    } else {
      return '${difference.inMinutes}m';
    }
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

  List<Widget> _buildRoleBenefits(Color textColor) {
    final benefits = [
      'Access to private channels',
      'Participation in governance',
      'Special community badges',
      'Early access to features',
    ];

    return benefits.map((benefit) {
      return Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Row(
          children: [
            Icon(
              PhosphorIcons.check(PhosphorIconsStyle.bold),
              color: textColor,
              size: 16.sp,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                benefit,
                style: AppTypography.geistMedium13.copyWith(
                  color: textColor,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildTagCard() {
    final tagColor = asset.color ?? Colors.teal;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [tagColor.withOpacity(0.8), tagColor.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: tagColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative elements
          Positioned(
            top: -15,
            right: -10,
            child: Icon(
              PhosphorIcons.tag(PhosphorIconsStyle.fill),
              color: Colors.white.withOpacity(0.1),
              size: 80.sp,
            ),
          ),

          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tag header with glass effect
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                child: Row(
                  children: [
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
                    Text(
                      'COMMUNITY TAG',
                      style: AppTypography.geistSemiBold15.copyWith(
                        color: Colors.white,
                        fontSize: 14.sp,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

              // Tag content
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tag name with modern design
                    Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 12.h),
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          asset.name,
                          style: AppTypography.geistSemiBold15.copyWith(
                            color: tagColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Tag description
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                PhosphorIcons.info(PhosphorIconsStyle.bold),
                                color: Colors.white,
                                size: 16.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'ABOUT THIS TAG',
                                style: AppTypography.geistSemiBold15.copyWith(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            asset.description ??
                                'This tag identifies you as a member with special status or interests in the community.',
                            style: AppTypography.geistRegular13.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14.sp,
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
        ],
      ),
    );
  }

  Widget _buildClaimButton() {
    return GestureDetector(
      onTap: onClaim,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.purple, Colors.deepPurple],
          ),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIcons.gift(PhosphorIconsStyle.fill),
              color: Colors.white,
              size: 18.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'Claim NFT',
              style: AppTypography.geistSemiBold15.copyWith(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTokenClaimButton() {
    return GestureDetector(
      onTap: onClaim,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              PhosphorIcons.wallet(PhosphorIconsStyle.fill),
              color: Colors.orange.shade700,
              size: 16.sp,
            ),
            SizedBox(width: 6.w),
            Text(
              'Claim Now',
              style: AppTypography.geistSemiBold15.copyWith(
                color: Colors.orange.shade700,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
