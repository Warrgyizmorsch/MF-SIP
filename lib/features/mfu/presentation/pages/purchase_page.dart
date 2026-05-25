/*
// import 'dart:math' as math;
// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:my_sip/common/widget/animated/custom_footer.dart';
// import 'package:my_sip/common/widget/images/custom_cached_image.dart';
// import 'package:my_sip/core/utils/constant/colors.dart';

// import 'package:my_sip/features/mfu/data/model/normal_txn_req_model.dart';
// import 'package:my_sip/features/mfu/data/model/systematic_txn_req_model.dart';
// import 'package:my_sip/features/mfu/presentation/controller/mfu_controller.dart';
// import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';
// import 'package:my_sip/services/session_manager.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // Colors
// // ─────────────────────────────────────────────────────────────────────────────
// class _C {
//   static const bg = Color(0xFFEEF2FF);
//   static const surface = Color(0xFFFFFFFF);
//   static const pLight = Color(0xFFEFF4FF);
//   static const pMid = Color(0xFFBFD4FF);
//   static const primary = Color(0xFF2563EB);
//   static const success = Color(0xFF10B981);
//   static const danger = Color(0xFFEF4444);
//   static const textPrimary = Color(0xFF0F172A);
//   static const textSec = Color(0xFF64748B);
//   static const textMuted = Color(0xFFADB8CC);
//   static const border = Color(0xFFE2E9F6);
//   static const shadow = Color(0x1A2563EB);
//   static const stepBg = Color(0xFFEAF5FF);
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Investment Type Enum
// // ─────────────────────────────────────────────────────────────────────────────
// enum InvType { sip, lumpsum, stepup }

// enum SipFrequency { daily, weekly, monthly }

// extension SipFreqX on SipFrequency {
//   String get label => switch (this) {
//     SipFrequency.daily => 'Daily',
//     SipFrequency.weekly => 'Weekly',
//     SipFrequency.monthly => 'Monthly',
//   };
// }

// extension InvTypeX on InvType {
//   String get label => switch (this) {
//     InvType.sip => 'SIP',
//     InvType.lumpsum => 'Lumpsum',
//     InvType.stepup => 'Step Up',
//   };
//   IconData get icon => switch (this) {
//     InvType.sip => Icons.repeat_rounded,
//     InvType.lumpsum => Icons.bolt_rounded,
//     InvType.stepup => Icons.trending_up_rounded,
//   };
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Route Args
// // ─────────────────────────────────────────────────────────────────────────────
// class SipPurchaseArgs {
//   final String schemeCode;
//   final String fundName;
//   final String? imgUrl;

//   final String? folio;
//   final String riskLabel;
//   final String category;

//   /// Minimum amounts from the API
//   final int minSip;
//   final int minLumpsum;
//   final int minTopup;

//   const SipPurchaseArgs({
//     required this.schemeCode,
//     required this.fundName,

//     this.imgUrl,
//     this.folio,
//     this.riskLabel = 'Very High Risk',
//     this.category = 'Equity • Flexi Cap',
//     this.minSip = 500,
//     this.minLumpsum = 1000,
//     this.minTopup = 500,
//   });
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Page
// // ─────────────────────────────────────────────────────────────────────────────
// class SIPPurchasePage extends StatefulWidget {
//   const SIPPurchasePage({super.key});

//   @override
//   State<SIPPurchasePage> createState() => _SIPPurchasePageState();
// }

// class _SIPPurchasePageState extends State<SIPPurchasePage>
//     with TickerProviderStateMixin {
//   // ── Route args & controller ─────────────────────────────────────────────────
//   late final SipPurchaseArgs _args;
//   late final MfuController _mfu;
//   final PersonalisationController personalisationController =
//       Get.find<PersonalisationController>();

//   // ── Investment state ────────────────────────────────────────────────────────
//   InvType _invType = InvType.sip;
//   int _amount = 0;
//   int _sipDay = 16;

//   SipFrequency _sipFreq = SipFrequency.monthly;
//   int _sipWeekDay = 1; // 1 = Monday
//   final List<String> _weekDays = [
//     'Monday',
//     'Tuesday',
//     'Wednesday',
//     'Thursday',
//     'Friday',
//   ];

//   // Step-up specific
//   int _stepUpAmt = 0; // amount step-up
//   int _stepUpPct = 10; // percentage step-up
//   bool _stepByPct = false;
//   String _frequency = '6'; // '6' = half-yearly, '12' = yearly

//   // Cap limit (step-up)
//   bool _capByDate = true;
//   DateTime? _capDate;
//   int _capAmount = 0;

//   // validation
//   String? _amountError;
//   String? _stepUpError;
//   String? _capError;

//   // ── Animations ──────────────────────────────────────────────────────────────
//   late final AnimationController _entryCtrl;
//   late final AnimationController _pulseCtrl;
//   late final AnimationController _rippleCtrl;
//   late final Animation<double> _fade;
//   late final Animation<Offset> _slide;
//   late final Animation<double> _pulse;

//   // ────────────────────────────────────────────────────────────────────────────
//   @override
//   void initState() {
//     super.initState();

//     _args =
//         Get.arguments as SipPurchaseArgs? ??
//         const SipPurchaseArgs(
//           schemeCode: 'LQAG',
//           fundName: 'ITI Flexi Cap Fund Regular - Growth',
//         );

//     _mfu = Get.find<MfuController>();
//     _amount = _args.minSip;
//     _stepUpAmt = _args.minTopup;
//     _capAmount = _args.minSip + _args.minTopup + 100;

//     _entryCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     )..forward();
//     _pulseCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1800),
//     )..repeat(reverse: true);
//     _rippleCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2400),
//     )..repeat();

//     _fade = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
//     _slide = Tween<Offset>(
//       begin: const Offset(0, 0.2),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));
//     _pulse = Tween<double>(
//       begin: 1.0,
//       end: 1.032,
//     ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
//   }

//   @override
//   void dispose() {
//     _entryCtrl.dispose();
//     _pulseCtrl.dispose();
//     _rippleCtrl.dispose();
//     super.dispose();
//   }

//   // ── Helpers ──────────────────────────────────────────────────────────────────

//   int get _currentMin => switch (_invType) {
//     InvType.sip => _args.minSip,
//     InvType.lumpsum => _args.minLumpsum,
//     InvType.stepup => _args.minSip,
//   };

//   bool get _isValid {
//     if (_amountError != null) return false;
//     if (_invType == InvType.stepup) {
//       if (_stepUpError != null) return false;
//       if (_capError != null) return false;
//     }
//     return true;
//   }

//   void _onTypeChanged(InvType t) {
//     setState(() {
//       _invType = t;
//       _amountError = null;
//       _stepUpError = null;
//       _capError = null;
//       _amount = switch (t) {
//         InvType.lumpsum => _args.minLumpsum,
//         _ => _args.minSip,
//       };
//     });
//   }

//   void _addAmount(int v) {
//     HapticFeedback.lightImpact();
//     setState(() {
//       _amount += v;
//       _amountError = _validateAmount(_amount);
//     });
//   }

//   String? _validateAmount(int v) {
//     if (v < _currentMin) return 'Min ₹$_currentMin';
//     if (v % 100 != 0) return 'Must be a multiple of ₹100';
//     return null;
//   }

//   String? _validateStepUp() {
//     if (_stepByPct) {
//       if (_stepUpPct <= 0) return 'Min 1%';
//       if (_stepUpPct > 100) return 'Max 100%';
//     } else {
//       if (_stepUpAmt < _args.minTopup) return 'Min ₹${_args.minTopup}';
//       if (_stepUpAmt % 100 != 0) return 'Multiple of ₹100';
//     }
//     return null;
//   }

//   String? _validateCap() {
//     if (_capByDate) {
//       if (_capDate == null) return 'Select an end date';
//       if (_capDate!.isBefore(DateTime.now())) return 'Date must be in future';
//     } else {
//       final minCap = _args.minSip + _args.minTopup;
//       if (_capAmount <= minCap) return 'Must be > ₹$minCap';
//       if (_capAmount % 100 != 0) return 'Multiple of ₹100';
//     }
//     return null;
//   }

//   /// Formats the SIP Day/Date according to MFU Systematic Transaction Rules
//   String _formatMfuSipDay() {
//     switch (_sipFreq) {
//       case SipFrequency.daily:
//         // Rule 1: For Daily Frequency, the dates shall not be specified (Blank).
//         return "NA";

//       case SipFrequency.weekly:
//         // Rule 2: For Weekly DAY based Frequency, 1-Monday, 2-Tuesday..., 5-Friday.
//         // Assuming _sipWeekDay is 1-5.
//         return _sipWeekDay.toString();

//       case SipFrequency.monthly:
//         // Rule 5: For other frequencies, dates separated by slash.
//         // Since your UI currently selects a single date (e.g. 15), we just pass "15".
//         // Note: If you ever add a feature to let users pick multiple dates (e.g., 5th and 15th),
//         // you would join them like this: "5/15"

//         // Handling the "Last Working Date" (LD) edge case
//         if (_sipDay == 28 && DateTime.now().month == 2) {
//           // Optional: If you want to map a specific logic to "LD"
//           // return "LD";
//         }
//         return _sipDay
//             .toString(); // MFU spec example: "2", "8", "15" (no zero-padding required here)

//       default:
//         return "";
//     }
//   }

//   void _onInvest() {
//     // 1. Run all validations
//     final aErr = _validateAmount(_amount);
//     final sErr = _invType == InvType.stepup ? _validateStepUp() : null;
//     final cErr = _invType == InvType.stepup ? _validateCap() : null;

//     setState(() {
//       _amountError = aErr;
//       _stepUpError = sErr;
//       _capError = cErr;
//     });

//     if (aErr != null || sErr != null || cErr != null) return;

//     HapticFeedback.mediumImpact();

//     // 2. Fetch User Identifiers
//     final uid = SessionManager.instance.getUserData?.id ?? 0;
//     final can = SessionManager.instance.getUserData?.canNumber ?? '';
//     final folio = _args.folio;

//     // 3. Route to the correct API based on Investment Type
//     // if (_invType == InvType.sip || _invType == InvType.stepup) {
//     //   // Calculate dynamic SIP dates (Starts next month, runs for 30 years by default)
//     //   final now = DateTime.now();
//     //   final startDate = DateTime(now.year, now.month + 1, _sipDay);
//     //   final endDate = DateTime(
//     //     startDate.year + 30,
//     //     startDate.month,
//     //     startDate.day,
//     //   );

//     //   // Map your UI frequency to the API's expected string
//     //   String freqCode = 'M'; // Default Monthly
//     //   if (_sipFreq == SipFrequency.weekly) freqCode = 'W';
//     //   if (_sipFreq == SipFrequency.daily) freqCode = 'D';

//     //   // Call the Systematic Transaction API
//     //   _mfu.systematicTransaction(
//     //     MfuSystematicTxnRequest.sip(
//     //       uid: uid,
//     //       can: '14167AZA01',
//     //       schemeCode: '012',
//     //       folio: "FT000001115", // Pass empty string if new folio
//     //       amount: _amount,
//     //       frequency: freqCode,
//     //       day: _sipDay.toString().padLeft(2, '0'),
//     //       startMonth: startDate.month.toString().padLeft(2, '0'),
//     //       startYear: startDate.year.toString(),
//     //       endMonth: endDate.month.toString().padLeft(2, '0'),
//     //       endYear: endDate.year.toString(),

//     //       // ⚠️ TODO: Replace these hardcoded values with actual data from user's selected bank/mandate
//     //       paymentMode: "DM",
//     //       accType: "SB",
//     //       accNo: "654321",
//     //       ifsc: "ABHY0065002",
//     //       micr: "400065002",
//     //       mandateRefNo: "PRNUAT001",
//     //     ),
//     //   );
//     // 3. Route to the correct API based on Investment Type
//     if (_invType == InvType.sip || _invType == InvType.stepup) {
//       final now = DateTime.now();
//       DateTime startDate = DateTime(now.year, now.month + 1, _sipDay);

//       // MFU 30-Day Minimum Gap Rule (Prevents "Invalid Date" rejections)
//       if (startDate.difference(now).inDays < 30) {
//         startDate = DateTime(now.year, now.month + 2, _sipDay);
//       }
//       final endDate = DateTime(
//         startDate.year + 30,
//         startDate.month,
//         startDate.day,
//       );

//       // Map UI frequency to API string
//       String freqCode = 'M';
//       if (_sipFreq == SipFrequency.weekly) freqCode = 'W';
//       if (_sipFreq == SipFrequency.daily) freqCode = 'D';

//       // 🚀 THE FIX: Use the new MFU Spec formatter here
//       final mfuFormattedDay = _formatMfuSipDay();

//       _mfu.systematicTransaction(
//         MfuSystematicTxnRequest.sip(
//           uid: 7,
//           can: "14167AZA01",
//           schemeCode: _args.schemeCode,
//           // schemeCode: "012",
//           // folio: folio ?? "",
//           folio: "FT000001115",
//           amount: _amount,
//           frequency: freqCode,
//           // day: mfuFormattedDay,
//           day: "10",
//           startMonth: startDate.month.toString().padLeft(2, '0'),
//           startYear: startDate.year.toString(),
//           endMonth: endDate.month.toString().padLeft(2, '0'),
//           endYear: endDate.year.toString(),

//           paymentMode: "DM",
//           accType: "SB",
//           accNo: "654321",
//           ifsc: "ABHY0065002",
//           micr: "400065002",
//           mandateRefNo: "PRNUAT001",
//         ),
//       );
//     } else if (_invType == InvType.lumpsum) {
//       // Call the Normal Transaction API
//       // if (folio != null && folio.isNotEmpty) {
//       //   _mfu.normalTransaction(
//       //     MfuNormalTxnRequest.lumpsumExistingFolio(
//       //       uid: uid,
//       //       schemeCode: _args.schemeCode,
//       //       amount: _amount.toDouble(),
//       //       folio: folio,
//       //     ),
//       //   );
//       // }
//       //  else
//       {
//         _mfu.normalTransaction(
//           MfuNormalTxnRequest.lumpsumNewFolio(
//             uid: uid,
//             schemeCode: _args.schemeCode,
//             amount: _amount.toDouble(),
//           ),
//         );
//       }
//     }
//   }

//   // ── Build ─────────────────────────────────────────────────────────────────────
//   @override
//   Widget build(BuildContext context) {
//     final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.dark,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: Stack(
//           children: [
//             // _MeshBg(),
//             SafeArea(
//               child: Column(
//                 children: [
//                   FadeTransition(
//                     opacity: _fade,
//                     child: _TopBar(args: _args),
//                   ),
//                   Expanded(
//                     child: SlideTransition(
//                       position: _slide,
//                       child: FadeTransition(
//                         opacity: _fade,
//                         child: _buildBody(),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (!isKeyboardOpen)
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: Obx(
//                   () => _BottomCta(
//                     amount: _amount,
//                     invType: _invType,
//                     isLoading: _mfu.isSubmittingTxn.value,
//                     isValid: _isValid,
//                     onInvest: _onInvest,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBody() {
//     final user = personalisationController.userData.value;
//     return SingleChildScrollView(
//       padding: const EdgeInsets.fromLTRB(20, 8, 20, 90),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ── Fund card ──────────────────────────────────────────────────────
//           _FundCard(args: _args),
//           const SizedBox(height: 24),

//           // ── Investment type selector ───────────────────────────────────────
//           _InvTypeSelector(selected: _invType, onChanged: _onTypeChanged),
//           const SizedBox(height: 24),

//           // ── Amount section ─────────────────────────────────────────────────
//           _amountHeader(),
//           const SizedBox(height: 12),
//           _AmountCard(
//             amount: _amount,
//             pulse: _pulse,
//             onAdd: _addAmount,
//             error: _amountError,
//             onChanged: (v) => setState(() {
//               _amount = v;
//               _amountError = _validateAmount(v);
//             }),
//           ),
//           const SizedBox(height: 24),

//           // ── SIP Details (Daily / Weekly / Monthly) ─────────────────────────
//           if (_invType == InvType.sip || _invType == InvType.stepup) ...[
//             _sectionLabel('SIP DETAILS'),
//             const SizedBox(height: 12),

//             // 1. SIP Frequency Selector
//             _DetailTile(
//               onTap: _showFrequencyPicker,
//               icon: Icons.update_rounded,
//               iconColor: _C.primary,
//               label: 'SIP Frequency',
//               value: _sipFreq.label,
//               trailing: const _Chip(label: 'Change', color: _C.primary),
//             ),

//             // 2. Conditionally Show Date or Day Selector
//             if (_sipFreq != SipFrequency.daily) ...[
//               const SizedBox(height: 10),

//               if (_sipFreq == SipFrequency.monthly)
//                 _DetailTile(
//                   onTap: _pickSipDate,
//                   icon: Icons.calendar_month_rounded,
//                   iconColor: _C.primary,
//                   label: 'SIP Date',
//                   value: 'Monthly on ${_sipDay}th',
//                   trailing: _Chip(label: '${_sipDay}th', color: _C.primary),
//                 )
//               else if (_sipFreq == SipFrequency.weekly)
//                 _DetailTile(
//                   onTap: _showWeekDayPicker,
//                   icon: Icons.calendar_view_week_rounded,
//                   iconColor: _C.primary,
//                   label: 'SIP Day',
//                   value: 'Every ${_weekDays[_sipWeekDay - 1]}',
//                   trailing: _Chip(
//                     label: _weekDays[_sipWeekDay - 1]
//                         .substring(0, 3)
//                         .toUpperCase(),
//                     color: _C.primary,
//                   ),
//                 ),
//             ],
//             const SizedBox(height: 24), // Spacing before payment
//           ],

//           // ── Bank account tile (always visible) ─────────────────────────────
//           _sectionLabel('PAYMENT'),
//           const SizedBox(height: 12),
//           _DetailTile(
//             icon: Icons.account_balance_rounded,
//             iconColor: _C.success,
//             label: 'Bank Account',
//             value:
//                 '${user?.bankAccount?.bankName ?? ''}\n${user?.bankAccount?.accountNumberEncrypted ?? ''}',
//             badge: _Chip(label: 'Auto-pay', color: _C.success),
//           ),

//           // Folio tile (only existing folio)
//           if (_args.folio != null) ...[
//             const SizedBox(height: 10),
//             _DetailTile(
//               icon: Icons.folder_open_rounded,
//               iconColor: const Color(0xFF8B5CF6),
//               label: 'Folio',
//               value: _args.folio!,
//             ),
//           ],

//           // ── Step-up section (Preserved perfectly!) ─────────────────────────
//           if (_invType == InvType.stepup) ...[
//             const SizedBox(height: 24),
//             _StepUpSection(
//               stepUpAmt: _stepUpAmt,
//               stepUpPct: _stepUpPct,
//               byPct: _stepByPct,
//               frequency: _frequency, // '6' or '12'
//               capByDate: _capByDate,
//               capDate: _capDate,
//               capAmount: _capAmount,
//               minTopup: _args.minTopup,
//               minSip: _args.minSip,
//               stepUpError: _stepUpError,
//               capError: _capError,
//               onFreqChanged: (f) => setState(() => _frequency = f),
//               onByPctToggle: (v) => setState(() {
//                 _stepByPct = v;
//                 _stepUpError = null;
//               }),
//               onStepAmtChanged: (v) => setState(() {
//                 _stepUpAmt = v;
//                 _stepUpError = _validateStepUp();
//               }),
//               onStepPctChanged: (v) => setState(() {
//                 _stepUpPct = v;
//                 _stepUpError = _validateStepUp();
//               }),
//               onCapTypeToggle: (byDate) => setState(() {
//                 _capByDate = byDate;
//                 _capError = null;
//               }),
//               onCapDatePicked: (d) => setState(() {
//                 _capDate = d;
//                 _capError = _validateCap();
//               }),
//               onCapAmtChanged: (v) => setState(() {
//                 _capAmount = v;
//                 _capError = _validateCap();
//               }),
//             ),
//           ],

//           // ── Info banner ────────────────────────────────────────────────────
//           const SizedBox(height: 24),
//           _InfoBanner(invType: _invType),
//           const SizedBox(height: 8),
//           CustomFooter(),
//         ],
//       ),
//     );
//   }

//   void _showFrequencyPicker() {
//     FocusScope.of(context).unfocus();
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: _C.surface,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (ctx) => SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Select SIP Frequency',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w800,
//                   color: _C.textPrimary,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               ...SipFrequency.values.map(
//                 (f) => ListTile(
//                   contentPadding: EdgeInsets.zero,
//                   title: Text(
//                     f.label,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w600,
//                       color: _C.textPrimary,
//                     ),
//                   ),
//                   trailing: _sipFreq == f
//                       ? const Icon(
//                           Icons.check_circle_rounded,
//                           color: _C.primary,
//                         )
//                       : null,
//                   onTap: () {
//                     setState(() => _sipFreq = f);
//                     Navigator.pop(context);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showWeekDayPicker() {
//     FocusScope.of(context).unfocus();
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: _C.surface,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (ctx) => SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Select SIP Day',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w800,
//                   color: _C.textPrimary,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               ...List.generate(_weekDays.length, (index) {
//                 final dayIndex = index + 1; // 1-based index (Monday = 1)
//                 return ListTile(
//                   contentPadding: EdgeInsets.zero,
//                   title: Text(
//                     _weekDays[index],
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w600,
//                       color: _C.textPrimary,
//                     ),
//                   ),
//                   trailing: _sipWeekDay == dayIndex
//                       ? const Icon(
//                           Icons.check_circle_rounded,
//                           color: _C.primary,
//                         )
//                       : null,
//                   onTap: () {
//                     setState(() => _sipWeekDay = dayIndex);
//                     Navigator.pop(context);
//                   },
//                 );
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _pickSipDate() async {
//     final now = DateTime.now();
//     final initialDate = DateTime(
//       now.year,
//       now.month,
//       _sipDay > 28 ? 28 : _sipDay,
//     );

//     final picked = await showDatePicker(
//       context: context,
//       initialDate: initialDate.isBefore(now) ? now : initialDate,
//       firstDate: now,
//       lastDate: DateTime(now.year + 2),
//       selectableDayPredicate: (DateTime date) => date.day <= 28,
//       builder: (ctx, child) => Theme(
//         data: Theme.of(ctx).copyWith(
//           colorScheme: const ColorScheme.light(
//             primary: _C.primary,
//             onPrimary: Colors.white,
//             onSurface: _C.textPrimary,
//           ),
//           textButtonTheme: TextButtonThemeData(
//             style: TextButton.styleFrom(foregroundColor: _C.primary),
//           ),
//         ),
//         child: child!,
//       ),
//     );

//     if (picked != null) {
//       setState(() => _sipDay = picked.day);
//     }
//   }

//   Widget _amountHeader() => Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Text(
//         _invType == InvType.lumpsum
//             ? 'One-time Investment'
//             : 'Monthly SIP Amount',
//         style: const TextStyle(
//           color: _C.textSec,
//           fontSize: 13,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       _Chip(label: 'Min ₹$_currentMin', color: _C.primary),
//     ],
//   );

//   Widget _sectionLabel(String t) => Text(
//     t,
//     style: const TextStyle(
//       color: _C.textMuted,
//       fontSize: 11,
//       fontWeight: FontWeight.w700,
//       letterSpacing: 1.1,
//     ),
//   );
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Investment Type Selector
// // ─────────────────────────────────────────────────────────────────────────────
// class _InvTypeSelector extends StatelessWidget {
//   final InvType selected;
//   final ValueChanged<InvType> onChanged;
//   const _InvTypeSelector({required this.selected, required this.onChanged});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(5),
//       decoration: BoxDecoration(
//         color: _C.surface,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: _C.border),
//         boxShadow: const [
//           BoxShadow(color: _C.shadow, blurRadius: 12, offset: Offset(0, 4)),
//         ],
//       ),
//       child: Row(
//         children: InvType.values.map((t) {
//           final active = t == selected;
//           return Expanded(
//             child: GestureDetector(
//               onTap: () => onChanged(t),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 curve: Curves.easeOutCubic,
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 decoration: BoxDecoration(
//                   // gradient: active ? Ucolors.icicibankGradient : null,
//                   color: active ? Ucolors.primary : null,
//                   borderRadius: BorderRadius.circular(13),
//                   boxShadow: active
//                       ? [
//                           BoxShadow(
//                             color: _C.primary.withOpacity(0.3),
//                             blurRadius: 10,
//                             offset: const Offset(0, 4),
//                           ),
//                         ]
//                       : null,
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       t.icon,
//                       size: 18,
//                       color: active ? Colors.white : _C.textMuted,
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       t.label,
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: active ? FontWeight.w700 : FontWeight.w500,
//                         color: active ? Colors.white : _C.textSec,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Amount Card
// // ─────────────────────────────────────────────────────────────────────────────
// // ─────────────────────────────────────────────────────────────────────────────
// // Amount Card (Inline Editing)
// // ─────────────────────────────────────────────────────────────────────────────
// class _AmountCard extends StatefulWidget {
//   final int amount;
//   final Animation<double> pulse;
//   final Function(int) onAdd;
//   final String? error;
//   final ValueChanged<int> onChanged;

//   const _AmountCard({
//     required this.amount,
//     required this.pulse,
//     required this.onAdd,
//     required this.onChanged,
//     this.error,
//   });

//   @override
//   State<_AmountCard> createState() => _AmountCardState();
// }

// class _AmountCardState extends State<_AmountCard> {
//   late TextEditingController _ctrl;
//   late FocusNode _focusNode;

//   @override
//   void initState() {
//     super.initState();
//     _ctrl = TextEditingController(text: _fmt(widget.amount));
//     _focusNode = FocusNode();

//     // 🚀 UX Trick: Remove commas when focused for easy typing, add them back when done
//     _focusNode.addListener(() {
//       if (_focusNode.hasFocus) {
//         _ctrl.text = widget.amount == 0 ? '' : widget.amount.toString();
//         // Move cursor to the end
//         _ctrl.selection = TextSelection.collapsed(offset: _ctrl.text.length);
//       } else {
//         _ctrl.text = _fmt(widget.amount);
//       }
//     });
//   }

//   @override
//   void didUpdateWidget(covariant _AmountCard oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     // Sync external changes (like clicking the +100 buttons) into the text field
//     if (oldWidget.amount != widget.amount && !_focusNode.hasFocus) {
//       _ctrl.text = _fmt(widget.amount);
//     }
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }

//   String _fmt(int v) {
//     if (v == 0) return '0';
//     if (v >= 1000) {
//       final s = v.toString();
//       return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
//     }
//     return v.toString();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
//       decoration: BoxDecoration(
//         gradient: Ucolors.backgroundGradient,

//         borderRadius: BorderRadius.circular(24),
//       ),
//       child: Stack(
//         children: [
//           Positioned(
//             right: -20,
//             top: -20,
//             child: Container(
//               width: 100,
//               height: 100,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white.withOpacity(0.06),
//               ),
//             ),
//           ),
//           Positioned(
//             left: -30,
//             bottom: -30,
//             child: Container(
//               width: 120,
//               height: 120,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white.withOpacity(0.04),
//               ),
//             ),
//           ),
//           Column(
//             children: [
//               // 🚀 1. The Inline Editable Amount
//               ScaleTransition(
//                 scale: widget.pulse,
//                 child: GestureDetector(
//                   onTap: () => _focusNode.requestFocus(),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(bottom: 6.0),
//                             child: Text(
//                               '₹ ',
//                               style: TextStyle(
//                                 color: Colors.white.withOpacity(0.6),
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.w300,
//                               ),
//                             ),
//                           ),
//                           // IntrinsicWidth ensures the textfield perfectly wraps the typed numbers
//                           ConstrainedBox(
//                             constraints: const BoxConstraints(minWidth: 40),
//                             child: IntrinsicWidth(
//                               child: TextField(
//                                 controller: _ctrl,
//                                 focusNode: _focusNode,
//                                 keyboardType: TextInputType.number,
//                                 inputFormatters: [
//                                   FilteringTextInputFormatter.digitsOnly,
//                                 ],
//                                 textAlign: TextAlign.center,
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 56,
//                                   fontWeight: FontWeight.w900,
//                                   letterSpacing: -2,
//                                   height: 1,
//                                 ),
//                                 decoration: const InputDecoration(
//                                   border: InputBorder.none,
//                                   isDense: true,
//                                   contentPadding: EdgeInsets.zero,
//                                   hintText: '0',
//                                   hintStyle: TextStyle(color: Colors.white54),
//                                 ),
//                                 onChanged: (val) {
//                                   // Instantly update the parent state as they type
//                                   final v = int.tryParse(val) ?? 0;
//                                   widget.onChanged(v);
//                                 },
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'tap to edit',
//                             style: TextStyle(
//                               color: Colors.white.withOpacity(0.45),
//                               fontSize: 11,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           const SizedBox(width: 4),
//                           Icon(
//                             Icons.edit_rounded,
//                             size: 11,
//                             color: Colors.white.withOpacity(0.45),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               if (widget.error != null) ...[
//                 const SizedBox(height: 8),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: _C.danger.withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: _C.danger.withOpacity(0.3)),
//                   ),
//                   child: Text(
//                     widget.error!,
//                     style: const TextStyle(
//                       color: Color(0xFFFFB3B3),
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],

//               const SizedBox(height: 20),

//               // Quick-add chips
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   _AddBtn(label: '+₹100', onTap: () => widget.onAdd(100)),
//                   const SizedBox(width: 8),
//                   _AddBtn(
//                     label: '+₹500',
//                     onTap: () => widget.onAdd(500),
//                     highlight: true,
//                   ),
//                   const SizedBox(width: 8),
//                   _AddBtn(label: '+₹1,000', onTap: () => widget.onAdd(1000)),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _AddBtn extends StatelessWidget {
//   final String label;
//   final VoidCallback onTap;
//   final bool highlight;
//   const _AddBtn({
//     required this.label,
//     required this.onTap,
//     this.highlight = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
//         decoration: BoxDecoration(
//           color: highlight ? Colors.white : Colors.white.withOpacity(0.12),
//           borderRadius: BorderRadius.circular(11),
//           border: highlight
//               ? null
//               : Border.all(color: Colors.white.withOpacity(0.2)),
//           boxShadow: highlight
//               ? [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 8,
//                     offset: const Offset(0, 3),
//                   ),
//                 ]
//               : null,
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: highlight ? _C.primary : Colors.white,
//             fontSize: 12,
//             fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _SipDatePicker extends StatelessWidget {
//   final int selected;
//   final ValueChanged<int> onChanged;
//   const _SipDatePicker({required this.selected, required this.onChanged});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () async {
//         final now = DateTime.now();

//         // Ensure the initial date doesn't crash if 'selected' is somehow out of bounds
//         final initialDate = DateTime(
//           now.year,
//           now.month,
//           selected > 28 ? 28 : selected,
//         );

//         final picked = await showDatePicker(
//           context: context,
//           initialDate: initialDate.isBefore(now) ? now : initialDate,
//           firstDate: now,
//           lastDate: DateTime(
//             now.year + 2,
//           ), // Allow picking up to 2 years in advance
//           // Matches your previous logic: Restricts selection to the 1st - 28th
//           selectableDayPredicate: (DateTime date) {
//             return date.day <= 28;
//           },

//           // Theming the calendar to match your app's primary color
//           builder: (ctx, child) => Theme(
//             data: Theme.of(ctx).copyWith(
//               colorScheme: const ColorScheme.light(
//                 primary: _C.primary,
//                 onPrimary: Colors.white,
//                 onSurface: _C.textPrimary,
//               ),
//               textButtonTheme: TextButtonThemeData(
//                 style: TextButton.styleFrom(foregroundColor: _C.primary),
//               ),
//             ),
//             child: child!,
//           ),
//         );

//         // Extract just the 'day' integer and pass it back
//         if (picked != null) {
//           onChanged(picked.day);
//         }
//       },
//       child: _Chip(label: '${selected}th', color: _C.primary),
//     );
//   }
// }

// ─────────────────────────────────────────────────────────────────────────────
// Step-Up Section (mirrors CartPage logic exactly)
// ─────────────────────────────────────────────────────────────────────────────
*/


