// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
// import 'package:my_sip/core/utils/constant/colors.dart';
// import 'package:my_sip/core/utils/constant/text_style.dart';
// import 'package:my_sip/features/dashboard/presentation/pages/comparison_screen.dart';
// import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';

// class DownloadStatementsScreen extends GetView<PersonalisationController> {
//   const DownloadStatementsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.dark,
//       ),
//       child: Scaffold(
//         appBar: CustomAppBarNormal(
//           title: controller.isCapitalGain.value
//               ? 'Capital Gain'
//               : 'Download Statements',
//         ),

//         // ── Body ────────────────────────────────────
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//           child: Column(
//             children: [
//               // Card 1 – Statement Type
//               // _StatementTypeCard(ctrl: controller),
//               // const SizedBox(height: 16),
//               Obx(() {
//                 if (controller.isCapitalGain.value) {
//                   return SizedBox.shrink();

//                 } else {
//                   return Column(
//                     children: [
//                       _StatementTypeCard(ctrl: controller),
//                       const SizedBox(height: 16),
//                     ],
//                   );
//                 }
//               }),

//               // Card 2 – Input (PAN or Folio)
//               Obx(
//                 () => controller.statementTypeIndex.value == 0
//                     ? _PanInputCard(ctrl: controller)
//                     : _FolioInputCard(ctrl: controller),
//               ),
//               const SizedBox(height: 16),

//               // Card 3 – Duration
//               _DurationCard(ctrl: controller),
//               const SizedBox(height: 12),
//               Obx(() {
//                 if (controller.selectedDuration.value == 3) {
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 12.0),
//                     child: _CustomDateSelector(ctrl: controller),
//                   );
//                 }
//                 return const SizedBox.shrink(); // Takes up no space if not custom
//               }),

//               // Info Banner
//               _InfoBanner(email: controller.emailController.text),

//               // Bottom padding so content clears the bottom nav
//               const SizedBox(height: 100),
//             ],
//           ),
//         ),

//         bottomNavigationBar: SafeArea(
//           child: Container(
//             padding: const EdgeInsets.symmetric(vertical: 12),
//             decoration: BoxDecoration(color: Colors.grey.shade100),
//             child: Obx(() {

//               if (controller.isRequestingStatement.value ||
//                   controller.isRequestingAccountStatement.value) {
//                 return const Center(
//                   heightFactor: 1,
//                   child: Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: CircularProgressIndicator(),
//                   ),
//                 );
//               }

//               // Show your custom BottomBarButton when not loading
//               return BottomBarButton(
//                 firstButton: 'Download',
//                 secondButton: 'Email',
//                 firstButtonP: () {
//                   controller.onDownload();
//                 },
//                 secondButtonP: () {
//                   controller.onEmail();
//                 },
//               );
//             }),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// //  CARD 1 – STATEMENT TYPE
// // ─────────────────────────────────────────────
// class _StatementTypeCard extends StatelessWidget {
//   final PersonalisationController ctrl;
//   const _StatementTypeCard({required this.ctrl});

//   @override
//   Widget build(BuildContext context) {
//     return _Card(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Statement Via',
//             style: UTextStyles.sectionHeading.copyWith(fontSize: 16),
//           ),
//           const SizedBox(height: 12),
//           Obx(
//             () => Container(
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey.shade300),
//                 borderRadius: BorderRadius.circular(999),
//               ),
//               padding: const EdgeInsets.all(4),
//               child: Row(
//                 children: [
//                   _SegmentButton(
//                     label: 'PAN Number',
//                     isActive: ctrl.statementTypeIndex.value == 0,
//                     onTap: () => ctrl.selectStatementType(0),
//                   ),
//                   _SegmentButton(
//                     label: 'Folio Number',
//                     isActive: ctrl.statementTypeIndex.value == 1,
//                     onTap: () => ctrl.selectStatementType(1),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _SegmentButton extends StatelessWidget {
//   final String label;
//   final bool isActive;
//   final VoidCallback onTap;

//   const _SegmentButton({
//     required this.label,
//     required this.isActive,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           padding: const EdgeInsets.symmetric(vertical: 10),
//           decoration: BoxDecoration(
//             color: isActive ? Ucolors.primaryContainer : Colors.transparent,
//             borderRadius: BorderRadius.circular(999),
//             boxShadow: isActive
//                 ? [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.12),
//                       blurRadius: 4,
//                       offset: const Offset(0, 2),
//                     ),
//                   ]
//                 : null,
//           ),
//           child: Text(
//             label,
//             textAlign: TextAlign.center,
//             style: UTextStyles.caption.copyWith(
//               color: isActive ? Ucolors.onPrimary : Ucolors.onSurfaceVariant,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// //  CARD 2a – PAN INPUT
// // ─────────────────────────────────────────────
// class _PanInputCard extends StatelessWidget {
//   final PersonalisationController ctrl;
//   const _PanInputCard({required this.ctrl});

//   @override
//   Widget build(BuildContext context) {
//     return _Card(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           IgnorePointer(
//             child: _FloatingLabelField(
//               label: 'PAN Number',
//               controller: ctrl.panController,

//               inputFormatters: [
//                 UpperCaseTextFormatter(),
//                 LengthLimitingTextInputFormatter(10),
//               ],
//             ),
//           ),
//           const SizedBox(height: 8),
//           _NsdlInfo(),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// //  CARD 2b – FOLIO INPUT
// // ─────────────────────────────────────────────
// class _FolioInputCard extends StatelessWidget {
//   final PersonalisationController ctrl;
//   const _FolioInputCard({required this.ctrl});

