#!/usr/bin/env dart
// Chat UI/UX Improvements Validation Script

import 'dart:io';

void main() {
  print('🚀 VALIDATING CRETE CHAT UI/UX IMPROVEMENTS\n');

  final validations = [
    _validateChannelChatPage(),
    _validateEnhancedMessagesList(),
    _validateEnhancedTypingIndicator(),
    _validateEnhancedOnlineMembersSidebar(),
    _validateEnhancedReactionPicker(),
    _validateChannelHeaderWidget(),
    _validateAppFlowUpdates(),
  ];

  final passed = validations.where((v) => v).length;
  final total = validations.length;

  print('\n📊 VALIDATION SUMMARY');
  print('Passed: $passed/$total');
  print(
    'Status: ${passed == total ? '✅ ALL CHECKS PASSED' : '⚠️  SOME CHECKS FAILED'}',
  );

  if (passed == total) {
    print('\n🎉 CHAT IMPROVEMENTS SUCCESSFULLY IMPLEMENTED!');
    print('✨ Ready for production testing');
  } else {
    print('\n🔍 Please review failed checks above');
    exit(1);
  }
}

bool _validateChannelChatPage() {
  print('🔍 Validating ChannelChatPage...');

  final file = File('lib/presentation/communities/chat/channel_chat_page.dart');
  if (!file.existsSync()) {
    print('❌ channel_chat_page.dart not found');
    return false;
  }

  final content = file.readAsStringSync();
  final checks = [
    content.contains('chat-bg-01.png'), // Background image
    content.contains('EnhancedOnlineMembersSidebar'), // Sidebar integration
    content.contains('_buildScrollToBottomFAB'), // Scroll to bottom
    content.contains('_showMembersSidebar'), // Sidebar state
    content.contains('_onlineMembers'), // Demo data
    content.contains('OnlineMember'), // Model usage
    content.contains('fadeAnimation'), // Animations
    content.contains('_scrollController'), // Scroll management
  ];

  final passed = checks.where((c) => c).length;
  print(
    '   Background integration: ${content.contains('chat-bg-01.png') ? '✅' : '❌'}',
  );
  print(
    '   Sidebar integration: ${content.contains('EnhancedOnlineMembersSidebar') ? '✅' : '❌'}',
  );
  print(
    '   Scroll-to-bottom FAB: ${content.contains('_buildScrollToBottomFAB') ? '✅' : '❌'}',
  );
  print('   Animations: ${content.contains('fadeAnimation') ? '✅' : '❌'}');
  print('   Demo data: ${content.contains('_onlineMembers') ? '✅' : '❌'}');

  final success = passed >= 6;
  print('   Result: ${success ? '✅ PASSED' : '❌ FAILED'} ($passed/8 checks)\n');
  return success;
}

bool _validateEnhancedMessagesList() {
  print('🔍 Validating EnhancedMessagesList...');

  final file = File(
    'lib/presentation/communities/chat/widgets/messages_list_widget.dart',
  );
  if (!file.existsSync()) {
    print('❌ messages_list_widget.dart not found');
    return false;
  }

  final content = file.readAsStringSync();
  final checks = [
    content.contains('StatefulWidget'), // Refactored to stateful
    content.contains('AnimationController'), // Animations
    content.contains('_animationController'), // Animation setup
    content.contains('staggered'), // Staggered animations
    content.contains('_buildMessage'), // Message building
  ];

  final passed = checks.where((c) => c).length;
  print(
    '   StatefulWidget refactor: ${content.contains('StatefulWidget') ? '✅' : '❌'}',
  );
  print(
    '   Animation integration: ${content.contains('AnimationController') ? '✅' : '❌'}',
  );
  print(
    '   Staggered animations: ${content.contains('staggered') ? '✅' : '❌'}',
  );

  final success = passed >= 3;
  print('   Result: ${success ? '✅ PASSED' : '❌ FAILED'} ($passed/5 checks)\n');
  return success;
}

bool _validateEnhancedTypingIndicator() {
  print('🔍 Validating EnhancedTypingIndicator...');

  final file = File(
    'lib/presentation/communities/chat/widgets/enhanced_typing_indicator.dart',
  );
  if (!file.existsSync()) {
    print('❌ enhanced_typing_indicator.dart not found');
    return false;
  }

  final content = file.readAsStringSync();
  final checks = [
    content.contains('class EnhancedTypingIndicator'), // Main class
    content.contains('TickerProviderStateMixin'), // Animation mixin
    content.contains('bouncing'), // Bouncing animation
    content.contains('typingUsers'), // User list
    content.contains('_buildTypingDots'), // Dots animation
  ];

  final passed = checks.where((c) => c).length;
  print(
    '   Widget created: ${content.contains('class EnhancedTypingIndicator') ? '✅' : '❌'}',
  );
  print(
    '   Animation system: ${content.contains('TickerProviderStateMixin') ? '✅' : '❌'}',
  );
  print('   Bouncing dots: ${content.contains('bouncing') ? '✅' : '❌'}');

  final success = passed >= 3;
  print('   Result: ${success ? '✅ PASSED' : '❌ FAILED'} ($passed/5 checks)\n');
  return success;
}

