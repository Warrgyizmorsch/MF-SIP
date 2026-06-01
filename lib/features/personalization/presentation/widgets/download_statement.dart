import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/dashboard/presentation/pages/comparison_screen.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';

// ─────────────────────────────────────────────
//  COLOR TOKENS  (mirrors the Tailwind config)
// ─────────────────────────────────────────────

// ─────────────────────────────────────────────
//  CONTROLLER
// ─────────────────────────────────────────────

// ─────────────────────────────────────────────
//  SCREEN
// ─────────────────────────────────────────────
class DownloadStatementsScreen extends GetView<PersonalisationController> {
  const DownloadStatementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        appBar: CustomAppBarNormal(
          title: controller.isCapitalGain.value
              ? 'Capital Gain'
              : 'Download Statements',
        ),

        // ── Body ────────────────────────────────────
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              // Card 1 – Statement Type
              // _StatementTypeCard(ctrl: controller),
              // const SizedBox(height: 16),
              Obx(() {
                if (controller.isCapitalGain.value) {
                  return SizedBox.shrink();
                  //  const Padding(
                  //   padding: EdgeInsets.only(bottom: 16.0, top: 4.0),
                  //   child: Text(
                  //     'Capital Gain',
                  //     style: TextStyle(
                  //       fontFamily: 'Inter',
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.w700,
                  //       color: Ucolors.onSurface,
                  //     ),
                  //   ),
                  // );
                } else {
                  return Column(
                    children: [
                      _StatementTypeCard(ctrl: controller),
                      const SizedBox(height: 16),
                    ],
                  );
                }
              }),

              // Card 2 – Input (PAN or Folio)
              Obx(
                () => controller.statementTypeIndex.value == 0
                    ? _PanInputCard(ctrl: controller)
                    : _FolioInputCard(ctrl: controller),
              ),
              const SizedBox(height: 16),

