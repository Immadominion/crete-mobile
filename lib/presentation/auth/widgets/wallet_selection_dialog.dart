import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/services/wallet_connection_service.dart';
import '../../../core/theme/typography.dart';

class WalletSelectionDialog extends StatelessWidget {
  const WalletSelectionDialog({
    super.key,
    required this.walletTypes,
    required this.onWalletSelected,
  });

  final List<WalletType> walletTypes;
  final void Function(WalletType) onWalletSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Select Wallet', style: AppTypography.geistSemiBold15),
          SizedBox(height: 20.h),
          ...walletTypes.map(
            (walletType) => ListTile(
              leading: Icon(_getWalletIcon(walletType)),
              title: Text(
                _getWalletName(walletType),
                style: AppTypography.geistRegular16,
              ),
              onTap: () {
                Navigator.pop(context);
                onWalletSelected(walletType);
              },
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  IconData _getWalletIcon(WalletType walletType) {
    switch (walletType) {
      case WalletType.phantom:
        return Icons.account_balance_wallet;
      case WalletType.solflare:
        return Icons.wallet;
      case WalletType.backpack:
        return Icons.backpack;
      case WalletType.walletConnect:
        return Icons.link;
    }
  }

  String _getWalletName(WalletType walletType) {
    switch (walletType) {
      case WalletType.phantom:
        return 'Phantom';
      case WalletType.solflare:
        return 'Solflare';
      case WalletType.backpack:
        return 'Backpack';
      case WalletType.walletConnect:
        return 'WalletConnect';
    }
  }
}
