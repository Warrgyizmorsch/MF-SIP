import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Shared, fixed app bar for the four goal-creation steps.
class GoalFlowAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GoalFlowAppBar({
    super.key,
    required this.title,
    required this.onBack,
    this.step,
    this.trailing,
  });
  final String title;
  final VoidCallback onBack;
  final int? step;
  final Widget? trailing;

  @override
  Size get preferredSize => Size.fromHeight(step == null ? 64 : 68);

  @override
  Widget build(BuildContext context) => AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: const Color(0xFFF5F6FA),
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    toolbarHeight: 60,
    titleSpacing: 20,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Material(
          color: const Color(0xFFF0F1F6),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onBack,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: 44,
              height: 44,
              child: Center(
                child: SvgPicture.asset(
                  'assets/home/figma/pick_goal_back.svg',
                  width: 22,
                  height: 22,
                ),
              ),
            ),
          ),
        ),
        Flexible(
          child: Text(
            step == null
                ? title
                : step == 4
                ? 'Goal Basket'
                : 'New Goal',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF12121A),
            ),
          ),
        ),
        trailing ??
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFFF0F1F6),
                shape: BoxShape.circle,
              ),
              child: Text(
                step == null ? '' : '$step/4',
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF441D9E),
                ),
              ),
            ),
      ],
    ),
    bottom: step == null
        ? null
        : PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Semantics(
                label: 'Goal creation progress',
                value: 'Step $step of 4',
                child: Row(
                  children: List.generate(
                    4,
                    (index) => Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOut,
                        height: 4,
                        margin: EdgeInsets.only(right: index == 3 ? 0 : 6),
                        decoration: BoxDecoration(
                          color: index < step!
                              ? const Color(0xFF441D9E)
                              : const Color(0xFFE4E6EE),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
  );
}