              // Card 3 – Duration
              _DurationCard(ctrl: controller),
              const SizedBox(height: 12),
              Obx(() {
                if (controller.selectedDuration.value == 3) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _CustomDateSelector(ctrl: controller),
                  );
                }
                return const SizedBox.shrink(); // Takes up no space if not custom
              }),

              // Info Banner
              _InfoBanner(email: controller.emailController.text),

              // Bottom padding so content clears the bottom nav
              const SizedBox(height: 100),
            ],
          ),
        ),

        // ── Bottom Action Bar ────────────────────────
        bottomNavigationBar: SafeArea(
          child: Container(
            decoration: BoxDecoration(color: Colors.grey.shade100),
            child: BottomBarButton(
              firstButton: 'Download',
              secondButton: 'Email',
              firstButtonP: () {
                controller.onDownload();
              },
              secondButtonP: () {
                controller.onEmail();
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CARD 1 – STATEMENT TYPE
// ─────────────────────────────────────────────
class _StatementTypeCard extends StatelessWidget {
  final PersonalisationController ctrl;
  const _StatementTypeCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statement Via',
            style: UTextStyles.sectionHeading.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 12),
          Obx(
            () => Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(999),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  _SegmentButton(
                    label: 'PAN Number',
                    isActive: ctrl.statementTypeIndex.value == 0,
                    onTap: () => ctrl.selectStatementType(0),
                  ),
                  _SegmentButton(
                    label: 'Folio Number',
                    isActive: ctrl.statementTypeIndex.value == 1,
                    onTap: () => ctrl.selectStatementType(1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SegmentButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Ucolors.primaryContainer : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: UTextStyles.caption.copyWith(
              color: isActive ? Ucolors.onPrimary : Ucolors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CARD 2a – PAN INPUT
// ─────────────────────────────────────────────
class _PanInputCard extends StatelessWidget {
  final PersonalisationController ctrl;
  const _PanInputCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IgnorePointer(
            child: _FloatingLabelField(
              label: 'PAN Number',
              controller: ctrl.panController,

              inputFormatters: [
                UpperCaseTextFormatter(),
                LengthLimitingTextInputFormatter(10),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _NsdlInfo(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CARD 2b – FOLIO INPUT
// ─────────────────────────────────────────────
class _FolioInputCard extends StatelessWidget {
  final PersonalisationController ctrl;
  const _FolioInputCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        children: [
          Obx(
            () => _DropdownTile(
              label: 'Select Folio',
              value: ctrl.selectedFolio.value,
              onTap: () {
                // Open folio bottom sheet / picker
              },
            ),
          ),
          if (!ctrl.isCapitalGain.value) ...[
            const SizedBox(height: 12),
            Obx(
              () => _DropdownTile(
                label: 'Select Scheme',
                value: ctrl.selectedScheme.value,
                onTap: () {
                  // Open scheme bottom sheet / picker
                },
              ),
            ),
            const SizedBox(height: 8),
            _NsdlInfo(),
          ],
        ],
      ),
    );
  }
}

class _DropdownTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DropdownTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 12, 12),
        decoration: BoxDecoration(
          border: Border.all(color: Ucolors.outlineVariant),
          borderRadius: BorderRadius.circular(12),
          color: Ucolors.surfaceBright,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: UTextStyles.bodyMedium.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Ucolors.onSurfaceVariant,
                      letterSpacing: 0.24,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: UTextStyles.bodyMedium.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Ucolors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.expand_more, color: Ucolors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CARD 3 – DURATION
// ─────────────────────────────────────────────
class _DurationCard extends StatelessWidget {
  final PersonalisationController ctrl;
  const _DurationCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Duration',
            style: UTextStyles.bodyMedium.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Ucolors.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 3.0,
              children: List.generate(ctrl.durations.length, (i) {
                final isActive = ctrl.selectedDuration.value == i;
                final isCustom = i == 3;
                return _DurationButton(
                  label: ctrl.durations[i],
                  isActive: isActive,
                  showIcon: isCustom,
                  onTap: () => ctrl.selectDuration(i),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _DurationButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool showIcon;
  final VoidCallback onTap;

  const _DurationButton({
    required this.label,
    required this.isActive,
    this.showIcon = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: isActive ? Ucolors.primaryContainer : Ucolors.surfaceBright,
          border: Border.all(
            color: isActive ? Ucolors.primaryContainer : Ucolors.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showIcon) ...[
              Icon(
                Icons.calendar_month_outlined,
                size: 16,
                color: isActive ? Ucolors.onPrimary : Ucolors.onSurface,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: UTextStyles.bodyMedium.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isActive ? Ucolors.onPrimary : Ucolors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  INFO BANNER
// ─────────────────────────────────────────────
class _InfoBanner extends StatelessWidget {
  final String email;

  const _InfoBanner({super.key, required this.email});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Ucolors.infoBanner,
        border: Border.all(color: Ucolors.infoBannerBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.mark_email_unread,
            color: Ucolors.primaryContainer,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: UTextStyles.bodyMedium.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Ucolors.primaryContainer,
                  height: 1.43,
                ),
                children: [
                  TextSpan(
                    text:
                        'Statement will be sent securely to your registered email address ',
                    // address ending in ',
                  ),
                  TextSpan(
                    text: email,
                    style: UTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: '.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  BOTTOM ACTION BAR
// ─────────────────────────────────────────────
class _BottomActionBar extends StatelessWidget {
  final PersonalisationController ctrl;
  const _BottomActionBar({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        16 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Ucolors.surfaceContainerLowest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              icon: Icons.download_outlined,
              label: 'Download',
              filled: true,
              onTap: ctrl.onDownload,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ActionButton(
              icon: Icons.mail_outline,
              label: 'Email',
              filled: false,
              onTap: ctrl.onEmail,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: filled ? Ucolors.primaryContainer : Colors.transparent,
            border: filled ? null : Border.all(color: Ucolors.outlineVariant),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: filled
                    ? Ucolors.onPrimaryContainer
                    : Ucolors.onSecondaryContainer,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.24,
                  color: filled
                      ? Ucolors.onPrimaryContainer
                      : Ucolors.onSecondaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  SHARED WIDGETS
// ─────────────────────────────────────────────
class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Ucolors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Ucolors.surfaceVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _FloatingLabelField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;

  const _FloatingLabelField({
    required this.label,
    required this.controller,
    this.inputFormatters,
  });

  @override
  State<_FloatingLabelField> createState() => _FloatingLabelFieldState();
}

class _FloatingLabelFieldState extends State<_FloatingLabelField> {
  final _focus = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() => _focused = _focus.hasFocus));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        border: Border.all(
          color: _focused ? Ucolors.primary : Ucolors.outlineVariant,
          width: _focused ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: Ucolors.surfaceBright,
        boxShadow: _focused
            ? [
                BoxShadow(
                  color: Ucolors.onSurfaceVariant.withOpacity(0.2),
                  blurRadius: 0,
                  spreadRadius: 3,
                ),
              ]
            : null,
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focus,
        textCapitalization: TextCapitalization.characters,
        inputFormatters: widget.inputFormatters,
        // style: const TextStyle(
        //   fontFamily: 'Inter',
        //   fontSize: 16,
        //   fontWeight: FontWeight.w400,
        //   color: Ucolors.onSurface,
        // ),
        style: UTextStyles.sectionHeading.copyWith(fontSize: 16),

        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: UTextStyles.bodyMedium.copyWith(
            fontSize: _focused || widget.controller.text.isNotEmpty ? 12 : 16,
            color: _focused ? Ucolors.primary : Ucolors.onSurfaceVariant,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
        ),
      ),
    );
  }
}

class _NsdlInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.info_outline, size: 14, color: Ucolors.onSurfaceVariant),
        SizedBox(width: 4),
        Text(
          'Verified securely via NSDL',
          style: UTextStyles.bodyMedium.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Ucolors.onSurfaceVariant,
            letterSpacing: 0.24,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  TEXT FORMATTER
// ─────────────────────────────────────────────
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}

// ─────────────────────────────────────────────
//  CUSTOM DATE SELECTOR WIDGETS
// ─────────────────────────────────────────────
class _CustomDateSelector extends StatelessWidget {
  final PersonalisationController ctrl;
  const _CustomDateSelector({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Obx(
            () => _DateTile(
              label: 'Start Date',
              value: ctrl.formatDate(ctrl.startDate.value),
              onTap: () => ctrl.pickDate(context, true),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Obx(
            () => _DateTile(
              label: 'End Date',
              value: ctrl.formatDate(ctrl.endDate.value),
              onTap: () => ctrl.pickDate(context, false),
            ),
          ),
        ),
      ],
    );
  }
}

class _DateTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DateTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
        decoration: BoxDecoration(
          border: Border.all(color: Ucolors.outlineVariant),
          borderRadius: BorderRadius.circular(12),
          color: Ucolors.surfaceBright,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Ucolors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: value == 'DD/MM/YYYY'
                          ? Ucolors.outline
                          : Ucolors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.calendar_month_outlined,
              size: 18,
              color: Ucolors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