bool _validateEnhancedOnlineMembersSidebar() {
  print('🔍 Validating EnhancedOnlineMembersSidebar...');

  final file = File(
    'lib/presentation/communities/chat/widgets/enhanced_online_members_sidebar.dart',
  );
  if (!file.existsSync()) {
    print('❌ enhanced_online_members_sidebar.dart not found');
    return false;
  }

  final content = file.readAsStringSync();
  final checks = [
    content.contains('class EnhancedOnlineMembersSidebar'), // Main class
    content.contains('OnlineMember'), // Model class
    content.contains('MemberStatus'), // Status enum
    content.contains('_slideAnimation'), // Slide animation
    content.contains('_buildMembersList'), // Members list
  ];

  final passed = checks.where((c) => c).length;
  print(
    '   Widget created: ${content.contains('class EnhancedOnlineMembersSidebar') ? '✅' : '❌'}',
  );
  print('   Data models: ${content.contains('OnlineMember') ? '✅' : '❌'}');
  print('   Animations: ${content.contains('_slideAnimation') ? '✅' : '❌'}');

  final success = passed >= 3;
  print('   Result: ${success ? '✅ PASSED' : '❌ FAILED'} ($passed/5 checks)\n');
  return success;
}

bool _validateEnhancedReactionPicker() {
  print('🔍 Validating EnhancedReactionPicker...');

  final file = File(
    'lib/presentation/communities/chat/widgets/enhanced_reaction_picker.dart',
  );
  final improvedFile = File(
    'lib/presentation/communities/chat/widgets/enhanced_reaction_picker_improved.dart',
  );

  if (!file.existsSync() && !improvedFile.existsSync()) {
    print('❌ enhanced_reaction_picker.dart not found');
    return false;
  }

  final content = file.existsSync()
      ? file.readAsStringSync()
      : improvedFile.readAsStringSync();

  final checks = [
    content.contains('class EnhancedReactionPicker') ||
        content.contains('class EnhancedReactionPickerImproved'), // Main class
    content.contains('recentReactions'), // Recent reactions
    content.contains('TabController') ||
        content.contains('_tabController'), // Tab navigation
    content.contains('onReactionSelected'), // Callback
    content.contains('HapticFeedback'), // Haptic feedback
  ];

  final passed = checks.where((c) => c).length;
  print(
    '   Widget created: ${(content.contains('class EnhancedReactionPicker') || content.contains('class EnhancedReactionPickerImproved')) ? '✅' : '❌'}',
  );
  print(
    '   Recent reactions: ${content.contains('recentReactions') ? '✅' : '❌'}',
  );
  print(
    '   Tab navigation: ${(content.contains('TabController') || content.contains('_tabController')) ? '✅' : '❌'}',
  );

  final success = passed >= 3;
  print('   Result: ${success ? '✅ PASSED' : '❌ FAILED'} ($passed/5 checks)\n');
  return success;
}

bool _validateChannelHeaderWidget() {
  print('🔍 Validating ChannelHeaderWidget...');

  final file = File(
    'lib/presentation/communities/chat/widgets/channel_header_widget.dart',
  );
  if (!file.existsSync()) {
    print('❌ channel_header_widget.dart not found');
    return false;
  }

  final content = file.readAsStringSync();
  final checks = [
    content.contains('StatefulWidget'), // Refactored to stateful
    content.contains('AnimationController'), // Animations
    content.contains('_pulseAnimation'), // Pulse animation
    content.contains('onlineCount'), // Online indicator
    content.contains('showMenu'), // Action menu
  ];

  final passed = checks.where((c) => c).length;
  print(
    '   StatefulWidget refactor: ${content.contains('StatefulWidget') ? '✅' : '❌'}',
  );
  print(
    '   Animation integration: ${content.contains('AnimationController') ? '✅' : '❌'}',
  );
  print('   Interactive elements: ${content.contains('showMenu') ? '✅' : '❌'}');

  final success = passed >= 3;
  print('   Result: ${success ? '✅ PASSED' : '❌ FAILED'} ($passed/5 checks)\n');
  return success;
}

bool _validateAppFlowUpdates() {
  print('🔍 Validating APP_FLOW updates...');

  final file = File('APP_FLOW.txt');
  if (!file.existsSync()) {
    print('❌ APP_FLOW.txt not found');
    return false;
  }

  final content = file.readAsStringSync();
  final checks = [
    content.contains('Channel Backgrounds'), // Background section
    content.contains('Upload custom background images'), // Upload functionality
    content.contains('preview'), // Preview feature
    content.contains('Seasonal'), // Seasonal feature
    content.contains('User preference to override'), // User override
  ];

  final passed = checks.where((c) => c).length;
  print(
    '   Background section: ${content.contains('Channel Backgrounds') ? '✅' : '❌'}',
  );
  print(
    '   Upload functionality: ${content.contains('Upload custom background images') ? '✅' : '❌'}',
  );
  print('   Preview feature: ${content.contains('preview') ? '✅' : '❌'}');
  print(
    '   User override: ${content.contains('User preference to override') ? '✅' : '❌'}',
  );

  final success = passed >= 4;
  print('   Result: ${success ? '✅ PASSED' : '❌ FAILED'} ($passed/5 checks)\n');
  return success;
}
