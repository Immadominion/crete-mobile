import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';
import '../../../../domain/models/chat/chat_message.dart';

/// Dialog for selecting assets (tags, roles, NFTs, tokens) to send in chat
class AssetSelectorDialog extends StatefulWidget {
  const AssetSelectorDialog({
    super.key,
    required this.assetType,
    required this.isDarkMode,
    required this.onAssetSelected,
  });

  final AssetType assetType;
  final bool isDarkMode;
  final void Function(SentAsset) onAssetSelected;

  @override
  State<AssetSelectorDialog> createState() => _AssetSelectorDialogState();
}

class _AssetSelectorDialogState extends State<AssetSelectorDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isClaimable = true;
  int _claimableDays = 7;

  // Demo assets
  final List<SentAsset> _demoTokens = [
    const SentAsset(
      id: 'token-1',
      type: AssetType.token,
      name: 'BONK',
      value: 1000,
      imageUrl: 'https://cryptologos.cc/logos/bonk-bonk-logo.png',
      tokenAddress: '7GeR1qvqZaH9LXs4BbevDzSUA2wuHP3V4mR8n2XrZ9by',
    ),
    const SentAsset(
      id: 'token-2',
      type: AssetType.token,
      name: 'SOL',
      value: 0.1,
      imageUrl: 'https://cryptologos.cc/logos/solana-sol-logo.png',
      tokenAddress: 'So11111111111111111111111111111111111111112',
    ),
  ];

  final List<SentAsset> _demoNfts = [
    const SentAsset(
      id: 'nft-1',
      type: AssetType.nft,
      name: 'Cosmic Explorer #42',
      value: 1,
      imageUrl: 'https://i.imgur.com/pLOQTGa.jpeg',
      metadata: {
        'collection': 'Cosmic Explorers',
        'rarity': 'Legendary',
        'creator': 'ArtistX',
      },
    ),
    const SentAsset(
      id: 'nft-2',
      type: AssetType.nft,
      name: 'PixelPunk #108',
      value: 1,
      imageUrl: 'https://i.imgur.com/QEqyJ2j.jpeg',
      metadata: {
        'collection': 'PixelPunks',
        'rarity': 'Rare',
        'creator': 'CryptoArtist',
      },
    ),
  ];

  final List<SentAsset> _demoRoles = [
    const SentAsset(
      id: 'role-1',
      type: AssetType.role,
      name: 'Community Contributor',
      value: 1,
      imageUrl: 'https://i.imgur.com/XqQLHX6.png',
    ),
    const SentAsset(
      id: 'role-2',
      type: AssetType.role,
      name: 'Moderator',
      value: 1,
      imageUrl: 'https://i.imgur.com/2QbZJJq.png',
    ),
  ];

  final List<SentAsset> _demoTags = [
    const SentAsset(
      id: 'tag-1',
      type: AssetType.tag,
      name: 'Web3 Developer',
      value: 1,
      imageUrl: 'https://i.imgur.com/o2q1Vdl.png',
    ),
    const SentAsset(
      id: 'tag-2',
      type: AssetType.tag,
      name: 'NFT Artist',
      value: 1,
      imageUrl: 'https://i.imgur.com/y5Tl3Ha.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: widget.isDarkMode ? AppColors.black : AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 12.h),
          Container(
            width: 32.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: widget.isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray400,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Icon(
                  _getAssetTypeIcon(),
                  color: AppColors.primary,
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  _getAssetTypeTitle(),
                  style: AppTypography.geistSemiBold15.copyWith(
                    color: widget.isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                    fontSize: 18.sp,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    PhosphorIcons.x(PhosphorIconsStyle.bold),
                    color: widget.isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.gray600,
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          _buildTabBar(),
          SizedBox(height: 16.h),
          SizedBox(
            height: 300.h,
            child: TabBarView(
              controller: _tabController,
              children: [_buildAssetList(), _buildOptionsTab()],
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      indicatorColor: AppColors.primary,
      labelColor: widget.isDarkMode
          ? AppColors.darkTextPrimary
          : AppColors.gray900,
      unselectedLabelColor: widget.isDarkMode
          ? AppColors.darkTextSecondary
          : AppColors.gray600,
      tabs: [
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                PhosphorIcons.listMagnifyingGlass(PhosphorIconsStyle.bold),
                size: 16.sp,
              ),
              SizedBox(width: 8.w),
              const Text('Select', style: AppTypography.geistMedium13),
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(PhosphorIcons.gear(PhosphorIconsStyle.bold), size: 16.sp),
              SizedBox(width: 8.w),
              const Text('Options', style: AppTypography.geistMedium13),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAssetList() {
    final assets = _getAssetsByType();

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: assets.length,
      itemBuilder: (context, index) {
        final asset = assets[index];
        return _buildAssetItem(asset);
      },
    );
  }

  Widget _buildAssetItem(SentAsset asset) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? AppColors.darkContainerBorder.withOpacity(0.3)
            : AppColors.gray100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: widget.isDarkMode
              ? AppColors.darkContainerBorder
              : AppColors.gray200,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: asset.imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    asset.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      _getAssetTypeIcon(),
                      color: AppColors.primary,
                      size: 24.sp,
                    ),
                  ),
                )
              : Icon(
                  _getAssetTypeIcon(),
                  color: AppColors.primary,
                  size: 24.sp,
                ),
        ),
        title: Text(
          asset.name,
          style: AppTypography.geistSemiBold15.copyWith(
            color: widget.isDarkMode
                ? AppColors.darkTextPrimary
                : AppColors.gray900,
          ),
        ),
        subtitle: Text(
          _getAssetSubtitle(asset),
          style: AppTypography.geistRegular13.copyWith(
            color: widget.isDarkMode
                ? AppColors.darkTextSecondary
                : AppColors.gray600,
          ),
        ),
        trailing: Icon(
          PhosphorIcons.arrowRight(PhosphorIconsStyle.bold),
          color: widget.isDarkMode
              ? AppColors.darkTextSecondary
              : AppColors.gray600,
          size: 20.sp,
        ),
        onTap: () {
          Navigator.pop(context);
          widget.onAssetSelected(asset);
        },
      ),
    );
  }

  Widget _buildOptionsTab() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Send Options',
            style: AppTypography.geistSemiBold15.copyWith(
              color: widget.isDarkMode
                  ? AppColors.darkTextPrimary
                  : AppColors.gray900,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 16.h),
          if (widget.assetType == AssetType.token ||
              widget.assetType == AssetType.nft)
            _buildClaimableOption(),
          SizedBox(height: 16.h),
          if (_isClaimable) _buildClaimableDaysSlider(),
        ],
      ),
    );
  }

  Widget _buildClaimableOption() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? AppColors.darkContainerBorder.withOpacity(0.3)
            : AppColors.gray100,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            PhosphorIcons.gift(PhosphorIconsStyle.bold),
            color: AppColors.primary,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Make Claimable',
                  style: AppTypography.geistSemiBold15.copyWith(
                    color: widget.isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                  ),
                ),
                Text(
                  'Recipient must claim to receive this asset',
                  style: AppTypography.geistRegular12.copyWith(
                    color: widget.isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.gray600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isClaimable,
            activeColor: AppColors.primary,
            onChanged: (value) {
              setState(() {
                _isClaimable = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildClaimableDaysSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              PhosphorIcons.clockCountdown(PhosphorIconsStyle.bold),
              color: widget.isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
              size: 16.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'Claimable for $_claimableDays days',
              style: AppTypography.geistMedium13.copyWith(
                color: widget.isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray600,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Slider(
          value: _claimableDays.toDouble(),
          min: 1,
          max: 30,
          divisions: 29,
          activeColor: AppColors.primary,
          inactiveColor: widget.isDarkMode
              ? AppColors.darkContainerBorder
              : AppColors.gray300,
          onChanged: (value) {
            setState(() {
              _claimableDays = value.round();
            });
          },
        ),
      ],
    );
  }

  List<SentAsset> _getAssetsByType() {
    switch (widget.assetType) {
      case AssetType.token:
        return _demoTokens;
      case AssetType.nft:
        return _demoNfts;
      case AssetType.role:
        return _demoRoles;
      case AssetType.tag:
        return _demoTags;
    }
  }

  String _getAssetTypeTitle() {
    switch (widget.assetType) {
      case AssetType.token:
        return 'Send Tokens';
      case AssetType.nft:
        return 'Send NFT';
      case AssetType.role:
        return 'Assign Role';
      case AssetType.tag:
        return 'Add Tag';
    }
  }

  PhosphorIconData _getAssetTypeIcon() {
    switch (widget.assetType) {
      case AssetType.token:
        return PhosphorIcons.coins(PhosphorIconsStyle.bold);
      case AssetType.nft:
        return PhosphorIcons.image(PhosphorIconsStyle.bold);
      case AssetType.role:
        return PhosphorIcons.user(PhosphorIconsStyle.bold);
      case AssetType.tag:
        return PhosphorIcons.tag(PhosphorIconsStyle.bold);
    }
  }

  String _getAssetSubtitle(SentAsset asset) {
    switch (asset.type) {
      case AssetType.token:
        return '${asset.value} tokens';
      case AssetType.nft:
        return asset.metadata != null &&
                asset.metadata!.containsKey('collection')
            ? asset.metadata!['collection'].toString()
            : 'NFT';
      case AssetType.role:
        return 'Community Role';
      case AssetType.tag:
        return 'Profile Tag';
    }
  }
}