//   @override
//   Widget build(BuildContext context) {
//     return _Card(
//       child: Column(
//         children: [
//           Obx(
//             () => _DropdownTile(
//               label: 'Select Folio',
//               value: ctrl.selectedFolio.value,
//               onTap: () {
//               },
//             ),
//           ),

//         ],
//       ),
//     );
//   }
// }

// class _DropdownTile extends StatelessWidget {
//   final String label;
//   final String value;
//   final VoidCallback onTap;

//   const _DropdownTile({
//     required this.label,
//     required this.value,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         padding: const EdgeInsets.fromLTRB(16, 8, 12, 12),
//         decoration: BoxDecoration(
//           border: Border.all(color: Ucolors.outlineVariant),
//           borderRadius: BorderRadius.circular(12),
//           color: Ucolors.surfaceBright,
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     label,
//                     style: UTextStyles.bodyMedium.copyWith(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w500,
//                       color: Ucolors.onSurfaceVariant,
//                       letterSpacing: 0.24,
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     value,
//                     style: UTextStyles.bodyMedium.copyWith(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w400,
//                       color: Ucolors.onSurface,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Icon(Icons.expand_more, color: Ucolors.onSurfaceVariant),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// //  CARD 3 – DURATION
// // ─────────────────────────────────────────────
// class _DurationCard extends StatelessWidget {
//   final PersonalisationController ctrl;
//   const _DurationCard({required this.ctrl});

//   @override
//   Widget build(BuildContext context) {
//     return _Card(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Duration',
//             style: UTextStyles.bodyMedium.copyWith(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Ucolors.onSurface,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Obx(
//             () => GridView.count(
//               crossAxisCount: 2,
//               crossAxisSpacing: 8,
//               mainAxisSpacing: 8,
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               childAspectRatio: 3.0,
//               children: List.generate(ctrl.durations.length, (i) {
//                 final isActive = ctrl.selectedDuration.value == i;
//                 final isCustom = i == 3;
//                 return _DurationButton(
//                   label: ctrl.durations[i],
//                   isActive: isActive,
//                   showIcon: isCustom,
//                   onTap: () => ctrl.selectDuration(i),
//                 );
//               }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _DurationButton extends StatelessWidget {
//   final String label;
//   final bool isActive;
//   final bool showIcon;
//   final VoidCallback onTap;

//   const _DurationButton({
//     required this.label,
//     required this.isActive,
//     this.showIcon = false,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 180),
//         decoration: BoxDecoration(
//           color: isActive ? Ucolors.primaryContainer : Ucolors.surfaceBright,
//           border: Border.all(
//             color: isActive ? Ucolors.primaryContainer : Ucolors.outlineVariant,
//           ),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (showIcon) ...[
//               Icon(
//                 Icons.calendar_month_outlined,
//                 size: 16,
//                 color: isActive ? Ucolors.onPrimary : Ucolors.onSurface,
//               ),
//               const SizedBox(width: 6),
//             ],
//             Text(
//               label,
//               style: UTextStyles.bodyMedium.copyWith(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: isActive ? Ucolors.onPrimary : Ucolors.onSurface,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// //  INFO BANNER
// // ─────────────────────────────────────────────
// class _InfoBanner extends StatelessWidget {
//   final String email;

