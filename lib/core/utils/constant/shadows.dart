import 'package:flutter/material.dart';

import 'colors.dart';

class UShadows {
  UShadows._();

  static const List<BoxShadow> homePanel = [
    BoxShadow(
      color: Ucolors.homePanelShadowNearColor,
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Ucolors.homePanelShadowNearColor,
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Ucolors.homePanelShadowFarColor,
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];
  static const List<BoxShadow> homeCard = [
    BoxShadow(
      color: Ucolors.homeCardShadowColor,
      blurRadius: 6,
      offset: Offset(0, 4),
    ),
  ];
  static const List<BoxShadow> homeFeaturedFund = [
    BoxShadow(
      color: Ucolors.homeFeaturedFundShadowColor,
      blurRadius: 6,
      offset: Offset(0, 4),
    ),
  ];
  static const List<BoxShadow> homeGoal = [
    BoxShadow(
      color: Ucolors.homeGoalShadowColor,
      blurRadius: 6,
      offset: Offset(0, 4),
    ),
  ];
  static const List<BoxShadow> homeSearch = [
    BoxShadow(
      color: Ucolors.homeSearchShadowColor,
      blurRadius: 3,
      offset: Offset(0, 1),
    ),
  ];
  static const List<BoxShadow> homeSupportButton = [
    BoxShadow(
      color: Ucolors.homeSupportShadowColor,
      blurRadius: 3,
      offset: Offset(0, 2),
    ),
  ];
  static const List<BoxShadow> homeSelectedNavigation = [
    BoxShadow(
      color: Ucolors.homeSelectedNavigationShadowColor,
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];
}
