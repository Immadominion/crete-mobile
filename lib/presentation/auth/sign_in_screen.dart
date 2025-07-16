import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/services/wallet_connection_service.dart';
import '../../core/theme/colors.dart';
import 'widgets/sign_in_page_content.dart';
import 'widgets/wallet_selection_dialog.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final WalletConnectionService _walletService = WalletConnectionService();
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    _walletService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackgroundPrimary
          : AppColors.backgroundPrimary,
      body: SignInPageContent(
        isDarkMode: isDarkMode,
        statusBarHeight: statusBarHeight,
        isConnecting: _isConnecting,
        onWalletConnect: _handleWalletConnect,
        onDiscordImport: _handleDiscordImport,
        onGuestMode: _handleGuestMode,
      ),
    );
  }

  Future<void> _handleWalletConnect() async {
    setState(() => _isConnecting = true);

    try {
      // Show wallet selection dialog
      await _showWalletSelectionDialog();
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to connect wallet: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isConnecting = false);
      }
    }
  }

  Future<void> _showWalletSelectionDialog() async {
    final walletTypes = await _walletService.getAvailableWallets();

    if (!mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => WalletSelectionDialog(
        walletTypes: walletTypes,
        onWalletSelected: _connectToWallet,
      ),
    );
  }

  Future<void> _connectToWallet(WalletType walletType) async {
    setState(() => _isConnecting = true);

    try {
      final success = await _walletService.connectWallet(walletType);

      if (success && mounted) {
        // Navigate to home or dashboard
        Navigator.pushReplacementNamed(context, '/home');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to connect to ${_getWalletName(walletType)}'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isConnecting = false);
      }
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

  void _handleDiscordImport() {
    // TODO: Implement Discord import
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Discord import coming soon!')),
    );
  }

  void _handleGuestMode() {
    // TODO: Implement guest mode
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Guest mode coming soon!')));
  }
}