//   const _InfoBanner({super.key, required this.email});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Ucolors.infoBanner,
//         border: Border.all(color: Ucolors.infoBannerBorder),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Icon(
//             Icons.mark_email_unread,
//             color: Ucolors.primaryContainer,
//             size: 20,
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: RichText(
//               text: TextSpan(
//                 style: UTextStyles.bodyMedium.copyWith(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   color: Ucolors.primaryContainer,
//                   height: 1.43,
//                 ),
//                 children: [
//                   TextSpan(
//                     text:
//                         'Statement will be sent securely to your registered email address ',
//                     // address ending in ',
//                   ),
//                   TextSpan(
//                     text: email,
//                     style: UTextStyles.bodyMedium.copyWith(
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   TextSpan(text: '.'),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// //  BOTTOM ACTION BAR
// // ─────────────────────────────────────────────
// class _BottomActionBar extends StatelessWidget {
//   final PersonalisationController ctrl;
//   const _BottomActionBar({required this.ctrl});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.fromLTRB(
//         24,
//         16,
//         24,
//         16 + MediaQuery.of(context).padding.bottom,
//       ),
//       decoration: BoxDecoration(
//         color: Ucolors.surfaceContainerLowest,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 20,
//             offset: const Offset(0, -4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: _ActionButton(
//               icon: Icons.download_outlined,
//               label: 'Download',
//               filled: true,
//               onTap: ctrl.onDownload,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: _ActionButton(
//               icon: Icons.mail_outline,
//               label: 'Email',
//               filled: false,
//               onTap: ctrl.onEmail,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ActionButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool filled;
//   final VoidCallback onTap;

//   const _ActionButton({
//     required this.icon,
//     required this.label,
//     required this.filled,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(999),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 150),
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           decoration: BoxDecoration(
//             color: filled ? Ucolors.primaryContainer : Colors.transparent,
//             border: filled ? null : Border.all(color: Ucolors.outlineVariant),
//             borderRadius: BorderRadius.circular(999),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 icon,
//                 size: 22,
//                 color: filled
//                     ? Ucolors.onPrimaryContainer
//                     : Ucolors.onSecondaryContainer,
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontSize: 13,
//                   fontWeight: FontWeight.w500,
//                   letterSpacing: 0.24,
//                   color: filled
//                       ? Ucolors.onPrimaryContainer
//                       : Ucolors.onSecondaryContainer,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// //  SHARED WIDGETS
// // ─────────────────────────────────────────────
// class _Card extends StatelessWidget {
//   final Widget child;
//   const _Card({required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Ucolors.surfaceContainerLowest,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Ucolors.surfaceVariant),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 20,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }
// }

// class _FloatingLabelField extends StatefulWidget {
//   final String label;
//   final TextEditingController controller;
//   final List<TextInputFormatter>? inputFormatters;

//   const _FloatingLabelField({
//     required this.label,
//     required this.controller,
//     this.inputFormatters,
//   });

//   @override
//   State<_FloatingLabelField> createState() => _FloatingLabelFieldState();
// }

// class _FloatingLabelFieldState extends State<_FloatingLabelField> {
//   final _focus = FocusNode();
//   bool _focused = false;

//   @override
//   void initState() {
//     super.initState();
//     _focus.addListener(() => setState(() => _focused = _focus.hasFocus));
//   }

//   @override
//   void dispose() {
//     _focus.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 200),
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: _focused ? Ucolors.primary : Ucolors.outlineVariant,
//           width: _focused ? 1.5 : 1,
//         ),
//         borderRadius: BorderRadius.circular(12),
//         color: Ucolors.surfaceBright,
//         boxShadow: _focused
//             ? [
//                 BoxShadow(
//                   color: Ucolors.onSurfaceVariant.withOpacity(0.2),
//                   blurRadius: 0,
//                   spreadRadius: 3,
//                 ),
//               ]
//             : null,
//       ),
//       child: TextField(
//         controller: widget.controller,
//         focusNode: _focus,
//         textCapitalization: TextCapitalization.characters,
//         inputFormatters: widget.inputFormatters,
//         // style: const TextStyle(
//         //   fontFamily: 'Inter',
//         //   fontSize: 16,
//         //   fontWeight: FontWeight.w400,
//         //   color: Ucolors.onSurface,
//         // ),
//         style: UTextStyles.sectionHeading.copyWith(fontSize: 16),

//         decoration: InputDecoration(
//           labelText: widget.label,
//           labelStyle: UTextStyles.bodyMedium.copyWith(
//             fontSize: _focused || widget.controller.text.isNotEmpty ? 12 : 16,
//             color: _focused ? Ucolors.primary : Ucolors.onSurfaceVariant,
//           ),
//           floatingLabelBehavior: FloatingLabelBehavior.auto,
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
//         ),
//       ),
//     );
//   }
// }

// class _NsdlInfo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(Icons.info_outline, size: 14, color: Ucolors.onSurfaceVariant),
//         SizedBox(width: 4),
//         Text(
//           'Verified securely via NSDL',
//           style: UTextStyles.bodyMedium.copyWith(
//             fontSize: 13,
//             fontWeight: FontWeight.w500,
//             color: Ucolors.onSurfaceVariant,
//             letterSpacing: 0.24,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class UpperCaseTextFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//     TextEditingValue oldValue,
//     TextEditingValue newValue,
//   ) {
//     return newValue.copyWith(text: newValue.text.toUpperCase());
//   }
// }

// // ─────────────────────────────────────────────
// //  CUSTOM DATE SELECTOR WIDGETS
// // ─────────────────────────────────────────────
// class _CustomDateSelector extends StatelessWidget {
//   final PersonalisationController ctrl;
//   const _CustomDateSelector({required this.ctrl});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: Obx(
//             () => _DateTile(
//               label: 'Start Date',
//               value: ctrl.formatDate(ctrl.startDate.value),
//               onTap: () => ctrl.pickDate(context, true),
//             ),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Obx(
//             () => _DateTile(
//               label: 'End Date',
//               value: ctrl.formatDate(ctrl.endDate.value),
//               onTap: () => ctrl.pickDate(context, false),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _DateTile extends StatelessWidget {
//   final String label;
//   final String value;
//   final VoidCallback onTap;

//   const _DateTile({
//     required this.label,
//     required this.value,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
//         decoration: BoxDecoration(
//           border: Border.all(color: Ucolors.outlineVariant),
//           borderRadius: BorderRadius.circular(12),
//           color: Ucolors.surfaceBright,
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     label,
//                     style: const TextStyle(
//                       fontFamily: 'Inter',
//                       fontSize: 13,
//                       fontWeight: FontWeight.w500,
//                       color: Ucolors.onSurfaceVariant,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     value,
//                     style: TextStyle(
//                       fontFamily: 'Inter',
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                       color: value == 'DD/MM/YYYY'
//                           ? Ucolors.outline
//                           : Ucolors.onSurface,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Icon(
//               Icons.calendar_month_outlined,
//               size: 18,
//               color: Ucolors.onSurfaceVariant,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/dashboard/presentation/pages/comparison_screen.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';

class DownloadStatementsScreen extends GetView<PersonalisationController> {
  const DownloadStatementsScreen({super.key});

  static const double _desktopBreakpoint = 900;
  static bool? forcedIsCapitalMode;
  @override
  Widget build(BuildContext context) {
    if (forcedIsCapitalMode != null) {
      // Use microtask or postFrameCallback to avoid modifying state during build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.setStatementMode(isCapital: forcedIsCapitalMode!);
      });
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= _desktopBreakpoint;

          if (isDesktop) {
            return _DesktopDownloadStatementsLayout(ctrl: controller);
          }

          return _MobileDownloadStatementsLayout(ctrl: controller);
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  MOBILE LAYOUT – SAME AS ORIGINAL
// ─────────────────────────────────────────────
class _MobileDownloadStatementsLayout extends StatelessWidget {
  final PersonalisationController ctrl;
  const _MobileDownloadStatementsLayout({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNormal(
        title: ctrl.isCapitalGain.value
            ? 'Capital Gain'
            : 'Download Statements',
      ),

      // ── Body ────────────────────────────────────
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // Card 1 – Statement Type
            Obx(() {
              if (ctrl.isCapitalGain.value) {
                return const SizedBox.shrink();
              } else {
                return Column(
                  children: [
                    _StatementTypeCard(ctrl: ctrl),
                    const SizedBox(height: 16),
                  ],
                );
              }
            }),

            // Card 2 – Input (PAN or Folio)
            Obx(
              () => ctrl.statementTypeIndex.value == 0
                  ? _PanInputCard(ctrl: ctrl)
                  : _FolioInputCard(ctrl: ctrl),
            ),
            const SizedBox(height: 16),

            // Card 3 – Duration
            _DurationCard(ctrl: ctrl),
            const SizedBox(height: 12),
            Obx(() {
              if (ctrl.selectedDuration.value == 3) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _CustomDateSelector(ctrl: ctrl),
                );
              }
              return const SizedBox.shrink();
            }),

            // Info Banner
            _InfoBanner(email: ctrl.emailController.text),

            // Bottom padding so content clears the bottom nav
            const SizedBox(height: 100),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: Colors.grey.shade100),
          child: Obx(() {
            if (ctrl.isRequestingStatement.value ||
                ctrl.isRequestingAccountStatement.value) {
              return const Center(
                heightFactor: 1,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return BottomBarButton(
              firstButton: 'Download',
              secondButton: 'Email',
              firstButtonP: () {
                ctrl.onDownload();
              },
              secondButtonP: () {
                ctrl.onEmail();
              },
            );
          }),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  WEB / DESKTOP LAYOUT
// ─────────────────────────────────────────────
// ─────────────────────────────────────────────
//  WEB / DESKTOP LAYOUT - PIXEL STYLE
// ─────────────────────────────────────────────

class _DesktopDownloadStatementsLayout extends StatelessWidget {
  final PersonalisationController ctrl;

  const _DesktopDownloadStatementsLayout({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Ucolors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isLaptop = constraints.maxWidth < 1200;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                isLaptop ? 24 : 32,
                isLaptop ? 22 : 28,
                isLaptop ? 24 : 32,
                32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _WebStatementHeader(ctrl: ctrl),
                  const SizedBox(height: 26),
                  _WebStatementFormCard(ctrl: ctrl),
                  const SizedBox(height: 18),
                  _WebStatementPreviewCard(ctrl: ctrl),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _WebStatementHeader extends StatelessWidget {
  final PersonalisationController ctrl;

  const _WebStatementHeader({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final title = ctrl.isCapitalGain.value
          ? 'Capital Gain'
          : 'Account Statements';

      return Row(
        children: [


          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: UTextStyles.sectionHeading.copyWith(
                    fontSize: 28,
                    height: 1.15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Generate, preview, download or email your mutual fund statements securely.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: UTextStyles.bodyMedium.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF667085),
                  ),
                ),
              ],
            ),
          ),

          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F7FF),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFDCE8FF)),
            ),
            child: Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F0FF),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(
                    Icons.verified_user_outlined,
                    size: 17,
                    color: Ucolors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Secure statement centre',
                  style: UTextStyles.bodyMedium.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Ucolors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class _WebStatementFormCard extends StatelessWidget {
  final PersonalisationController ctrl;

  const _WebStatementFormCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6ECF5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool compact = constraints.maxWidth < 950;

          return Obx(()=> Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                compact
                    ? Column(
                        children: [
                          ctrl.isCapitalGain.value? const SizedBox.shrink() :
                          _WebStatementSource(ctrl: ctrl),
                          ctrl.isCapitalGain.value? const SizedBox.shrink() :
                          const SizedBox(height: 18),
                          _WebPanFolioInput(ctrl: ctrl),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ctrl.isCapitalGain.value? const SizedBox.shrink() :
                          Expanded(child: _WebStatementSource(ctrl: ctrl)),
                          ctrl.isCapitalGain.value? const SizedBox.shrink() :
                          const SizedBox(width: 42),
                          Expanded(child: _WebPanFolioInput(ctrl: ctrl)),
                        ],
                      ),

                const SizedBox(height: 28),

                _WebDurationSection(ctrl: ctrl),

                const SizedBox(height: 16),

                _WebDateRangeBar(ctrl: ctrl),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(child: _WebTaxReadyInfo()),
                    const SizedBox(width: 16),
                    Obx(() {
                      final loading =
                          ctrl.isRequestingStatement.value ||
                          ctrl.isRequestingAccountStatement.value;

                      return SizedBox(
                        height: 54,
                        width: 250,
                        child: ElevatedButton(
                          onPressed: loading ? null : ctrl.onDownload,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Ucolors.primary,
                            disabledBackgroundColor: const Color(0xFFBFD0FF),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: loading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    color: Colors.white,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.post_add_rounded,
                                      size: 24,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Generate Statement',
                                      style: UTextStyles.bodyMedium.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _WebStatementSource extends StatelessWidget {
  final PersonalisationController ctrl;

  const _WebStatementSource({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctrl.isCapitalGain.value) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _WebStepTitle(number: '1.', title: 'Statement Source'),
          const SizedBox(height: 12),
          Container(
            height: 44,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFD8E1F0)),
            ),
            child: Row(
              children: [
                _WebSegmentButton(
                  label: 'PAN Number',
                  active: ctrl.statementTypeIndex.value == 0,
                  onTap: () => ctrl.selectStatementType(0),
                ),
                _WebSegmentButton(
                  label: 'Folio Number',
                  active: ctrl.statementTypeIndex.value == 1,
                  onTap: () => ctrl.selectStatementType(1),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class _WebSegmentButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _WebSegmentButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: active
                ? Ucolors.backgroundGradient
                : null,
          ),
          child: Text(
            label,
            style: UTextStyles.bodyMedium.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: active ? Colors.white : const Color(0xFF475467),
            ),
          ),
        ),
      ),
    );
  }
}

class _WebPanFolioInput extends StatelessWidget {
  final PersonalisationController ctrl;

  const _WebPanFolioInput({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isPan = ctrl.statementTypeIndex.value == 0;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _WebStepTitle(
            number: ctrl.statementTypeIndex.value == 0 ? '2.' : '1.',
            title: isPan ? 'Enter PAN' : 'Select Folio',
          ),
          const SizedBox(height: 12),

          isPan
              ? _WebReadOnlyPanField(ctrl: ctrl)
              : _WebFolioDropdown(ctrl: ctrl),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                size: 16,
                color: Color(0xFF12B76A),
              ),
              const SizedBox(width: 6),
              Text(
                isPan
                    ? 'Verified securely via NSDL'
                    : 'Folio verified securely',
                style: UTextStyles.bodyMedium.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF667085),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}

class _WebReadOnlyPanField extends StatelessWidget {
  final PersonalisationController ctrl;

  const _WebReadOnlyPanField({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color:Ucolors.primary, width: 1.2),
        ),
        child: TextField(
          controller: ctrl.panController,
          inputFormatters: [
            UpperCaseTextFormatter(),
            LengthLimitingTextInputFormatter(10),
          ],
          style: UTextStyles.bodyMedium.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF344054),
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.badge_outlined,
              size: 22,
              color: Color(0xFF344054),
            ),
            suffixIcon: Icon(
              Icons.check_circle_outline_rounded,
              size: 24,
              color: Color(0xFF12B76A),
            ),
            contentPadding: EdgeInsets.only(top: 13),
          ),
        ),
      ),
    );
  }
}

class _WebFolioDropdown extends StatelessWidget {
  final PersonalisationController ctrl;

  const _WebFolioDropdown({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFD8E1F0)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.description_outlined,
              size: 20,
              color: Color(0xFF344054),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                ctrl.selectedFolio.value.isEmpty
                    ? 'Select Folio'
                    : ctrl.selectedFolio.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: UTextStyles.bodyMedium.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF344054),
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 24,
              color: Color(0xFF667085),
            ),
          ],
        ),
      ),
    );
  }
}

