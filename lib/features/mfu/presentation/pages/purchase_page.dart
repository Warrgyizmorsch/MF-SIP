import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/animated/custom_footer.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/features/mfu/presentation/controller/mfu_controller.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';

import '../../../../core/utils/constant/text_style.dart';

class _StepUpSection extends StatelessWidget {
  final int stepUpAmt;
  final int stepUpPct;
  final bool byPct;
  final String frequency;
  final bool capByDate;
  final DateTime? capDate;
  final int capAmount;
  final int minTopup;
  final int minSip;
  final String? stepUpError;
  final String? capError;

  final ValueChanged<String> onFreqChanged;
  final ValueChanged<bool> onByPctToggle;
  final ValueChanged<int> onStepAmtChanged;
  final ValueChanged<int> onStepPctChanged;
  final ValueChanged<bool> onCapTypeToggle;
  final ValueChanged<DateTime> onCapDatePicked;
  final ValueChanged<int> onCapAmtChanged;

  const _StepUpSection({
    required this.stepUpAmt,
    required this.stepUpPct,
    required this.byPct,
    required this.frequency,
    required this.capByDate,
    required this.capDate,
    required this.capAmount,
    required this.minTopup,
    required this.minSip,
    required this.stepUpError,
    required this.capError,
    required this.onFreqChanged,
    required this.onByPctToggle,
    required this.onStepAmtChanged,
    required this.onStepPctChanged,
    required this.onCapTypeToggle,
    required this.onCapDatePicked,
    required this.onCapAmtChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'STEP-UP CONFIG',
          style: TextStyle(
            fontFamily: FontFamily.medium,
            color: _C.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _C.stepBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _C.primary.withValues(alpha: 0.12)),
          ),
          child: Column(
            children: [
              // ── Row 1: Frequency + Step-up value ──────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Frequency
                  Expanded(
                    child: _FieldWrap(
                      label: 'Increase Every',
                      child: _SegmentToggle(
                        options: const {'6': '6 Months', '12': 'Yearly'},
                        selected: frequency,
                        onChanged: onFreqChanged,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Step-up by ₹ or %
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Increase By',
                              style: TextStyle(
                                fontFamily: FontFamily.medium,
                                color: _C.textSec,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            // ₹ / % toggle
                            _SmallToggle(
                              leftLabel: '₹',
                              rightLabel: '%',
                              rightSelected: byPct,
                              onChanged: onByPctToggle,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _NumberField(
                          value: byPct ? stepUpPct : stepUpAmt,
                          hint: byPct ? 'e.g. 10' : 'e.g. ${minTopup}',
                          error: stepUpError,
                          onChanged: (v) =>
                              byPct ? onStepPctChanged(v) : onStepAmtChanged(v),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Divider(color: _C.primary.withValues(alpha: 0.1)),
              const SizedBox(height: 16),

              // ── Row 2: Cap limit ──────────────────────────────────────────
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.flag_rounded,
                        size: 14,
                        color: _C.textSec,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Cap Limit',
                        style: TextStyle(
                          fontFamily: FontFamily.medium,
                          color: _C.textSec,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      _SmallToggle(
                        leftLabel: 'Date',
                        rightLabel: 'Amount',
                        rightSelected: !capByDate,
                        onChanged: (rightSelected) =>
                            onCapTypeToggle(!rightSelected),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (!capByDate) ...[
                    _NumberField(
                      value: capAmount,
                      hint: 'e.g. ${minSip + minTopup + 100}',
                      error: capError,
                      onChanged: onCapAmtChanged,
                      prefix: '₹',
                    ),
                  ] else ...[
                    _DatePickerField(
                      date: capDate,
                      error: capError,
                      onPicked: onCapDatePicked,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// // ─────────────────────────────────────────────────────────────────────────────
// // Small sub-widgets
// // ─────────────────────────────────────────────────────────────────────────────

class _SegmentToggle extends StatelessWidget {
  final Map<String, String> options;
  final String selected;
  final ValueChanged<String> onChanged;
  const _SegmentToggle({
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.border),
      ),
      child: Row(
        children: options.entries.map((e) {
          final active = e.key == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(e.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active ? _C.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  e.value,
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    fontSize: 11,
                    fontWeight: active ? FontWeight.w500 : FontWeight.w500,
                    color: active ? Colors.white : _C.textSec,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SmallToggle extends StatelessWidget {
  final String leftLabel, rightLabel;
  final bool rightSelected;
  final ValueChanged<bool> onChanged; // true = right selected
  const _SmallToggle({
    required this.leftLabel,
    required this.rightLabel,
    required this.rightSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn(leftLabel, !rightSelected, () => onChanged(false)),
          _btn(rightLabel, rightSelected, () => onChanged(true)),
        ],
      ),
    );
  }

  Widget _btn(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
          color: active ? _C.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: FontFamily.medium,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: active ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  final int value;
  final String hint;
  final String? error;
  final String? prefix;
  final ValueChanged<int> onChanged;
  const _NumberField({
    required this.value,
    required this.hint,
    required this.onChanged,
    this.error,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: TextEditingController(text: value.toString())
            ..selection = TextSelection.collapsed(
              offset: value.toString().length,
            ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: const TextStyle(
            fontFamily: FontFamily.medium,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _C.textPrimary,
          ),
          decoration: InputDecoration(
            prefixText: prefix != null ? '$prefix ' : null,
            prefixStyle: const TextStyle(
              fontFamily: FontFamily.medium,
              color: _C.textSec,
              fontSize: 14,
            ),
            hintText: hint,
            hintStyle: const TextStyle(
              fontFamily: FontFamily.medium,
              color: _C.textMuted,
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: error != null ? _C.danger : _C.border,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: error != null ? _C.danger : _C.border,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: error != null ? _C.danger : _C.primary,
                width: 2,
              ),
            ),
          ),
          onChanged: (v) => onChanged(int.tryParse(v) ?? 0),
        ),
        if (error != null) ...[
          const SizedBox(height: 4),
          Text(
            error!,
            style: const TextStyle(
              fontFamily: FontFamily.medium,
              color: _C.danger,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final DateTime? date;
  final String? error;
  final ValueChanged<DateTime> onPicked;
  const _DatePickerField({
    required this.date,
    required this.error,
    required this.onPicked,
  });

  @override
  Widget build(BuildContext context) {
    final label = date == null
        ? 'Select end date'
        : '${date!.day.toString().padLeft(2, '0')} / '
              '${date!.month.toString().padLeft(2, '0')} / ${date!.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            FocusScope.of(context).unfocus();
            final picked = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now().add(const Duration(days: 1)),
              firstDate: DateTime.now(),
              lastDate: DateTime(2060),
              builder: (ctx, child) => Theme(
                data: Theme.of(ctx).copyWith(
                  colorScheme: const ColorScheme.light(primary: _C.primary),
                ),
                child: child!,
              ),
            );
            if (picked != null) onPicked(picked);
          },
          child: Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: error != null ? _C.danger : _C.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    fontSize: 14,
                    color: date != null ? _C.textPrimary : _C.textMuted,
                    fontWeight: date != null
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
                const Icon(
                  Icons.calendar_month_outlined,
                  color: _C.textSec,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: 4),
          Text(
            error!,
            style: const TextStyle(
              fontFamily: FontFamily.medium,
              color: _C.danger,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

class _FieldWrap extends StatelessWidget {
  final String label;
  final Widget child;
  const _FieldWrap({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: FontFamily.medium,
            color: _C.textSec,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Colors (unchanged)
// ─────────────────────────────────────────────────────────────────────────────
class _C {
  static const bg = Color(0xFFEEF2FF);
  static const surface = Color(0xFFFFFFFF);
  static const pLight = Color(0xFFEFF4FF);
  static const pMid = Color(0xFFBFD4FF);
  static const primary = Color(0xFF2563EB);
  static const success = Color(0xFF10B981);
  static const danger = Color(0xFFEF4444);
  static const textPrimary = Color(0xFF0F172A);
  static const textSec = Color(0xFF64748B);
  static const textMuted = Color(0xFFADB8CC);
  static const border = Color(0xFFE2E9F6);
  static const shadow = Color(0x1A2563EB);
  static const stepBg = Color(0xFFEAF5FF);
}

// ─────────────────────────────────────────────────────────────────────────────
// Enums (unchanged — keep in shared file or here)
// ─────────────────────────────────────────────────────────────────────────────
enum InvType { sip, lumpsum, stepup }

enum SipFrequency { daily, weekly, monthly }

extension SipFreqX on SipFrequency {
  String get label => switch (this) {
    SipFrequency.daily => 'Daily',
    SipFrequency.weekly => 'Weekly',
    SipFrequency.monthly => 'Monthly',
  };
}

extension InvTypeX on InvType {
  String get label => switch (this) {
    InvType.sip => 'SIP',
    InvType.lumpsum => 'Lumpsum',
    InvType.stepup => 'Step Up',
  };
  IconData get icon => switch (this) {
    InvType.sip => Icons.repeat_rounded,
    InvType.lumpsum => Icons.bolt_rounded,
    InvType.stepup => Icons.trending_up_rounded,
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// Route Args (unchanged)
// ─────────────────────────────────────────────────────────────────────────────
class SipPurchaseArgs {
  final String schemeCode;
  final String fundName;
  final String? imgUrl;
  final String? folio;
  final String riskLabel;
  final String category;
  final int minSip;
  final int minLumpsum;
  final int minTopup;

  const SipPurchaseArgs({
    required this.schemeCode,
    required this.fundName,
    this.imgUrl,
    this.folio,
    this.riskLabel = 'Very High Risk',
    this.category = 'Equity • Flexi Cap',
    this.minSip = 500,
    this.minLumpsum = 1000,
    this.minTopup = 500,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Page — THIN VIEW: only UI + animation, zero business logic
// ─────────────────────────────────────────────────────────────────────────────
class SIPPurchasePage extends StatefulWidget {
  const SIPPurchasePage({super.key});

  static SipPurchaseArgs? tempData;

  @override
  State<SIPPurchasePage> createState() => _SIPPurchasePageState();
}

class _SIPPurchasePageState extends State<SIPPurchasePage>
    with TickerProviderStateMixin {
  // ── Controller ──────────────────────────────────────────────────────────────
  late final MfuController _c;

  // ── Animations (UI-only — stay in View) ────────────────────────────────────
  late final AnimationController _entryCtrl;
  late final AnimationController _pulseCtrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final Animation<double> _pulse;

  final List<String> _weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  @override
  void initState() {
    super.initState();

    _c = Get.find<MfuController>();

    final SipPurchaseArgs? passedArgs =
        SIPPurchasePage.tempData ?? Get.arguments as SipPurchaseArgs?;

    SIPPurchasePage.tempData = null;

    // Initialise controller state from route args
    // final args =
    //     Get.arguments as SipPurchaseArgs? ??
    //     const SipPurchaseArgs(
    //       schemeCode: 'LQAG',
    //       fundName: 'ITI Flexi Cap Fund Regular - Growth',
    //     );
    final args =
        passedArgs ??
        const SipPurchaseArgs(
          schemeCode: 'LQAG',
          fundName: 'ITI Flexi Cap Fund Regular - Growth',
        );
    _c.initSipPurchase(args);

    // Animations
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _fade = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));
    _pulse = Tween<double>(
      begin: 1.0,
      end: 1.032,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  // ── Pickers (UI concerns — stay in View) ─────────────────────────────────
  void _showFrequencyPicker() {
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
      context: context,
      backgroundColor: _C.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select SIP Frequency',
                style: TextStyle(
                  fontFamily: FontFamily.medium,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _C.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              ...SipFrequency.values.map(
                (f) => Obx(
                  () => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      f.label,
                      style: const TextStyle(
                        fontFamily: FontFamily.medium,
                        fontWeight: FontWeight.w600,
                        color: _C.textPrimary,
                      ),
                    ),
                    trailing: _c.sipFreq.value == f
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: _C.primary,
                          )
                        : null,
                    onTap: () {
                      _c.setSipFrequency(f);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWeekDayPicker() {
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
      context: context,
      backgroundColor: _C.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select SIP Day',
                style: TextStyle(
                  fontFamily: FontFamily.medium,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _C.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              ...List.generate(_weekDays.length, (index) {
                final dayIndex = index + 1;
                return Obx(
                  () => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      _weekDays[index],
                      style: const TextStyle(
                        fontFamily: FontFamily.medium,
                        fontWeight: FontWeight.w600,
                        color: _C.textPrimary,
                      ),
                    ),
                    trailing: _c.sipWeekDay.value == dayIndex
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: _C.primary,
                          )
                        : null,
                    onTap: () {
                      _c.setSipWeekDay(dayIndex);
                      Navigator.pop(context);
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickSipDate() async {
    final now = DateTime.now();
    final currentDay = _c.sipDay.value;
    final initialDate = DateTime(
      now.year,
      now.month,
      currentDay > 28 ? 28 : currentDay,
    );

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(now) ? now : initialDate,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      selectableDayPredicate: (d) => d.day <= 28,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: _C.primary,
            onPrimary: Colors.white,
            onSurface: _C.textPrimary,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: _C.primary),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) _c.setSipDay(picked.day);
  }

  // ── Responsive Build ─────────────────────────────────────────────────────────
  static const double _desktopBreakpoint = 900;
  static const double _desktopMaxWidth = 1180;

  bool _isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= _desktopBreakpoint;

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final isDesktop = _isDesktop(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Ucolors.white,
        body: Stack(
          children: [
            Positioned.fill(
              child: isDesktop
                  ? _buildDesktopScaffold()
                  : _buildMobileScaffold(),
            ),

            // Mobile-only sticky CTA. Desktop gets CTA in the right summary panel.
            if (!isDesktop && !isKeyboardOpen)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Obx(
                  () => _BottomCta(
                    amount: _c.sipAmount.value,
                    invType: _c.sipInvType.value,
                    isLoading: _c.isSubmittingAny,
                    isValid: _c.sipIsValid,
                    onInvest: _c.onSipInvest,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileScaffold() {
    return SafeArea(
      child: Column(
        children: [
          FadeTransition(
            opacity: _fade,
            child: Obx(() => _TopBar(args: _c.sipArgs.value)),
          ),
          Expanded(
            child: SlideTransition(
              position: _slide,
              child: FadeTransition(opacity: _fade, child: _buildBody()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopScaffold() {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          child: Column(
            children: [
              FadeTransition(
                opacity: _fade,
                child: Obx(() => _TopBar(args: _c.sipArgs.value)),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: SlideTransition(
                  position: _slide,
                  child: FadeTransition(
                    opacity: _fade,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: _DesktopPanel(
                            child: _buildBody(isDesktopLayout: true),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 4,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.only(bottom: 32),
                            child: Column(
                              children: [
                                _buildDesktopSummaryCard(),
                                const SizedBox(height: 18),
                                Obx(
                                  () =>
                                      _InfoBanner(invType: _c.sipInvType.value),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody({bool isDesktopLayout = false}) {
    return SingleChildScrollView(
      padding: isDesktopLayout
          ? const EdgeInsets.fromLTRB(26, 26, 26, 32)
          : const EdgeInsets.fromLTRB(20, 8, 20, 90),
      child: _buildFormContent(showFooter: !isDesktopLayout),
    );
  }

  Widget _buildFormContent({required bool showFooter}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fund card
        Obx(() => _FundCard(args: _c.sipArgs.value)),
        const SizedBox(height: 24),

        // Investment type selector
        Obx(
          () => _InvTypeSelector(
            selected: _c.sipInvType.value,
            onChanged: _c.onSipTypeChanged,
          ),
        ),
        const SizedBox(height: 24),

        // Amount header
        Obx(() => _amountHeader()),
        const SizedBox(height: 12),

        // Amount card
        Obx(
          () => _AmountCard(
            amount: _c.sipAmount.value,
            pulse: _pulse,
            onAdd: _c.onSipAddAmount,
            error: _c.sipAmountError.value,
            onChanged: _c.onSipAmountChanged,
          ),
        ),
        const SizedBox(height: 24),

        // SIP Details section
        Obx(() {
          final type = _c.sipInvType.value;
          if (type != InvType.sip && type != InvType.stepup) {
            return const SizedBox.shrink();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionLabel('SIP DETAILS'),
              const SizedBox(height: 12),

              // Frequency tile
              _DetailTile(
                onTap: _showFrequencyPicker,
                icon: Icons.update_rounded,
                iconColor: _C.primary,
                label: 'SIP Frequency',
                value: _c.sipFreq.value.label,
                trailing: const _Chip(label: 'Change', color: _C.primary),
              ),

              // Date / Day tile
              if (_c.sipFreq.value != SipFrequency.daily) ...[
                const SizedBox(height: 10),
                if (_c.sipFreq.value == SipFrequency.monthly)
                  _DetailTile(
                    onTap: _pickSipDate,
                    icon: Icons.calendar_month_rounded,
                    iconColor: _C.primary,
                    label: 'SIP Date',
                    value: 'Monthly on ${_c.sipDay.value}th',
                    trailing: _Chip(
                      label: '${_c.sipDay.value}th',
                      color: _C.primary,
                    ),
                  )
                else
                  _DetailTile(
                    onTap: _showWeekDayPicker,
                    icon: Icons.calendar_view_week_rounded,
                    iconColor: _C.primary,
                    label: 'SIP Day',
                    value: 'Every ${_weekDays[_c.sipWeekDay.value - 1]}',
                    trailing: _Chip(
                      label: _weekDays[_c.sipWeekDay.value - 1]
                          .substring(0, 3)
                          .toUpperCase(),
                      color: _C.primary,
                    ),
                  ),
              ],
              const SizedBox(height: 24),
            ],
          );
        }),

        // Payment section
        _sectionLabel('PAYMENT'),
        const SizedBox(height: 12),
        Obx(() {
          final user = Get.find<PersonalisationController>().userData.value;
          final primaryBank =
              (user?.bankAccounts != null && user!.bankAccounts!.isNotEmpty)
              ? user.bankAccounts!.first
              : null;
          return _DetailTile(
            icon: Icons.account_balance_rounded,
            iconColor: _C.success,
            label: 'Bank Account',
            value: primaryBank != null
                ? '${primaryBank.bankName ?? ''}\n${primaryBank.accountNumberEncrypted ?? ''}'
                : 'No bank linked',
            badge: const _Chip(label: 'Auto-pay', color: _C.success),
          );
        }),

        // Folio tile
        Obx(() {
          final folio = _c.sipArgs.value.folio;
          if (folio == null) return const SizedBox.shrink();
          return Column(
            children: [
              const SizedBox(height: 10),
              _DetailTile(
                icon: Icons.folder_open_rounded,
                iconColor: const Color(0xFF8B5CF6),
                label: 'Folio',
                value: folio,
              ),
            ],
          );
        }),

        // Step-up section
        Obx(() {
          if (_c.sipInvType.value != InvType.stepup) {
            return const SizedBox.shrink();
          }
          return Column(
            children: [
              const SizedBox(height: 24),
              _StepUpSection(
                stepUpAmt: _c.sipStepUpAmt.value,
                stepUpPct: _c.sipStepUpPct.value,
                byPct: _c.sipStepByPct.value,
                frequency: _c.sipFrequency.value,
                capByDate: _c.sipCapByDate.value,
                capDate: _c.sipCapDate.value,
                capAmount: _c.sipCapAmount.value,
                minTopup: _c.sipArgs.value.minTopup,
                minSip: _c.sipArgs.value.minSip,
                stepUpError: _c.sipStepUpError.value,
                capError: _c.sipCapError.value,
                onFreqChanged: _c.onSipFrequencyChanged,
                onByPctToggle: _c.onSipStepByPctToggle,
                onStepAmtChanged: _c.onSipStepAmtChanged,
                onStepPctChanged: _c.onSipStepPctChanged,
                onCapTypeToggle: _c.onSipCapTypeToggle,
                onCapDatePicked: _c.onSipCapDatePicked,
                onCapAmtChanged: _c.onSipCapAmtChanged,
              ),
            ],
          );
        }),

        // Info banner
        if (showFooter) ...[
          const SizedBox(height: 24),
          Obx(() => _InfoBanner(invType: _c.sipInvType.value)),
          const SizedBox(height: 8),
          CustomFooter(),
        ],
      ],
    );
  }

  Widget _buildDesktopSummaryCard() {
    return Obx(() {
      final type = _c.sipInvType.value;
      final amount = _c.sipAmount.value;
      final isLoading = _c.isSubmittingAny;
      final canTap = _c.sipIsValid && !isLoading;

      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: _C.border),
          boxShadow: [
            BoxShadow(
              color: _C.primary.withValues(alpha: 0.10),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: Ucolors.backgroundGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Investment Summary',
                        style: TextStyle(
                          fontFamily: FontFamily.medium,
                          color: _C.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.4,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Review before confirming',
                        style: TextStyle(
                          fontFamily: FontFamily.medium,
                          color: _C.textSec,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _summaryRow('Type', type.label),
            _summaryRow('Amount', '₹${_formatAmount(amount)}'),
            if (type != InvType.lumpsum)
              _summaryRow('Frequency', _c.sipFreq.value.label),
            if (type != InvType.lumpsum &&
                _c.sipFreq.value == SipFrequency.monthly)
              _summaryRow('Date', '${_c.sipDay.value}th of every month'),
            if (type != InvType.lumpsum &&
                _c.sipFreq.value == SipFrequency.weekly)
              _summaryRow('Day', _weekDays[_c.sipWeekDay.value - 1]),
            if (type == InvType.stepup)
              _summaryRow(
                'Step-up',
                _c.sipStepByPct.value
                    ? '${_c.sipStepUpPct.value}% every ${_c.sipFrequency.value == '6' ? '6 months' : 'year'}'
                    : '₹${_formatAmount(_c.sipStepUpAmt.value)} every ${_c.sipFrequency.value == '6' ? '6 months' : 'year'}',
              ),
            const SizedBox(height: 18),
            Divider(color: _C.border.withValues(alpha: 0.8)),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: canTap ? _c.onSipInvest : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: canTap
                      ? Ucolors.backgroundGradient
                      : LinearGradient(
                          colors: [Colors.grey.shade300, Colors.grey.shade400],
                        ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: canTap
                      ? [
                          BoxShadow(
                            color: _C.primary.withValues(alpha: 0.30),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          _desktopCtaLabel(type, amount),
                          style: TextStyle(
                            fontFamily: FontFamily.medium,
                            color: canTap ? Colors.white : Colors.grey.shade600,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: FontFamily.medium,
                color: _C.textSec,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: FontFamily.medium,
                color: _C.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _desktopCtaLabel(InvType type, int amount) => switch (type) {
    InvType.sip => 'Start SIP  ₹${_formatAmount(amount)}/mo',
    InvType.lumpsum => 'Invest ₹${_formatAmount(amount)}',
    InvType.stepup => 'Start Step-Up SIP  ₹${_formatAmount(amount)}/mo',
  };

  String _formatAmount(int v) {
    if (v >= 1000) {
      final s = v.toString();
      return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
    }
    return v.toString();
  }

  Widget _amountHeader() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        _c.sipInvType.value == InvType.lumpsum
            ? 'One-time Investment'
            : 'Monthly SIP Amount',
        style: const TextStyle(
          fontFamily: FontFamily.medium,
          color: _C.textSec,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      _Chip(label: 'Min ₹${_c.sipCurrentMin}', color: _C.primary),
    ],
  );

  Widget _sectionLabel(String t) => Text(
    t,
    style: const TextStyle(
      fontFamily: FontFamily.medium,
      color: _C.textMuted,
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.1,
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// UI Widgets below are UNCHANGED from original — pure presentation only
// ─────────────────────────────────────────────────────────────────────────────

class _DesktopPanel extends StatelessWidget {
  final Widget child;
  const _DesktopPanel({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: _C.border),
        boxShadow: [
          BoxShadow(
            color: _C.primary.withValues(alpha: 0.09),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

class _InvTypeSelector extends StatelessWidget {
  final InvType selected;
  final ValueChanged<InvType> onChanged;
  const _InvTypeSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _C.border),
        boxShadow: const [
          BoxShadow(color: _C.shadow, blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: InvType.values.map((t) {
          final active = t == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(t),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: active ? Ucolors.primary : null,
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: _C.primary.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      t.icon,
                      size: 18,
                      color: active ? Colors.white : _C.textMuted,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t.label,
                      style: TextStyle(
                        fontFamily: FontFamily.medium,
                        fontSize: 12,
                        fontWeight: active ? FontWeight.w500 : FontWeight.w500,
                        color: active ? Colors.white : _C.textSec,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _AmountCard extends StatefulWidget {
  final int amount;
  final Animation<double> pulse;
  final Function(int) onAdd;
  final String? error;
  final ValueChanged<int> onChanged;

  const _AmountCard({
    required this.amount,
    required this.pulse,
    required this.onAdd,
    required this.onChanged,
    this.error,
  });

  @override
  State<_AmountCard> createState() => _AmountCardState();
}

class _AmountCardState extends State<_AmountCard> {
  late TextEditingController _ctrl;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: _fmt(widget.amount));
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _ctrl.text = widget.amount == 0 ? '' : widget.amount.toString();
        _ctrl.selection = TextSelection.collapsed(offset: _ctrl.text.length);
      } else {
        _ctrl.text = _fmt(widget.amount);
      }
    });
  }

  @override
  void didUpdateWidget(covariant _AmountCard old) {
    super.didUpdateWidget(old);
    if (old.amount != widget.amount && !_focusNode.hasFocus) {
      _ctrl.text = _fmt(widget.amount);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _fmt(int v) {
    if (v == 0) return '0';
    if (v >= 1000) {
      final s = v.toString();
      return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
    }
    return v.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      decoration: BoxDecoration(
        gradient: Ucolors.backgroundGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Column(
            children: [
              ScaleTransition(
                scale: widget.pulse,
                child: GestureDetector(
                  onTap: () => _focusNode.requestFocus(),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              '₹ ',
                              style: TextStyle(
                                fontFamily: FontFamily.medium,
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 28,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          ConstrainedBox(
                            constraints: const BoxConstraints(minWidth: 40),
                            child: IntrinsicWidth(
                              child: TextField(
                                controller: _ctrl,
                                focusNode: _focusNode,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: FontFamily.medium,
                                  color: Colors.white,
                                  fontSize: 56,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -2,
                                  height: 1,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  hintText: '0',
                                  hintStyle: TextStyle(
                                    fontFamily: FontFamily.medium,
                                    color: Colors.white54,
                                  ),
                                ),
                                onChanged: (val) =>
                                    widget.onChanged(int.tryParse(val) ?? 0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'tap to edit',
                            style: TextStyle(
                              fontFamily: FontFamily.medium,
                              color: Colors.white.withValues(alpha: 0.45),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.edit_rounded,
                            size: 11,
                            color: Colors.white.withValues(alpha: 0.45),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.error != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _C.danger.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _C.danger.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    widget.error!,
                    style: const TextStyle(
                      fontFamily: FontFamily.medium,
                      color: Color(0xFFFFB3B3),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _AddBtn(label: '+₹100', onTap: () => widget.onAdd(100)),
                  const SizedBox(width: 8),
                  _AddBtn(
                    label: '+₹500',
                    onTap: () => widget.onAdd(500),
                    highlight: true,
                  ),
                  const SizedBox(width: 8),
                  _AddBtn(label: '+₹1,000', onTap: () => widget.onAdd(1000)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool highlight;
  const _AddBtn({
    required this.label,
    required this.onTap,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: highlight
              ? Colors.white
              : Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(11),
          border: highlight
              ? null
              : Border.all(color: Colors.white.withValues(alpha: 0.2)),
          boxShadow: highlight
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: FontFamily.medium,
            color: highlight ? _C.primary : Colors.white,
            fontSize: 12,
            fontWeight: highlight ? FontWeight.w600 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label, value;
  final Widget? badge, trailing;
  final VoidCallback? onTap;

  const _DetailTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.badge,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border),
        boxShadow: [
          BoxShadow(
            color: _C.shadow.withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontFamily: FontFamily.medium,
                          color: _C.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        value,
                        style: const TextStyle(
                          fontFamily: FontFamily.medium,
                          color: _C.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (badge != null) ...[badge!, const SizedBox(width: 8)],
                if (trailing != null) ...[trailing!, const SizedBox(width: 8)],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: FontFamily.medium,
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final InvType invType;
  const _InfoBanner({required this.invType});

  String get _text => switch (invType) {
    InvType.sip =>
      'Your SIP will be automated with Auto-pay enabled. '
          'The first installment is deducted today, subsequent ones on the selected date.',
    InvType.lumpsum =>
      'This is a one-time investment. The amount will be '
          'deducted from your bank account immediately upon confirmation.',
    InvType.stepup =>
      'Your SIP amount will auto-increase as per the step-up '
          'config. Auto-pay is enabled — no manual action needed each cycle.',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _C.pLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.pMid.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: _C.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.verified_user_rounded,
              color: _C.primary,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _text,
              style: const TextStyle(
                fontFamily: FontFamily.medium,
                color: _C.textSec,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModernRiskBadge extends StatelessWidget {
  final String riskLabel;
  const _ModernRiskBadge({required this.riskLabel});

  Color _color() {
    final r = riskLabel.toLowerCase();
    if (r.contains('very high')) return _C.danger;
    if (r.contains('high')) return Colors.orange;
    if (r.contains('moderate')) return Colors.yellow.shade700;
    if (r.contains('low')) return _C.success;
    return _C.textMuted;
  }

  @override
  Widget build(BuildContext context) {
    final c = _color();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: c.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.speed_rounded, size: 14, color: c),
          const SizedBox(width: 6),
          Text(
            riskLabel.toUpperCase(),
            style: TextStyle(
              fontFamily: FontFamily.medium,
              color: c,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final SipPurchaseArgs args;
  const _TopBar({required this.args});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              Navigator.pop(context);
              // Get.back();
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _C.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _C.border),
                boxShadow: const [
                  BoxShadow(
                    color: _C.shadow,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: _C.textPrimary,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Text(
            'Purchase Fund',
            style: TextStyle(
              fontFamily: FontFamily.medium,
              color: _C.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          _ModernRiskBadge(riskLabel: args.riskLabel),
        ],
      ),
    );
  }
}

class _FundCard extends StatelessWidget {
  final SipPurchaseArgs args;
  const _FundCard({required this.args});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _C.border),
        boxShadow: const [
          BoxShadow(color: _C.shadow, blurRadius: 20, offset: Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200, width: 2),
            ),
            child: ClipOval(
              child: CustomCachedImage(
                imageUrl: args.imgUrl,
                height: 48,
                width: 48,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  args.fundName,
                  style: const TextStyle(
                    fontFamily: FontFamily.medium,
                    color: _C.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  args.category,
                  style: const TextStyle(
                    fontFamily: FontFamily.medium,
                    color: _C.textSec,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomCta extends StatelessWidget {
  final int amount;
  final InvType invType;
  final bool isLoading, isValid;
  final VoidCallback onInvest;

  const _BottomCta({
    required this.amount,
    required this.invType,
    required this.isLoading,
    required this.isValid,
    required this.onInvest,
  });

  String _fmt(int v) {
    if (v >= 1000) {
      final s = v.toString();
      return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
    }
    return v.toString();
  }

  String get _label => switch (invType) {
    InvType.sip => 'Start SIP  ₹${_fmt(amount)}/mo',
    InvType.lumpsum => 'Invest ₹${_fmt(amount)}',
    InvType.stepup => 'Start Step-Up SIP  ₹${_fmt(amount)}/mo',
  };

  @override
  Widget build(BuildContext context) {
    final canTap = isValid && !isLoading;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            20,
            16,
            20,
            16 + MediaQuery.of(context).padding.bottom,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            border: const Border(top: BorderSide(color: _C.border)),
            boxShadow: [
              BoxShadow(
                color: _C.primary.withValues(alpha: 0.07),
                blurRadius: 24,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: canTap ? onInvest : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
            
                color: canTap ? Ucolors.primary : Ucolors.darkgrey,
                borderRadius: BorderRadius.circular(16),
                boxShadow: canTap
                    ? [
                        BoxShadow(
                          color: _C.primary.withValues(alpha: 0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _label,
                        style: TextStyle(
                          fontFamily: FontFamily.medium,
                          color: canTap ? Colors.white : Colors.grey.shade600,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

