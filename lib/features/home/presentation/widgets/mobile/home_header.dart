import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/shadows.dart';
import 'package:my_sip/core/utils/constant/sizes.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

import 'home_design.dart';

class HomeQuickAction {
  const HomeQuickAction({
    required this.label,
    required this.asset,
    required this.onTap,
    required this.iconSize,
  });

  final String label;
  final String asset;
  final VoidCallback onTap;
  final Size iconSize;
}

/// The compact and expanded reference headers share one natural-flow layout.
/// The actual device status bar supplies the top inset rather than a fake clock.
class MobileHomeHeader extends StatefulWidget {
  const MobileHomeHeader({
    super.key,
    required this.actions,
    required this.avatar,
    required this.onSearch,
    required this.onCart,
    required this.onNotifications,
    required this.onProfile,
  }) : assert(actions.length == 6);

  final List<HomeQuickAction> actions;
  final Widget avatar;
  final VoidCallback onSearch;
  final VoidCallback onCart;
  final VoidCallback onNotifications;
  final VoidCallback onProfile;

  @override
  State<MobileHomeHeader> createState() => _MobileHomeHeaderState();
}

class _MobileHomeHeaderState extends State<MobileHomeHeader> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = (constraints.maxWidth / HomeMetrics.referenceWidth)
            .clamp(0.7, 1.2)
            .toDouble();
        final topInset = MediaQuery.paddingOf(context).top;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 16 * scale),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: Ucolors.homeHeaderGradient,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(
                        USizes.homeHeaderBottomRadius * scale,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: topInset),
                      _toolbar(context, scale),
                      SizedBox(height: 9 * scale),
                      _actionRow(widget.actions.take(3), scale),
                      ClipRect(
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          alignment: Alignment.topCenter,
                          child: _expanded
                              ? Padding(
                                  padding: EdgeInsets.only(
                                    top: 16 * scale,
                                    bottom: 2 * scale,
                                  ),
                                  child: _actionRow(
                                    widget.actions.skip(3),
                                    scale,
                                  ),
                                )
                              : const SizedBox(width: double.infinity),
                        ),
                      ),
                      SizedBox(height: 27 * scale),
                    ],
                  ),
                ),
              ),
              // A 44px touch target encloses the reference's 49 x 30px pill.
              Positioned(
                bottom: 0,
                child: Semantics(
                  button: true,
                  expanded: _expanded,
                  label: _expanded
                      ? 'Show fewer shortcuts'
                      : 'Show all shortcuts',
                  child: SizedBox(
                    width: (49 * scale).clamp(44.0, 60.0).toDouble(),
                    height: 44,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => _expanded = !_expanded),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 49 * scale,
                          height: 30 * scale,
                          decoration: BoxDecoration(
                            color: Ucolors.homeHeaderEnd,
                            borderRadius: BorderRadius.circular(20 * scale),
                            border: Border.all(color: Ucolors.white, width: 2),
                            boxShadow: UShadows.homeCard,
                          ),
                          alignment: Alignment.center,
                          child: AnimatedRotation(
                            turns: _expanded ? -0.25 : 0.25,
                            duration: const Duration(milliseconds: 250),
                            child: SvgPicture.asset(
                              UImages.homeHeaderChevron,
                              width: 6.5 * scale,
                              height: 13.5 * scale,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _toolbar(BuildContext context, double scale) {
    final searchStyle = UTextStyles.homeText(
      size: (13 * scale).clamp(11.0, 15.0).toDouble(),
      weight: FontWeight.w400,
      color: Ucolors.white,
      letterSpacing: 0.2,
    );
    final searchHeight = math.max(
      (31 * scale).clamp(28.0, 38.0).toDouble(),
      HomeTextLayout.measure(
            context,
            'Search for SBI ...',
            style: searchStyle,
          ).height +
          6 * scale,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final logoWidth = 45 * scale;
        final logoGap = 12 * scale;
        final searchGap = 5 * scale;
        // Reserve four 44px targets: search and the three trailing actions.
        final minimumWidth = logoWidth + logoGap + searchGap + 4 * 44;
        final sidePadding = math.min(
          20 * scale,
          math.max(0.0, (constraints.maxWidth - minimumWidth) / 2),
        );
        final searchWidth =
            constraints.maxWidth -
            2 * sidePadding -
            logoWidth -
            logoGap -
            searchGap -
            3 * 44;
        final compactSearch = searchWidth < 120;
        final toolbarHeight = (59 * scale).clamp(54.0, 72.0).toDouble();

        return SizedBox(
          height: compactSearch
              ? toolbarHeight
              : math.max(toolbarHeight, searchHeight + 12 * scale),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: sidePadding),
            child: Row(
              children: [
                SvgPicture.asset(
                  UImages.homeBrandMark,
                  width: logoWidth,
                  height: 38 * scale,
                ),
                SizedBox(width: logoGap),
                Expanded(
                  child: compactSearch
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: _HeaderButton(
                            label: 'Search mutual funds',
                            onTap: widget.onSearch,
                            child: SvgPicture.asset(
                              UImages.homeSearch,
                              width: 18 * scale,
                              height: 18 * scale,
                              colorFilter: const ColorFilter.mode(
                                Ucolors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        )
                      : _searchField(searchStyle, searchHeight, scale),
                ),
                SizedBox(width: searchGap),
                _HeaderButton(
                  label: 'Cart',
                  onTap: widget.onCart,
                  child: Icon(
                    Iconsax.shopping_cart,
                    color: Ucolors.white,
                    size: 23 * scale,
                  ),
                ),
                _HeaderButton(
                  label: 'Notifications',
                  onTap: widget.onNotifications,
                  child: SvgPicture.asset(
                    UImages.homeNotifications,
                    width: 23 * scale,
                    height: 23 * scale,
                  ),
                ),
                _HeaderButton(
                  label: 'Your profile',
                  onTap: widget.onProfile,
                  child: Container(
                    width: 31 * scale,
                    height: 31 * scale,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Ucolors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    child: widget.avatar,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _searchField(TextStyle style, double height, double scale) =>
      Semantics(
        button: true,
        label: 'Search mutual funds',
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onSearch,
          child: SizedBox(
            height: math.max(44.0, height),
            child: Center(
              child: Container(
                height: height,
                padding: EdgeInsets.symmetric(horizontal: 9 * scale),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8 * scale),
                  border: Border.all(color: Ucolors.white),
                  boxShadow: UShadows.homeSearch,
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      UImages.homeSearch,
                      width: 18 * scale,
                      height: 18 * scale,
                      colorFilter: const ColorFilter.mode(
                        Ucolors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 7 * scale),
                    Expanded(
                      child: Text(
                        'Search for SBI ...',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: style,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget _actionRow(Iterable<HomeQuickAction> actions, double scale) {
    final items = actions.toList(growable: false);
    final labelStyle = UTextStyles.homeText(
      size: (12 * scale).clamp(10.0, 14.0).toDouble(),
      color: Ucolors.white,
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 36 * scale),
      child: LayoutBuilder(
        builder: (context, constraints) {
          var labelHeight = 24 * scale;
          for (final action in items) {
            labelHeight = math.max(
              labelHeight,
              HomeTextLayout.measure(
                context,
                action.label,
                style: labelStyle,
                maxWidth: constraints.maxWidth / items.length,
                maxLines: 2,
              ).height,
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items
                .map(
                  (action) => Expanded(
                    child: Semantics(
                      button: true,
                      label: action.label,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: action.onTap,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: HomeMetrics.quickActionSize * scale,
                              height: HomeMetrics.quickActionSize * scale,
                              decoration: BoxDecoration(
                                color: Ucolors.white,
                                borderRadius: BorderRadius.circular(
                                  USizes.homeQuickActionRadius * scale,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                action.asset,
                                width: action.iconSize.width * scale,
                                height: action.iconSize.height * scale,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: 2 * scale),
                            SizedBox(
                              height: labelHeight,
                              child: Center(
                                child: Text(
                                  action.label,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: labelStyle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.label,
    required this.onTap,
    required this.child,
  });

  final String label;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: label,
    child: Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(width: 44, height: 44, child: Center(child: child)),
      ),
    ),
  );
}