class _WebDurationSection extends StatelessWidget {
  final PersonalisationController ctrl;

  const _WebDurationSection({required this.ctrl});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _WebStepTitle(number:  ctrl.statementTypeIndex.value == 0 ? '3.' : '2.', title: 'Select Duration'),

        const SizedBox(height: 12),

        LayoutBuilder(
          builder: (context, constraints) {
            final bool compact = constraints.maxWidth < 860;

            return Obx(() {
              final int selectedIndex = ctrl.selectedDuration.value;

              return GridView.builder(
                itemCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: compact ? 2 : 4,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  mainAxisExtent: 96,
                ),
                itemBuilder: (context, index) {
                  return _WebDurationTile(
                    index: index,
                    active: selectedIndex == index,
                    onTap: () => ctrl.selectDuration(index),
                  );
                },
              );
            });
          },
        ),
      ],
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _WebStepTitle(number: '3.', title: 'Select Duration'),
  //       const SizedBox(height: 12),
  //       Obx(() {
  //         return LayoutBuilder(
  //           builder: (context, constraints) {
  //             final bool compact = constraints.maxWidth < 860;

  //             return GridView.builder(
  //               itemCount: 4,
  //               shrinkWrap: true,
  //               physics: const NeverScrollableScrollPhysics(),
  //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //                 crossAxisCount: compact ? 2 : 4,
  //                 crossAxisSpacing: 14,
  //                 mainAxisSpacing: 14,
  //                 mainAxisExtent: 96,
  //               ),
  //               itemBuilder: (context, index) {
  //                 return _WebDurationTile(
  //                   index: index,
  //                   active: ctrl.selectedDuration.value == index,
  //                   onTap: () => ctrl.selectDuration(index),
  //                 );
  //               },
  //             );
  //           },
  //         );
  //       }),
  //     ],
  //   );
  // }
}