import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/animated/custom_footer.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/features/mfu/presentation/controller/mfu_controller.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';

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
            color: _C.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _C.stepBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _C.primary.withOpacity(0.12)),
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
              Divider(color: _C.primary.withOpacity(0.1)),
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
                    fontSize: 11,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
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
            fontSize: 11,
            fontWeight: FontWeight.w700,
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
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: _C.textPrimary,
          ),
          decoration: InputDecoration(
            prefixText: prefix != null ? '$prefix ' : null,
            prefixStyle: const TextStyle(color: _C.textSec, fontSize: 14),
            hintText: hint,
            hintStyle: const TextStyle(color: _C.textMuted),
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

// // ─────────────────────────────────────────────────────────────────────────────
// // Shared reusable widgets
// // ─────────────────────────────────────────────────────────────────────────────

// class _DetailTile extends StatelessWidget {
//   final IconData icon;
//   final Color iconColor;
//   final String label, value;
//   final Widget? badge, trailing;
//   final VoidCallback? onTap;

//   const _DetailTile({
//     required this.icon,
//     required this.iconColor,
//     required this.label,
//     required this.value,
//     this.badge,
//     this.trailing,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: _C.surface,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _C.border),
//         boxShadow: [
//           BoxShadow(
//             color: _C.shadow.withOpacity(0.5),
//             blurRadius: 10,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       // 🚀 3. Wrap with Material and InkWell for the ripple effect
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(16),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//             child: Row(
//               children: [
//                 Container(
//                   width: 42,
//                   height: 42,
//                   decoration: BoxDecoration(
//                     color: iconColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(icon, color: iconColor, size: 20),
//                 ),
//                 const SizedBox(width: 14),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         label,
//                         style: const TextStyle(
//                           color: _C.textMuted,
//                           fontSize: 11,
//                           fontWeight: FontWeight.w600,
//                           letterSpacing: 0.4,
//                         ),
//                       ),
//                       const SizedBox(height: 3),
//                       Text(
//                         value,
//                         style: const TextStyle(
//                           color: _C.textPrimary,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 if (badge != null) ...[badge!, const SizedBox(width: 8)],
//                 if (trailing != null) ...[trailing!, const SizedBox(width: 8)],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _Chip extends StatelessWidget {
//   final String label;
//   final Color color;
//   const _Chip({required this.label, required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: color.withOpacity(0.25)),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           color: color,
//           fontSize: 11,
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//     );
//   }
// }

// class _InfoBanner extends StatelessWidget {
//   final InvType invType;
//   const _InfoBanner({required this.invType});

//   String get _text => switch (invType) {
//     InvType.sip =>
//       'Your SIP will be automated with Auto-pay enabled. '
//           'The first installment is deducted today, subsequent ones on the selected date.',
//     InvType.lumpsum =>
//       'This is a one-time investment. The amount will be '
//           'deducted from your bank account immediately upon confirmation.',
//     InvType.stepup =>
//       'Your SIP amount will auto-increase as per the step-up '
//           'config. Auto-pay is enabled — no manual action needed each cycle.',
//   };

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
//       decoration: BoxDecoration(
//         color: _C.pLight,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _C.pMid.withOpacity(0.5)),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 34,
//             height: 34,
//             decoration: BoxDecoration(
//               color: _C.primary.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Icon(
//               Icons.verified_user_rounded,
//               color: _C.primary,
//               size: 18,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               _text,
//               style: const TextStyle(
//                 color: _C.textSec,
//                 fontSize: 13,
//                 height: 1.6,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Mesh background
// // ─────────────────────────────────────────────────────────────────────────────
// // ─────────────────────────────────────────────────────────────────────────────
// // Static Mesh background (Animation Removed)
// // ─────────────────────────────────────────────────────────────────────────────

// // Dynamic Risk Badge
// // ─────────────────────────────────────────────────────────────────────────────
// class _ModernRiskBadge extends StatelessWidget {
//   final String riskLabel;

//   const _ModernRiskBadge({required this.riskLabel});

//   Color _getRiskColor(String risk) {
//     final riskLower = risk.toLowerCase();
//     if (riskLower.contains('very high')) return _C.danger;
//     if (riskLower.contains('high')) return Colors.orange;
//     if (riskLower.contains('moderate')) return Colors.yellow.shade700;
//     if (riskLower.contains('low')) return _C.success;
//     return _C.textMuted;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final color = _getRiskColor(riskLabel);

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: color.withOpacity(0.2),
//         ), // Optional: Adds a nice crisp edge
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(right: 6),
//             child: Icon(Icons.speed_rounded, size: 14, color: color),
//           ),
//           Text(
//             riskLabel.toUpperCase(),
//             style: TextStyle(
//               color: color,
//               fontSize: 11,
//               fontWeight: FontWeight.w700,
//               letterSpacing: 0.5,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _TopBar extends StatelessWidget {
//   final SipPurchaseArgs args;
//   const _TopBar({required this.args});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: () {
//               HapticFeedback.selectionClick();
//               Get.back();
//             },
//             child: Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 color: _C.surface,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: _C.border),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: _C.shadow,
//                     blurRadius: 8,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: const Icon(
//                 Icons.arrow_back_ios_new_rounded,
//                 color: _C.textPrimary,
//                 size: 16,
//               ),
//             ),
//           ),
//           const SizedBox(width: 14),
//           const Text(
//             'Purchase Fund',
//             style: TextStyle(
//               color: _C.textPrimary,
//               fontSize: 20,
//               fontWeight: FontWeight.w800,
//               letterSpacing: -0.5,
//             ),
//           ),
//           const Spacer(),

//           // 🚀 REPLACED THE HARDCODED CONTAINER WITH THIS:
//           _ModernRiskBadge(riskLabel: args.riskLabel),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Fund card
// // ─────────────────────────────────────────────────────────────────────────────
// class _FundCard extends StatelessWidget {
//   final SipPurchaseArgs args;
//   const _FundCard({required this.args});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: _C.surface,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: _C.border),
//         boxShadow: const [
//           BoxShadow(color: _C.shadow, blurRadius: 20, offset: Offset(0, 6)),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(2),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(
//                 color: Colors.grey.shade200, // slightly darker for crisp edge
//                 width: 2,
//               ),
//             ),
//             child: ClipOval(
//               child: CustomCachedImage(
//                 imageUrl: args.imgUrl, // 🚀 Uses the URL from arguments
//                 height: 48,
//                 width: 48,
//               ),
//             ),
//           ),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   args.fundName,
//                   style: const TextStyle(
//                     color: _C.textPrimary,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w700,
//                     letterSpacing: -0.2,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   args.category,
//                   style: const TextStyle(
//                     color: _C.textSec,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Bottom CTA
// // ─────────────────────────────────────────────────────────────────────────────
// class _BottomCta extends StatelessWidget {
//   final int amount;
//   final InvType invType;
//   final bool isLoading, isValid;
//   final VoidCallback onInvest;
//   const _BottomCta({
//     required this.amount,
//     required this.invType,
//     required this.isLoading,
//     required this.isValid,
//     required this.onInvest,
//   });

//   String _fmt(int v) {
//     if (v >= 1000) {
//       final s = v.toString();
//       return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
//     }
//     return v.toString();
//   }

//   String get _label => switch (invType) {
//     InvType.sip => 'Start SIP  ₹${_fmt(amount)}/mo',
//     InvType.lumpsum => 'Invest ₹${_fmt(amount)}',
//     InvType.stepup => 'Start Step-Up SIP  ₹${_fmt(amount)}/mo',
//   };

//   @override
//   Widget build(BuildContext context) {
//     final canTap = isValid && !isLoading;
//     return ClipRRect(
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//         child: Container(
//           padding: EdgeInsets.fromLTRB(
//             20,
//             16,
//             20,
//             16 + MediaQuery.of(context).padding.bottom,
//           ),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.9),
//             border: const Border(top: BorderSide(color: _C.border)),
//             boxShadow: [
//               BoxShadow(
//                 color: _C.primary.withOpacity(0.07),
//                 blurRadius: 24,
//                 offset: const Offset(0, -6),
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               GestureDetector(
//                 onTap: canTap ? onInvest : null,
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 200),
//                   // height: 56,
//                   padding: EdgeInsets.symmetric(vertical: 15),
//                   decoration: BoxDecoration(
//                     gradient: canTap
//                         ? Ucolors.backgroundGradient
//                         : LinearGradient(
//                             colors: [
//                               Colors.grey.shade300,
//                               Colors.grey.shade400,
//                             ],
//                             begin: Alignment.centerLeft,
//                             end: Alignment.centerRight,
//                           ),

//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: canTap
//                         ? [
//                             BoxShadow(
//                               color: _C.primary.withOpacity(0.35),
//                               blurRadius: 18,
//                               offset: const Offset(0, 8),
//                             ),
//                           ]
//                         : [],
//                   ),
//                   child: Center(
//                     child: isLoading
//                         ? const SizedBox(
//                             width: 24,
//                             height: 24,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2.5,
//                               color: Colors.white,
//                             ),
//                           )
//                         : Text(
//                             _label,
//                             style: TextStyle(
//                               color: canTap
//                                   ? Colors.white
//                                   : Colors.grey.shade600,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w800,
//                               letterSpacing: -0.2,
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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

    // Initialise controller state from route args
    final args =
        Get.arguments as SipPurchaseArgs? ??
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
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
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
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
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

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  FadeTransition(
                    opacity: _fade,
                    child: Obx(() => _TopBar(args: _c.sipArgs.value)),
                  ),
                  Expanded(
                    child: SlideTransition(
                      position: _slide,
                      child: FadeTransition(
                        opacity: _fade,
                        child: _buildBody(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (!isKeyboardOpen)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Obx(
                  () => _BottomCta(
                    amount: _c.sipAmount.value,
                    invType: _c.sipInvType.value,
                    isLoading: _c.isSubmittingTxn.value,
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

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 90),
      child: Column(
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
            return _DetailTile(
              icon: Icons.account_balance_rounded,
              iconColor: _C.success,
              label: 'Bank Account',
              value:
                  '${user?.bankAccount?.bankName ?? ''}\n${user?.bankAccount?.accountNumberEncrypted ?? ''}',
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
          const SizedBox(height: 24),
          Obx(() => _InfoBanner(invType: _c.sipInvType.value)),
          const SizedBox(height: 8),
          CustomFooter(),
        ],
      ),
    );
  }

  Widget _amountHeader() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        _c.sipInvType.value == InvType.lumpsum
            ? 'One-time Investment'
            : 'Monthly SIP Amount',
        style: const TextStyle(
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
      color: _C.textMuted,
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.1,
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// UI Widgets below are UNCHANGED from original — pure presentation only
// ─────────────────────────────────────────────────────────────────────────────

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
                            color: _C.primary.withOpacity(0.3),
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
                        fontSize: 12,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w500,
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
                color: Colors.white.withOpacity(0.06),
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
                color: Colors.white.withOpacity(0.04),
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
                                color: Colors.white.withOpacity(0.6),
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
                                  color: Colors.white,
                                  fontSize: 56,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -2,
                                  height: 1,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  hintText: '0',
                                  hintStyle: TextStyle(color: Colors.white54),
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
                              color: Colors.white.withOpacity(0.45),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.edit_rounded,
                            size: 11,
                            color: Colors.white.withOpacity(0.45),
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
                    color: _C.danger.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _C.danger.withOpacity(0.3)),
                  ),
                  child: Text(
                    widget.error!,
                    style: const TextStyle(
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
          color: highlight ? Colors.white : Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(11),
          border: highlight
              ? null
              : Border.all(color: Colors.white.withOpacity(0.2)),
          boxShadow: highlight
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: highlight ? _C.primary : Colors.white,
            fontSize: 12,
            fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
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
            color: _C.shadow.withOpacity(0.5),
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
                    color: iconColor.withOpacity(0.1),
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
                          color: _C.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
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
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
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
        border: Border.all(color: _C.pMid.withOpacity(0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: _C.primary.withOpacity(0.1),
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
        color: c.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: c.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.speed_rounded, size: 14, color: c),
          const SizedBox(width: 6),
          Text(
            riskLabel.toUpperCase(),
            style: TextStyle(
              color: c,
              fontSize: 11,
              fontWeight: FontWeight.w700,
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
              Get.back();
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
              color: _C.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
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
                    color: _C.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  args.category,
                  style: const TextStyle(
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
            color: Colors.white.withOpacity(0.9),
            border: const Border(top: BorderSide(color: _C.border)),
            boxShadow: [
              BoxShadow(
                color: _C.primary.withOpacity(0.07),
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
                gradient: canTap
                    ? Ucolors.backgroundGradient
                    : LinearGradient(
                        colors: [Colors.grey.shade300, Colors.grey.shade400],
                      ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: canTap
                    ? [
                        BoxShadow(
                          color: _C.primary.withOpacity(0.35),
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
                          color: canTap ? Colors.white : Colors.grey.shade600,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
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

// Step-up section and its sub-widgets are purely presentational — unchanged.
// (_StepUpSection, _SegmentToggle, _SmallToggle, _NumberField,
//  _DatePickerField, _FieldWrap — copy as-is from the original file)
