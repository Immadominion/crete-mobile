import 'package:flutter/animation.dart';

class AppAnimations {
  // Duration constants
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);

  // Common curves
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve bounceIn = Curves.bounceIn;
  static const Curve bounceOut = Curves.bounceOut;
  static const Curve elasticIn = Curves.elasticIn;
  static const Curve elasticOut = Curves.elasticOut;
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;

  // Page transitions
  static const Duration pageTransition = normal;
  static const Curve pageTransitionCurve = fastOutSlowIn;

  // Modal animations
  static const Duration modalEnter = normal;
  static const Duration modalExit = fast;
  static const Curve modalCurve = easeInOut;

  // Button animations
  static const Duration buttonPress = Duration(milliseconds: 100);
  static const Duration buttonRelease = Duration(milliseconds: 200);
  static const Curve buttonCurve = easeOut;

  // Loading animations
  static const Duration loadingRotation = Duration(milliseconds: 1000);
  static const Duration loadingPulse = Duration(milliseconds: 1200);
  static const Duration shimmerAnimation = Duration(milliseconds: 1500);

  // Chat animations
  static const Duration messageSend = fast;
  static const Duration messageReceive = normal;
  static const Duration typingIndicator = Duration(milliseconds: 600);
  static const Curve messageCurve = easeOut;

  // List animations
  static const Duration listItemEnter = normal;
  static const Duration listItemExit = fast;
  static const Curve listItemCurve = easeInOut;

  // Notification animations
  static const Duration notificationSlideIn = normal;
  static const Duration notificationSlideOut = fast;
  static const Duration notificationDuration = Duration(seconds: 4);

  // Wallet connection animations
  static const Duration walletConnect = slow;
  static const Duration walletDisconnect = fast;
  static const Curve walletCurve = elasticOut;

  // Vote casting animations
  static const Duration voteCast = normal;
  static const Duration voteResult = slow;
  static const Curve voteCurve = bounceOut;

  // DAO join/leave animations
  static const Duration daoJoin = slow;
  static const Duration daoLeave = normal;
  static const Curve daoCurve = elasticOut;

  // Search animations
  static const Duration searchExpand = normal;
  static const Duration searchCollapse = fast;
  static const Curve searchCurve = easeInOut;

  // Tab switching
  static const Duration tabSwitch = fast;
  static const Curve tabCurve = easeInOut;

  // Pull to refresh
  static const Duration refreshTrigger = normal;
  static const Duration refreshComplete = fast;

  // Floating Action Button
  static const Duration fabShow = normal;
  static const Duration fabHide = fast;
  static const Curve fabCurve = elasticOut;

  // Bottom sheet
  static const Duration bottomSheetSlide = normal;
  static const Curve bottomSheetCurve = easeOut;

  // Theme switching
  static const Duration themeSwitch = normal;
  static const Curve themeCurve = easeInOut;

  // Error state animations
  static const Duration errorShake = Duration(milliseconds: 600);
  static const Duration errorFade = normal;

  // Success animations
  static const Duration successScale = normal;
  static const Duration successCheckmark = slow;
  static const Curve successCurve = elasticOut;

  // Stagger delays for list animations
  static const Duration staggerDelay = Duration(milliseconds: 50);
  static const Duration initialDelay = Duration(milliseconds: 100);
}