class _WebDurationTile extends StatelessWidget {
  final int index;
  final bool active;
  final VoidCallback onTap;

  const _WebDurationTile({
    required this.index,
    required this.active,
    required this.onTap,
  });

  String get title {
    switch (index) {
      case 0:
        return 'Current FY';
      case 1:
        return 'Previous FY';
      case 2:
        return 'Full Statement';
      case 3:
        return 'Custom Range';
      default:
        return '';
    }
  }

  String get subtitle {
    switch (index) {
      case 0:
        return '2024 - 2025';
      case 1:
        return '2023 - 2024';
      case 2:
        return 'All Transactions';
      case 3:
        return 'Choose dates';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: active
              ? Ucolors.backgroundGradient
              : null,
          color: active ? null : const Color(0xFFFBFCFF),
          border: Border.all(
            color: active ? Ucolors.primary : const Color(0xFFDCE3EF),
          ),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: Ucolors.primary.withOpacity(0.18),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 22,
              color: active ? Colors.white : const Color(0xFF243B6B),
            ),
            const SizedBox(height: 9),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: UTextStyles.bodyMedium.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: active ? Colors.white : const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: UTextStyles.bodyMedium.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: active
                    ? Colors.white.withOpacity(0.86)
                    : const Color(0xFF667085),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WebDateRangeBar extends StatelessWidget {
  final PersonalisationController ctrl;

  const _WebDateRangeBar({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isCustom = ctrl.selectedDuration.value == 3;

      return InkWell(
        onTap: isCustom ? () => ctrl.pickDate(context, true) : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isCustom ? Colors.white : const Color(0xFFFBFCFF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isCustom
                  ? const Color(0xFFD8E1F0)
                  : const Color(0xFFE3E8F1),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 17,
                color: isCustom
                    ? const Color(0xFF667085)
                    : const Color(0xFFC3CAD8),
              ),
              const SizedBox(width: 14),
              Text(
                isCustom
                    ? ctrl.formatDate(ctrl.startDate.value)
                    : 'Select start date',
                style: UTextStyles.bodyMedium.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isCustom
                      ? const Color(0xFF475467)
                      : const Color(0xFFC3CAD8),
                ),
              ),
              const SizedBox(width: 26),
              Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: isCustom
                    ? const Color(0xFF667085)
                    : const Color(0xFFC3CAD8),
              ),
              const SizedBox(width: 26),
              InkWell(
                onTap: isCustom ? () => ctrl.pickDate(context, false) : null,
                borderRadius: BorderRadius.circular(6),
                child: Text(
                  isCustom
                      ? ctrl.formatDate(ctrl.endDate.value)
                      : 'Select end date',
                  style: UTextStyles.bodyMedium.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isCustom
                        ? const Color(0xFF475467)
                        : const Color(0xFFC3CAD8),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _WebTaxReadyInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F6FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDCE8FF)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 22,
            color: Ucolors.primary,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Need a tax-ready statement? Use Full Statement or Custom Range.',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: UTextStyles.bodyMedium.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Ucolors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WebStatementPreviewCard extends StatelessWidget {
  final PersonalisationController ctrl;

  const _WebStatementPreviewCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 274,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6ECF5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 20, 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Statement Preview',
                        style: UTextStyles.sectionHeading.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Preview your transactions for the selected duration.',
                        style: UTextStyles.bodyMedium.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF667085),
                        ),
                      ),
                    ],
                  ),
                ),
                _PreviewIconButton(
                  icon: Icons.mail_outline_rounded,
                  color: Ucolors.primary,
                  onTap: ctrl.onEmail,
                ),
                const SizedBox(width: 12),
                _PreviewIconButton(
                  icon: Icons.picture_as_pdf_rounded,
                  color: Ucolors.red,
                  onTap: ctrl.onDownload,
                ),
                const SizedBox(width: 12),
                _PreviewIconButton(
                  icon: Icons.table_chart_rounded,
                  color: const Color(0xFF16A34A),
                  onTap: ctrl.onDownload,
                ),
                const SizedBox(width: 12),
                _PreviewIconButton(
                  icon: Icons.print_rounded,
                  color: Ucolors.primary,
                  onTap: ctrl.onDownload,
                ),
              ],
            ),
          ),

          Container(
            height: 42,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFE6ECF5)),
                bottom: BorderSide(color: Color(0xFFE6ECF5)),
              ),
            ),
            child: Row(
              children: const [
                _PreviewHeaderCell('Fund Name', flex: 3),
                _PreviewHeaderCell('Inv. Since', flex: 2),
                _PreviewHeaderCell('Total Inv.', flex: 2),
                _PreviewHeaderCell('Current Amount', flex: 2),
                _PreviewHeaderCell('Units', flex: 2),
                _PreviewHeaderCell('Realized Gain', flex: 2),
                _PreviewHeaderCell('Unrealized Gain', flex: 2),
              ],
            ),
          ),

          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF4FF),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child:  Icon(
                      Icons.manage_search_rounded,
                      size: 40,
                      color: Ucolors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No transactions found for the selected duration.',
                    style: UTextStyles.bodyMedium.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF475467),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Try changing the date range or source to preview your statement.',
                    style: UTextStyles.bodyMedium.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF667085),
                    ),
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

class _PreviewIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _PreviewIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        width: 56,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: const Color(0xFFDCE3EF)),
        ),
        child: Icon(icon, size: 22, color: color),
      ),
    );
  }
}

class _PreviewHeaderCell extends StatelessWidget {
  final String title;
  final int flex;

  const _PreviewHeaderCell(this.title, {required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.only(left: 26),
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: UTextStyles.bodyMedium.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF344054),
          ),
        ),
      ),
    );
  }
}

class _WebStepTitle extends StatelessWidget {
  final String number;
  final String title;

  const _WebStepTitle({required this.number, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          number,
          style: UTextStyles.bodyMedium.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: UTextStyles.bodyMedium.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}
// class _DesktopDownloadStatementsLayout extends StatelessWidget {
//   final PersonalisationController ctrl;
//   const _DesktopDownloadStatementsLayout({required this.ctrl});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F8FC),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
//           child: Center(
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(maxWidth: 1180),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _DesktopHeader(ctrl: ctrl),
//                   const SizedBox(height: 28),

//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(flex: 7, child: _DesktopFormPanel(ctrl: ctrl)),
//                       const SizedBox(width: 24),
//                       SizedBox(
//                         width: 370,
//                         child: _DesktopSummaryPanel(ctrl: ctrl),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _DesktopHeader extends StatelessWidget {
//   final PersonalisationController ctrl;
//   const _DesktopHeader({required this.ctrl});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final title = ctrl.isCapitalGain.value
//           ? 'Capital Gain'
//           : 'Download Statements';

//       return Row(
//         children: [
//           InkWell(
//             onTap: () => Navigator.pop(context),
//             borderRadius: BorderRadius.circular(14),
//             child: Container(
//               height: 46,
//               width: 46,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(14),
//                 border: Border.all(color: Ucolors.surfaceVariant),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.04),
//                     blurRadius: 18,
//                     offset: const Offset(0, 6),
//                   ),
//                 ],
//               ),
//               child: const Icon(
//                 Icons.arrow_back_ios_new_rounded,
//                 size: 18,
//                 color: Ucolors.onSurface,
//               ),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: UTextStyles.sectionHeading.copyWith(
//                     fontSize: 28,
//                     fontWeight: FontWeight.w600,
//                     color: Ucolors.onSurface,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   'Generate, download or email your investment statement securely.',
//                   style: UTextStyles.bodyMedium.copyWith(
//                     fontSize: 14,
//                     color: Ucolors.onSurfaceVariant,
//                     height: 1.4,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//             decoration: BoxDecoration(
//               color: Ucolors.infoBanner,
//               borderRadius: BorderRadius.circular(999),
//               border: Border.all(color: Ucolors.infoBannerBorder),
//             ),
//             child: Row(
//               children: [
//                 const Icon(
//                   Icons.verified_user_outlined,
//                   size: 18,
//                   color: Ucolors.primaryContainer,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Secure statement centre',
//                   style: UTextStyles.caption.copyWith(
//                     color: Ucolors.primaryContainer,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }

// class _DesktopFormPanel extends StatelessWidget {
//   final PersonalisationController ctrl;
//   const _DesktopFormPanel({required this.ctrl});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(26),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.86),
//         borderRadius: BorderRadius.circular(28),
//         border: Border.all(color: Ucolors.surfaceVariant),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.045),
//             blurRadius: 28,
//             offset: const Offset(0, 12),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _DesktopPanelTitle(
//             icon: Icons.description_outlined,
//             title: 'Statement details',
//             subtitle:
//                 'Choose the statement source and duration before generating the file.',
//           ),
//           const SizedBox(height: 22),

//           Obx(() {
//             if (ctrl.isCapitalGain.value) {
//               return const SizedBox.shrink();
//             }

//             return Column(
//               children: [
//                 _StatementTypeCard(ctrl: ctrl),
//                 const SizedBox(height: 16),
//               ],
//             );
//           }),

//           Obx(
//             () => ctrl.statementTypeIndex.value == 0
//                 ? _PanInputCard(ctrl: ctrl)
//                 : _FolioInputCard(ctrl: ctrl),
//           ),
//           const SizedBox(height: 16),

//           _DurationCard(ctrl: ctrl),
//           const SizedBox(height: 12),

//           Obx(() {
//             if (ctrl.selectedDuration.value == 3) {
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 12.0),
//                 child: _CustomDateSelector(ctrl: ctrl),
//               );
//             }
//             return const SizedBox.shrink();
//           }),

//           _InfoBanner(email: ctrl.emailController.text),
//         ],
//       ),
//     );
//   }
// }

// class _DesktopPanelTitle extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;

//   const _DesktopPanelTitle({
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           height: 46,
//           width: 46,
//           decoration: BoxDecoration(
//             color: Ucolors.primaryContainer.withOpacity(0.10),
//             borderRadius: BorderRadius.circular(14),
//           ),
//           child: Icon(icon, color: Ucolors.primaryContainer, size: 22),
//         ),
//         const SizedBox(width: 14),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: UTextStyles.sectionHeading.copyWith(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                   color: Ucolors.onSurface,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 subtitle,
//                 style: UTextStyles.bodyMedium.copyWith(
//                   fontSize: 14,
//                   color: Ucolors.onSurfaceVariant,
//                   height: 1.35,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _DesktopSummaryPanel extends StatelessWidget {
//   final PersonalisationController ctrl;
//   const _DesktopSummaryPanel({required this.ctrl});

//   String _durationText() {
//     final selectedIndex = ctrl.selectedDuration.value;

//     if (selectedIndex == 3) {
//       return '${ctrl.formatDate(ctrl.startDate.value)} - ${ctrl.formatDate(ctrl.endDate.value)}';
//     }

//     if (selectedIndex >= 0 && selectedIndex < ctrl.durations.length) {
//       return ctrl.durations[selectedIndex];
//     }

//     return '-';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final isLoading =
//           ctrl.isRequestingStatement.value ||
//           ctrl.isRequestingAccountStatement.value;

//       final statementVia = ctrl.isCapitalGain.value
//           ? 'Capital Gain'
//           : ctrl.statementTypeIndex.value == 0
//           ? 'PAN Number'
//           : 'Folio Number';

//       final identifier = ctrl.statementTypeIndex.value == 0
//           ? ctrl.panController.text
//           : ctrl.selectedFolio.value;

//       return Container(
//         padding: const EdgeInsets.all(24),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(28),
//           border: Border.all(color: Ucolors.surfaceVariant),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 30,
//               offset: const Offset(0, 14),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: 54,
//               width: 54,
//               decoration: BoxDecoration(
//                 color: Ucolors.primaryContainer,
//                 borderRadius: BorderRadius.circular(18),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Ucolors.primaryContainer.withOpacity(0.22),
//                     blurRadius: 18,
//                     offset: const Offset(0, 8),
//                   ),
//                 ],
//               ),
//               child: const Icon(
//                 Icons.file_download_done_rounded,
//                 color: Colors.white,
//                 size: 28,
//               ),
//             ),
//             const SizedBox(height: 18),
//             Text(
//               'Ready to generate',
//               style: UTextStyles.sectionHeading.copyWith(
//                 fontSize: 22,
//                 fontWeight: FontWeight.w600,
//                 color: Ucolors.onSurface,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Review the selected options, then download the statement or send it to the registered email.',
//               style: UTextStyles.bodyMedium.copyWith(
//                 fontSize: 14,
//                 color: Ucolors.onSurfaceVariant,
//                 height: 1.5,
//               ),
//             ),
//             const SizedBox(height: 22),

//             _SummaryRow(
//               icon: Icons.fact_check_outlined,
//               label: 'Statement via',
//               value: statementVia,
//             ),
//             const SizedBox(height: 14),
//             _SummaryRow(
//               icon: Icons.badge_outlined,
//               label: ctrl.statementTypeIndex.value == 0 ? 'PAN' : 'Folio',
//               value: identifier.isEmpty ? '-' : identifier,
//             ),
//             const SizedBox(height: 14),
//             _SummaryRow(
//               icon: Icons.date_range_outlined,
//               label: 'Duration',
//               value: _durationText(),
//             ),
//             const SizedBox(height: 14),
//             _SummaryRow(
//               icon: Icons.mail_outline,
//               label: 'Email',
//               value: ctrl.emailController.text.isEmpty
//                   ? '-'
//                   : ctrl.emailController.text,
//             ),

//             const SizedBox(height: 24),
//             Divider(color: Ucolors.surfaceVariant),
//             const SizedBox(height: 20),

//             if (isLoading)
//               const Center(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 18),
//                   child: CircularProgressIndicator(),
//                 ),
//               )
//             else
//               Column(
//                 children: [
//                   _WebActionButton(
//                     icon: Icons.download_outlined,
//                     label: 'Download Statement',
//                     filled: true,
//                     onTap: ctrl.onDownload,
//                   ),
//                   const SizedBox(height: 12),
//                   _WebActionButton(
//                     icon: Icons.mail_outline,
//                     label: 'Email Statement',
//                     filled: false,
//                     onTap: ctrl.onEmail,
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       );
//     });
//   }
// }

// class _SummaryRow extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;

//   const _SummaryRow({
//     required this.icon,
//     required this.label,
//     required this.value,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF8FAFC),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Ucolors.surfaceVariant),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, size: 20, color: Ucolors.primaryContainer),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: UTextStyles.caption.copyWith(
//                     fontSize: 13,
//                     color: Ucolors.onSurfaceVariant,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   value,
//                   style: UTextStyles.bodyMedium.copyWith(
//                     fontSize: 14,
//                     color: Ucolors.onSurface,
//                     fontWeight: FontWeight.w500,
//                     height: 1.35,
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

// class _WebActionButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool filled;
//   final VoidCallback onTap;

//   const _WebActionButton({
//     required this.icon,
//     required this.label,
//     required this.filled,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(16),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 160),
//           padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
//           decoration: BoxDecoration(
//             color: filled ? Ucolors.primary : Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             border: filled ? null : Border.all(color: Ucolors.outlineVariant),
//             boxShadow: filled
//                 ? [
//                     BoxShadow(
//                       color: Ucolors.primaryContainer.withOpacity(0.22),
//                       blurRadius: 18,
//                       offset: const Offset(0, 8),
//                     ),
//                   ]
//                 : null,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 icon,
//                 size: 20,
//                 color: filled ? Ucolors.white : Ucolors.onSecondaryContainer,
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 label,
//                 style: UTextStyles.bodyMedium.copyWith(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: filled ? Ucolors.white : Ucolors.onSecondaryContainer,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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
              onTap: () {},
            ),
          ),
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
                      fontSize: 13,
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
                      fontWeight: FontWeight.w500,
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
                  fontSize: 13,
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
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Ucolors.onSurfaceVariant,
            letterSpacing: 0.24,
          ),
        ),
      ],
    );
  }
}

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
                      fontSize: 13,
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
