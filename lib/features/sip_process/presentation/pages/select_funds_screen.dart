// // import 'package:flutter/material.dart';
// // import 'package:fl_chart/fl_chart.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:flutter_svg/svg.dart';
// // import 'package:get/get.dart';
// // import 'package:my_sip/config/routes/app_routes.dart';
// // import 'package:my_sip/features/freedom_sip/presentation/widgets/sip_amount_selector.dart';
// // import 'package:my_sip/features/sip_process/presentation/widgets/sip_projection_chart.dart';
// // import '../../../../common/widget/button/elevated_button.dart';
// // import '../../../../common/widget/divider/thick_divider.dart';
// // import '../../../../core/utils/constant/colors.dart';
// // import '../../../../core/utils/constant/images.dart';
// // import '../../../../core/utils/constant/text.dart';
// // import '../../../../core/utils/constant/text_style.dart';

// // import 'package:flutter/material.dart';
// // import 'package:flutter_svg/flutter_svg.dart';
// // import 'package:get/get.dart';

// // import '../../domain/entity/fund_entity.dart';
// // import '../controllers/sip_process_controller.dart';

// // class SelectFundsScreen extends StatefulWidget {
// //   const SelectFundsScreen({super.key});

// //   @override
// //   State<SelectFundsScreen> createState() => _SelectFundsScreenState();
// // }

// // class _SelectFundsScreenState extends State<SelectFundsScreen> {
// //   final SipProcessController controller = Get.find<SipProcessController>();

// //   int _selectedIndex = -1;

// //   final styleTags = [
// //     "12 - 15 % CAGR",
// //     "Medium Volatility",
// //     "Ideal for 5+ Years",
// //   ];

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Ucolors.primary,
// //       body: SafeArea(
// //         top: true,
// //         child: SingleChildScrollView(
// //           child: Column(
// //             children: [
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(vertical: 20),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     SvgPicture.asset(UImages.mfLogoLight, height: 20),
// //                     const SizedBox(width: 10),
// //                     Text(
// //                       UText.freedomSipTitle,
// //                       style: AppTextStyles.bodyLarge(color: Colors.white),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               const SizedBox(height: 10.0),

// //               Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
// //                 child: Container(
// //                   width: double.infinity,
// //                   decoration: const BoxDecoration(
// //                     color: Colors.white,
// //                     borderRadius: BorderRadius.all(Radius.circular(25.0)),
// //                   ),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Padding(
// //                         padding: const EdgeInsets.symmetric(
// //                           vertical: 8.0,
// //                           horizontal: 30,
// //                         ),
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             const SizedBox(height: 15.0),
// //                             Text(
// //                               "Balanced Investing Style",
// //                               style: AppTextStyles.bodyLargeBold(),
// //                             ),
// //                             RichText(
// //                               maxLines: 2,
// //                               text: TextSpan(
// //                                 text:
// //                                     "Investing in fundamentally strong, well-managed companies with",
// //                                 style: AppTextStyles.bodySmall(
// //                                   size: 10,
// //                                   color: Colors.grey,
// //                                 ),
// //                                 children: [
// //                                   TextSpan(
// //                                     text: " Know More",
// //                                     style: AppTextStyles.bodySmallSemiBold(
// //                                       color: Colors.black45,
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                             const SizedBox(height: 5),
// //                             Wrap(
// //                               spacing: 4.0,
// //                               runSpacing: 4.0,
// //                               children: styleTags.map((tag) {
// //                                 return Container(
// //                                   padding: const EdgeInsets.symmetric(
// //                                     horizontal: 12.0,
// //                                     vertical: 6.0,
// //                                   ),
// //                                   decoration: BoxDecoration(
// //                                     color: Colors.grey.withAlpha(40),
// //                                     borderRadius: BorderRadius.circular(20.0),
// //                                   ),
// //                                   child: Text(
// //                                     tag,
// //                                     style: AppTextStyles.bodySmall(
// //                                       size: 9,
// //                                       color: Colors.black54,
// //                                     ),
// //                                   ),
// //                                 );
// //                               }).toList(),
// //                             ),
// //                           ],
// //                         ),
// //                       ),

// //                       const ThickDivider(),
// //                       const SizedBox(height: 20),

// //                       Padding(
// //                         padding: const EdgeInsets.symmetric(horizontal: 20),
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Text(
// //                               "List Of Shortlisted high growth funds.",
// //                               style: AppTextStyles.bodyMediumBold(),
// //                             ),
// //                             Text(
// //                               "By MF radiant Finworld Team",
// //                               style: AppTextStyles.bodySmall(
// //                                 color: Colors.grey,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),

// //                       const SizedBox(height: 15),

// //                       controller.obx(
// //                         (state) => ListView.separated(
// //                           padding: const EdgeInsets.symmetric(
// //                             horizontal: 20,
// //                             vertical: 10,
// //                           ),
// //                           shrinkWrap: true,
// //                           physics: const NeverScrollableScrollPhysics(),
// //                           itemCount: state?.length ?? 0,
// //                           separatorBuilder: (c, i) =>
// //                               const SizedBox(height: 12),
// //                           itemBuilder: (context, index) {
// //                             return _buildSchemeCard(state![index], index);
// //                           },
// //                         ),

// //                         onLoading: const Padding(
// //                           padding: EdgeInsets.all(40.0),
// //                           child: Center(child: CircularProgressIndicator()),
// //                         ),

// //                         onError: (error) => Padding(
// //                           padding: const EdgeInsets.all(20.0),
// //                           child: Center(child: Text("Error: $error")),
// //                         ),
// //                       ),

// //                       const SizedBox(height: 20),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //       bottomNavigationBar: Container(
// //         padding: const EdgeInsets.all(16),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.05),
// //               blurRadius: 10,
// //               offset: const Offset(0, -5),
// //             ),
// //           ],
// //         ),
// //         child: SafeArea(
// //           child: Row(
// //             children: [
// //               Expanded(
// //                 child: UElevatedBUtton(
// //                   onPressed: () => Navigator.pop(context),
// //                   outlined: true,
// //                   child: Center(
// //                     child: Text(
// //                       'Back',
// //                       style: AppTextStyles.bodyMedium(color: Ucolors.primary),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(width: 16),
// //               Expanded(
// //                 child: UElevatedBUtton(
// //                   onPressed: () {
// //                     if (_selectedIndex != -1 && controller.state != null) {
// //                       final selectedFund = controller.state![_selectedIndex];
// //                       Get.toNamed(
// //                         // AppRoutes.investingApproachScreen,
// //                         AppRoutes.cart,
// //                         arguments: selectedFund,
// //                       );
// //                     } else {
// //                       Get.snackbar(
// //                         "Selection Required",
// //                         "Please select a fund to proceed",
// //                       );
// //                     }
// //                   },
// //                   child: Center(
// //                     child: Text(
// //                       'Next',
// //                       style: AppTextStyles.bodyMedium(color: Colors.white),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildSchemeCard(FundEntity fund, int index) {
// //     final isSelected = _selectedIndex == index;

// //     return GestureDetector(
// //       onTap: () {
// //         setState(() {
// //           _selectedIndex = index;
// //         });
// //       },
// //       child: AnimatedContainer(
// //         duration: const Duration(milliseconds: 200),
// //         padding: const EdgeInsets.all(12),
// //         decoration: BoxDecoration(
// //           color: isSelected ? Ucolors.primary.withOpacity(0.1) : Colors.white,
// //           border: Border.all(
// //             color: isSelected ? Ucolors.primary : Colors.grey.shade300,
// //             width: isSelected ? 1.5 : 1.0,
// //           ),
// //           borderRadius: BorderRadius.circular(15.0),
// //         ),
// //         child: Column(
// //           children: [
// //             Row(
// //               children: [
// //                 CircleAvatar(
// //                   radius: 18,
// //                   backgroundColor: Colors.transparent,
// //                   backgroundImage: AssetImage(fund.icon),
// //                 ),
// //                 const SizedBox(width: 10),
// //                 Expanded(
// //                   child: Text(
// //                     fund.name,
// //                     style: AppTextStyles.bodyMediumSemiBold(),
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 10),
// //             Divider(color: Colors.grey.shade300, thickness: 1),
// //             const SizedBox(height: 10),

// //             FittedBox(
// //               fit: BoxFit.scaleDown,
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Row(
// //                     children: [
// //                       const Icon(Icons.circle, color: Colors.red, size: 8),
// //                       const SizedBox(width: 4),
// //                       Text(
// //                         fund.riskType,
// //                         style: AppTextStyles.bodySmall(
// //                           color: Colors.grey,
// //                           size: 11,
// //                         ),
// //                       ),
// //                     ],
// //                   ),

// //                   const SizedBox(width: 12),

// //                   Row(
// //                     children: [
// //                       Text(
// //                         "SIP Returns: ",
// //                         style: AppTextStyles.bodySmall(
// //                           color: Colors.grey,
// //                           size: 11,
// //                         ),
// //                       ),
// //                       Text(
// //                         fund.sipReturns,
// //                         style: AppTextStyles.bodySmall(
// //                           color: Colors.green,
// //                           size: 11,
// //                         ),
// //                       ),
// //                       Text(
// //                         " pa",
// //                         style: AppTextStyles.bodySmall(color: Colors.grey),
// //                       ),
// //                     ],
// //                   ),

// //                   const SizedBox(width: 12),

// //                   Row(
// //                     children: [
// //                       Text(
// //                         "Rating: ",
// //                         style: AppTextStyles.bodySmall(
// //                           color: Colors.grey,
// //                           size: 11,
// //                         ),
// //                       ),
// //                       const Icon(Icons.star, color: Colors.amber, size: 12),
// //                       Text(
// //                         " ${fund.rating}",
// //                         style: AppTextStyles.bodySmall(
// //                           color: Colors.black,
// //                           size: 11,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:my_sip/common/widget/images/custom_cached_image.dart';
// import 'package:my_sip/common/widget/text_form/text_field_component.dart';
// import 'package:my_sip/config/routes/app_routes.dart';
// import 'package:my_sip/core/utils/constant/appUrl.dart';
// import 'package:my_sip/core/utils/constant/colors.dart';
// import 'package:my_sip/core/utils/constant/images.dart';
// import 'package:my_sip/core/utils/constant/text.dart';
// import 'package:my_sip/core/utils/constant/text_style.dart';
// import 'package:my_sip/common/widget/button/elevated_button.dart';
// import 'package:my_sip/common/widget/divider/thick_divider.dart';
// import 'package:my_sip/core/utils/enums/enums.dart';
// import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
// import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';
// import 'package:my_sip/features/fund_details/presentation/pages/fund_deatails.dart';
// import 'package:my_sip/features/fund_details/presentation/widgets/helper.dart';
// import '../controllers/sip_process_controller.dart';

// class SelectFundsScreen extends StatefulWidget {
//   const SelectFundsScreen({super.key});

//   @override
//   State<SelectFundsScreen> createState() => _SelectFundsScreenState();
// }

// class _SelectFundsScreenState extends State<SelectFundsScreen> {
//   final SipProcessController controller = Get.find<SipProcessController>();
//   int _selectedIndex = -1;

//   final styleTags = [
//     "12 - 15 % CAGR",
//     "Medium Volatility",
//     "Ideal for 5+ Years",
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Ucolors.primary,

//       // appBar: AppBar(
//       //   backgroundColor: Ucolors.primary,

//       //   title: Row(
//       //     children: [
//       //       SvgPicture.asset(UImages.mfLogoLight, height: 20),
//       //       const SizedBox(width: 10),
//       //       Text(
//       //         UText.freedomSipTitle,
//       //         style: AppTextStyles.bodyLarge(color: Colors.white),
//       //       ),
//       //     ],
//       //   ),
//       // ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               _buildAppBar(),
//               const SizedBox(height: 10.0),
//               _buildContent(),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: _buildBottomNav(),
//     );
//   }

//   Widget _buildAppBar() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SvgPicture.asset(UImages.mfLogoLight, height: 20),
//           const SizedBox(width: 10),
//           Text(
//             UText.freedomSipTitle,
//             style: AppTextStyles.bodyLarge(color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildContent() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: Container(
//         width: double.infinity,
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.all(Radius.circular(25.0)),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildInfoSection(),
//             const ThickDivider(),
//             const SizedBox(height: 20),
//             _buildListTitle(),
//             const SizedBox(height: 15),
//             // RECOGNIZES MutualFundListEntity STATE
//             controller.obx(
//               (state) => ListView.separated(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 10,
//                 ),
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: state?.length ?? 0,
//                 separatorBuilder: (c, i) => const SizedBox(height: 12),
//                 itemBuilder: (context, index) =>
//                     _buildSchemeCard(state![index], index),
//               ),
//               onLoading: const Center(
//                 child: Padding(
//                   padding: EdgeInsets.all(40),
//                   child: CircularProgressIndicator(),
//                 ),
//               ),
//               onEmpty: const Center(
//                 child: Padding(
//                   padding: EdgeInsets.all(20),
//                   child: Text("No Best SIP Funds available"),
//                 ),
//               ),
//               onError: (error) => Center(child: Text("Error: $error")),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSchemeCard(MutualFundListEntity fund, int index) {
//     return Obx(() {
//       // final isSelected = controller.isSelected(fund.schemeCode.toString());
//       final isSelected = controller.isSelected(fund.schemeCode ?? "");
//       return GestureDetector(
//         // onTap: () => setState(() => _selectedIndex = index),
//         onTap: () => controller.toggleSelection(fund),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: isSelected ? Ucolors.primary.withOpacity(0.1) : Colors.white,
//             border: Border.all(
//               color: isSelected ? Ucolors.primary : Colors.grey.shade300,
//               width: isSelected ? 1.5 : 1.0,
//             ),
//             borderRadius: BorderRadius.circular(15.0),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header: Icon and Name
//               Row(
//                 children: [
//                   ClipOval(
//                     child: CustomCachedImage(
//                       imageUrl: '${Appurl.baseUrl}${fund.amc?.amcLogoUrl}',
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       fund.baseSchemeName ?? "Unknown Fund",
//                       style: AppTextStyles.bodyMediumSemiBold(size: 12),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   if (isSelected)
//                     const Icon(
//                       Icons.check_circle,
//                       color: Ucolors.primary,
//                       size: 20,
//                     ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               DashedLine(color: Colors.grey.shade300),
//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   if (isSelected) ...[
//                     Column(
//                       children: [
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.circle,
//                               color: getRiskMeter(fund.riskLevel).color,
//                               size: 10,
//                             ),

//                             const SizedBox(width: 3),
//                             Text(
//                               fund.riskLevel ?? "N/A",
//                               style: AppTextStyles.bodySmall(
//                                 color: getRiskMeter(fund.riskLevel).color,
//                                 size: 10,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Text(
//                               "SIP Returns (3Y): ",
//                               style: AppTextStyles.bodySmall(
//                                 color: Colors.grey.shade700,
//                                 size: 10,
//                               ),
//                             ),
//                             Text(
//                               "${fund.returnsEntity?.threeYear ?? '0.0'}%",
//                               style: AppTextStyles.bodySmall(
//                                 color: Colors.green,
//                                 size: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     SizedBox(width: 10),
//                   ],
//                   if (!isSelected) ...[
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.circle,
//                           color: getRiskMeter(fund.riskLevel).color,
//                           size: 10,
//                         ),

//                         const SizedBox(width: 3),
//                         Text(
//                           fund.riskLevel ?? "N/A",
//                           style: AppTextStyles.bodySmall(
//                             color: getRiskMeter(fund.riskLevel).color,
//                             size: 10,
//                           ),
//                         ),
//                       ],
//                     ),

//                     // SIP Returns
//                     Row(
//                       children: [
//                         Text(
//                           "SIP Returns (3Y): ",
//                           style: AppTextStyles.bodySmall(
//                             color: Colors.grey.shade700,
//                             size: 10,
//                           ),
//                         ),
//                         Text(
//                           "${fund.returnsEntity?.threeYear ?? '0.0'}%",
//                           style: AppTextStyles.bodySmall(
//                             color: Colors.green,
//                             size: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                   // SizedBox(width: 10),
//                   isSelected
//                       ? Expanded(
//                           child: CustomTextField(
//                             validationType: ValidationType
//                                 .custom, // Enable custom validation
//                             keyboardType: TextInputType.number,
//                             height: 44,

//                             controller: controller.getTextController(
//                               fund.schemeCode ?? "",
//                             ),

//                             onChanged: (val) => controller.updateFundAmount(
//                               fund.schemeCode ?? "",
//                               val,
//                             ),
//                             customValidator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return "Required";
//                               }

//                               final enteredAmount = int.tryParse(value) ?? 0;
//                               final minAmount = fund.minSipAmount ?? 500;

//                               if (enteredAmount < minAmount) {
//                                 return "Min. ₹$minAmount required";
//                               }

//                               if (enteredAmount % 100 != 0) {
//                                 return "Must be multiple of ₹100";
//                               }

//                               return null; // Valid
//                             },
//                           ),
//                         )
//                       : SizedBox.shrink(),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }

//   // Widget _buildSchemeCard(MutualFundListEntity fund, int index) {
//   //   final isSelected = _selectedIndex == index;

//   //   return GestureDetector(
//   //     onTap: () => setState(() => _selectedIndex = index),
//   //     child: AnimatedContainer(
//   //       duration: const Duration(milliseconds: 200),
//   //       padding: const EdgeInsets.all(12),
//   //       decoration: BoxDecoration(
//   //         color: isSelected ? Ucolors.primary.withOpacity(0.1) : Colors.white,
//   //         border: Border.all(
//   //           color: isSelected ? Ucolors.primary : Colors.grey.shade300,
//   //           width: isSelected ? 1.5 : 1.0,
//   //         ),
//   //         borderRadius: BorderRadius.circular(15.0),
//   //       ),
//   //       child: Column(
//   //         crossAxisAlignment: CrossAxisAlignment.start,
//   //         children: [
//   //           Row(
//   //             children: [
//   //               Expanded(
//   //                 child: Text(
//   //                   fund.baseSchemeName ?? "N/A",
//   //                   style: AppTextStyles.bodyMediumSemiBold(),
//   //                   overflow: TextOverflow.ellipsis,
//   //                 ),
//   //               ),
//   //               if (isSelected) const Icon(Icons.check_circle, color: Ucolors.primary, size: 20),
//   //             ],
//   //           ),
//   //           const SizedBox(height: 8),
//   //           Row(
//   //             children: [
//   //               Text("Risk: ${fund.riskLevel ?? 'Moderate'}", style: AppTextStyles.bodySmall(color: Colors.orange, size: 10)),
//   //               const Spacer(),
//   //               const Icon(Icons.star, color: Colors.amber, size: 12),
//   //               Text(" ${fund.riskLevel ?? '0'}", style: AppTextStyles.bodySmall(size: 11)),
//   //             ],
//   //           ),
//   //           const Divider(),
//   //           // DISPLAYING TRAILING RETURNS
//   //           Row(
//   //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //             children: [
//   //               _returnItem("1Y", fund.returnsEntity?.oneYear),
//   //               _returnItem("3Y", fund.returnsEntity?.threeYear),
//   //               _returnItem("5Y", fund.returnsEntity?.fiveYear),
//   //             ],
//   //           )
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }

//   Widget _returnItem(String label, dynamic value) {
//     return Column(
//       children: [
//         Text(
//           label,
//           style: AppTextStyles.bodySmall(size: 9, color: Colors.grey),
//         ),
//         Text(
//           "${value ?? '0.0'}%",
//           style: AppTextStyles.bodySmall(size: 10, color: Colors.green),
//         ),
//       ],
//     );
//   }

//   // --- Helper Widgets ---
//   Widget _buildInfoSection() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 15.0),
//           Text(
//             "Balanced Investing Style",
//             style: AppTextStyles.bodyLargeBold(),
//           ),
//           Text(
//             "Investing in fundamentally strong, well-managed companies.",
//             style: AppTextStyles.bodySmall(size: 10, color: Colors.grey),
//           ),
//           const SizedBox(height: 8),
//           Wrap(
//             spacing: 4.0,
//             children: styleTags.map((tag) => _buildTag(tag)).toList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTag(String tag) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Text(
//         tag,
//         style: AppTextStyles.bodySmall(size: 8, color: Colors.black54),
//       ),
//     );
//   }

//   Widget _buildListTitle() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "List Of Shortlisted high growth funds.",
//             style: AppTextStyles.bodyMediumBold(),
//           ),
//           Text(
//             "By MF radiant Finworld Team",
//             style: AppTextStyles.bodySmall(color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomNav() {
//     return Obx(() {
//       final selectedCount = controller.selectedFunds.length;
//       final totalAmount = controller.totalSelectedAmount;
//       final selectedAmount = controller.amount.toDouble();

//       return Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               spreadRadius: 2,
//             ),
//           ],
//           border: const Border(top: BorderSide(color: Colors.black12)),
//         ),
//         child: SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Total Summary Row
//               if (selectedCount > 0) ...[
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Total Amount ($selectedCount funds)",
//                       style: AppTextStyles.bodySmall(
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                     Text(
//                       controller.formatCurrency(totalAmount),
//                       style: AppTextStyles.bodyMediumBold(
//                         color: Ucolors.primary,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//               ],

//               // Buttons Row
//               Row(
//                 children: [
//                   Expanded(
//                     child: UElevatedBUtton(
//                       onPressed: () => Navigator.pop(context),
//                       outlined: true,
//                       child: Center(
//                         child: Text(
//                           'Back',
//                           style: AppTextStyles.bodyMedium(
//                             color: Ucolors.primary,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: UElevatedBUtton(
//                       onPressed: controller.proceedToCart,
//                       // onPressed: () {
//                       //   if (totalAmount < selectedAmount) {
//                       //     // Show the alert box
//                       //     Get.dialog(
//                       //       AlertDialog(
//                       //         shape: RoundedRectangleBorder(
//                       //           borderRadius: BorderRadius.circular(16),
//                       //         ),
//                       //         title: const Text('Amount Mismatch'),
//                       //         content: const Text(
//                       //           'The total amount is less than your selected investment amount. Do you want to proceed anyway?',
//                       //         ),
//                       //         actions: [
//                       //           // Back Button
//                       //           TextButton(
//                       //             onPressed: () {
//                       //               Get.back(); // Closes the dialog
//                       //             },
//                       //             child: const Text(
//                       //               'Back',
//                       //               style: TextStyle(color: Colors.grey),
//                       //             ),
//                       //           ),
//                       //           // Proceed Button
//                       //           TextButton(
//                       //             onPressed: () {
//                       //               Get.back(); // Closes the dialog first
//                       //               controller
//                       //                   .proceedToCart(); // Then executes the cart logic
//                       //             },
//                       //             child: const Text(
//                       //               'Proceed',
//                       //               style: TextStyle(
//                       //                 fontWeight: FontWeight.bold,
//                       //               ),
//                       //             ),
//                       //           ),
//                       //         ],
//                       //       ),
//                       //     );
//                       //   } else {
//                       //     controller.proceedToCart;
//                       //   }
//                       // },
//                       child: Center(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Add to Cart',
//                               style: AppTextStyles.bodyMedium(
//                                 color: Colors.white,
//                               ),
//                             ),
//                             const SizedBox(width: 5),
//                             const Icon(
//                               Icons.shopping_cart_checkout_sharp,
//                               color: Colors.white,
//                               size: 15,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }

//   // Widget _buildBottomNav() {
//   //   return
//   //   // Obx(
//   //   //   () =>
//   //   Container(
//   //     padding: const EdgeInsets.all(16),
//   //     decoration: const BoxDecoration(
//   //       color: Colors.white,
//   //       border: Border(top: BorderSide(color: Colors.black12)),
//   //     ),
//   //     child: SafeArea(
//   //       child: Row(
//   //         children: [
//   //           Expanded(
//   //             child: UElevatedBUtton(
//   //               onPressed: () => Navigator.pop(context),
//   //               outlined: true,
//   //               child: Center(
//   //                 child: Text(
//   //                   'Back',
//   //                   style: AppTextStyles.bodyMedium(color: Ucolors.primary),
//   //                 ),
//   //               ),
//   //             ),
//   //           ),
//   //           const SizedBox(width: 16),
//   //           Expanded(
//   //             child: Obx(
//   //               () => UElevatedBUtton(
//   //                 // onPressed: () {
//   //                 //   if (_selectedIndex != -1 && controller.state != null) {
//   //                 //     Get.toNamed(
//   //                 //       AppRoutes.cart,
//   //                 //       // arguments: controller.state![_selectedIndex],
//   //                 //     );
//   //                 //   } else {
//   //                 //     Get.snackbar(
//   //                 //       "Selection Required",
//   //                 //       "Please select a fund to proceed",
//   //                 //     );
//   //                 //   }
//   //                 // },
//   //                 // onPressed:
//   //                 //  controller.selectedFunds.isEmpty
//   //                 //     ? null // Disable if nothing selected
//   //                 //     : () {
//   //                 //         Get.toNamed(
//   //                 //           AppRoutes.cart,
//   //                 //           // arguments: controller.selectedFunds.toList(),
//   //                 //         );
//   //                 //       },
//   //                 onPressed: controller.selectedFunds.isNotEmpty
//   //                     ? () => controller.proceedToCart()
//   //                     : null,
//   //                 child: Center(
//   //                   child: Text(
//   //                     'Add to Cart ${controller.selectedFunds.length}',
//   //                     style: AppTextStyles.bodyMedium(color: Colors.white),
//   //                   ),
//   //                 ),
//   //               ),
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //       // ),
//   //     ),
//   //   );
//   // }
// }
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/common/widget/text_form/text_field_component.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/divider/thick_divider.dart';
import 'package:my_sip/core/utils/enums/enums.dart';
import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';
import 'package:my_sip/features/explore/presentation/controller/fundhouse_controller.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/features/explore/presentation/pages/explore.dart';
import 'package:my_sip/features/fund_details/presentation/pages/fund_deatails.dart';
import 'package:my_sip/features/fund_details/presentation/widgets/helper.dart';
import '../controllers/sip_process_controller.dart';

class SelectFundsScreen extends StatefulWidget {
  const SelectFundsScreen({super.key});

  @override
  State<SelectFundsScreen> createState() => _SelectFundsScreenState();
}

class _SelectFundsScreenState extends State<SelectFundsScreen> {
  final SipProcessController controller = Get.find<SipProcessController>();

  final styleTags = [
    "12 - 15 % CAGR",
    "Medium Volatility",
    "Ideal for 5+ Years",
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: isDesktop ? Colors.transparent : Ucolors.primary,

      bottomNavigationBar: isDesktop ? null : _buildBottomNav(),

      body: SafeArea(
        child: isDesktop
            ? _buildWebLayout(context)
            : _buildMobileLayout(context),
      ),
    );
  }

  Widget _buildWebLayout(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 900,
        ), // Perfect width for lists
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Sip Fund",
                  style: AppTextStyles.h2(color: Ucolors.dark),
                ),
                const SizedBox(height: 8),
                Text(
                  "Review and add shortlisted funds to your cart.",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                const SizedBox(height: 32),

                // --- Content ---
                _buildInfoSection(isWeb: true),
                const SizedBox(height: 20),
                const ThickDivider(),
                const SizedBox(height: 20),
                _buildListTitle(isWeb: true),
                const SizedBox(height: 15),

                // Fund List
                _buildFundList(),

                const SizedBox(height: 40),
                Divider(color: Colors.grey.shade200),
                const SizedBox(height: 24),

                // --- Action Buttons (Web) ---
                _buildWebBottomActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildAppBar(),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection(isWeb: false),
                  const ThickDivider(),
                  const SizedBox(height: 20),
                  _buildListTitle(isWeb: false),
                  const SizedBox(height: 15),
                  _buildFundList(),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 12.0,
                    ),
                    child: InkWell(
                      onTap: () => _showExploreMoreBottomSheet(context),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Explore more funds',
                              style: AppTextStyles.bodyMediumBold().copyWith(
                                color: Ucolors.primary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                              color: Ucolors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showExploreMoreBottomSheet(BuildContext context) {
    final mutualController = Get.find<MutualFundController>();
    final FocusNode searchFocus = FocusNode();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.96,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 16),
                    height: 5,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Discover Funds",
                            style: AppTextStyles.h2(color: Ucolors.dark),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Search and select funds for your portfolio.",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Get.back(),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Obx(() {
                        final fundController = Get.find<FundhouseController>();
                        final int filterCount =
                            fundController.activeFilterCount;

                        return Badge(
                          isLabelVisible: filterCount > 0,
                          backgroundColor: Ucolors.primary,
                          label: Text(
                            '$filterCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          alignment: const Alignment(0.7, -0.7),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              shape: BoxShape.circle,
                            ),
                            child: CompactIcon(
                              icon: Icons.tune,
                              onPressed: () async {
                                final result = await Get.toNamed(
                                  AppRoutes.filterpage,
                                );
                                if (result != null &&
                                    result is Map<String, dynamic>) {
                                  mutualController.applyFilters(result);
                                }
                              },
                            ),
                          ),
                        );
                      }),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        height: 30,
                        width: 1,
                        color: Colors.grey.shade300,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: Obx(() {
                            final bool isSearching =
                                mutualController.hasSearchFocus.value;

                            return Row(
                              children: [
                                Expanded(
                                  child: SearchBar(
                                    onTap: () =>
                                        mutualController.setSearchFocus(true),
                                    onTapOutside: (event) {
                                      searchFocus.unfocus();
                                      mutualController.setSearchFocus(false);
                                    },
                                    focusNode: searchFocus,
                                    backgroundColor: MaterialStateProperty.all(
                                      Colors.grey.shade50,
                                    ),
                                    leading: Icon(
                                      Icons.search,
                                      color: Colors.grey.shade600,
                                    ),
                                    hintText: 'Search mutual funds...',
                                    hintStyle: MaterialStateProperty.all(
                                      TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    onChanged: (value) => mutualController
                                        .onSearchQueryChanged(value),
                                    elevation: MaterialStateProperty.all(0),
                                    side: MaterialStateProperty.all(
                                      BorderSide(color: Colors.grey.shade200),
                                    ),
                                  ),
                                ),
                                if (!isSearching) ...[
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () =>
                                        mutualController.cycleGlobalSort(),
                                    borderRadius: BorderRadius.circular(14),
                                    child: _FilterChip(
                                      label: mutualController
                                          .currentSortLabel
                                          .value,
                                      icon: Icons.sort,
                                      isSelected:
                                          mutualController
                                              .currentSortLabel
                                              .value !=
                                          "1Y,3Y,5Y",
                                    ),
                                  ),
                                ],
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.grey.shade200, height: 20),

                Expanded(
                  child: Obx(() {
                    if (mutualController.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Ucolors.primary,
                        ),
                      );
                    }

                    if (mutualController.searchFund.isEmpty) {
                      return Center(
                        child: Text(
                          "No mutual funds found",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount:
                          mutualController.searchFund.length +
                          (mutualController.isMoreLoading.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == mutualController.searchFund.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Ucolors.primary,
                                ),
                              ),
                            ),
                          );
                        }

                        final fund = mutualController.searchFund[index];
                        return Obx(() {
                          final isSelected = controller.isSelected(
                            fund.schemeCode ?? "",
                          );

                          return Stack(
                            children: [
                              MutualFundCard(
                                entity: fund,
                                onTapOverride: () {
                                  FocusScope.of(context).unfocus();
                                  controller.toggleSelection(fund);
                                },
                              ),

                              if (isSelected)
                                Positioned.fill(
                                  child: IgnorePointer(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Ucolors.primary.withOpacity(
                                          0.05,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Ucolors.primary,
                                          width: 2,
                                        ),
                                      ),
                                      child: const Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: EdgeInsets.all(12.0),
                                          child: Icon(
                                            Icons.check_circle,
                                            color: Ucolors.primary,
                                            size: 26,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        });

                        // return Obx(() {
                        //   // Check if this specific fund is currently selected in your SIP list
                        //   final isSelected = controller.isSelected(
                        //     fund.schemeCode ?? "",
                        //   );

                        //   return Stack(
                        //     children: [
                        //       // The actual card UI
                        //       MutualFundCard(entity: fund),

                        //       // Modern Highlight Overlay
                        //       Positioned.fill(
                        //         child: Padding(
                        //           padding: const EdgeInsets.symmetric(
                        //             horizontal: 16,
                        //             vertical: 8,
                        //           ),
                        //           child: Material(
                        //             color: isSelected
                        //                 ? Ucolors.primary.withOpacity(0.08)
                        //                 : Colors.transparent,
                        //             borderRadius: BorderRadius.circular(16),
                        //             child: InkWell(
                        //               borderRadius: BorderRadius.circular(16),
                        //               onTap: () {
                        //                 FocusScope.of(
                        //                   context,
                        //                 ).unfocus(); // Dismiss keyboard
                        //                 controller.toggleSelection(
                        //                   fund,
                        //                 ); // Toggle state
                        //               },
                        //               child: Container(
                        //                 decoration: BoxDecoration(
                        //                   borderRadius: BorderRadius.circular(
                        //                     16,
                        //                   ),
                        //                   border: Border.all(
                        //                     color: isSelected
                        //                         ? Ucolors.primary
                        //                         : Colors.transparent,
                        //                     width: 2,
                        //                   ),
                        //                 ),
                        //                 child: isSelected
                        //                     ? const Align(
                        //                         alignment: Alignment.topRight,
                        //                         child: Padding(
                        //                           padding: EdgeInsets.all(12.0),
                        //                           child: Icon(
                        //                             Icons.check_circle,
                        //                             color: Ucolors.primary,
                        //                             size: 26,
                        //                           ),
                        //                         ),
                        //                       )
                        //                     : null,
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   );
                        // });
                      },
                    );
                  }),
                ),

                // --- 4. FLOATING "DONE" BUTTON ---
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Obx(() {
                    final selectedCount = controller.selectedFunds.length;

                    return UElevatedBUtton(
                      onPressed: () => Get.back(), // Closes the bottom sheet
                      child: Center(
                        child: Text(
                          selectedCount > 0
                              ? 'Add $selectedCount Funds to SIP'
                              : 'Done',
                          style: AppTextStyles.bodyMedium(color: Colors.white),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // void _showExploreMoreBottomSheet(BuildContext context) {
  //   // Assuming MutualFundController manages the explore search/list state
  //   final mutualController = Get.find<MutualFundController>();
  //   final FocusNode searchFocus = FocusNode();

  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled:
  //         true, // Allows the sheet to take up most of the screen
  //     backgroundColor: Colors.white,
  //     useSafeArea: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
  //     ),
  //     builder: (BuildContext context) {
  //       return DraggableScrollableSheet(
  //         initialChildSize: 0.9, // Opens to 90% height
  //         minChildSize: 0.5,
  //         maxChildSize: 0.95,
  //         expand: false,
  //         builder: (context, scrollController) {
  //           return Column(
  //             children: [
  //               // --- 1. Drag Handle ---
  //               Center(
  //                 child: Container(
  //                   margin: const EdgeInsets.only(top: 12, bottom: 8),
  //                   height: 5,
  //                   width: 50,
  //                   decoration: BoxDecoration(
  //                     color: Colors.grey.shade300,
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                 ),
  //               ),

  //               // --- 2. Search & Filter Bar (No Title) ---
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(
  //                   horizontal: 16,
  //                   vertical: 8,
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     Obx(() {
  //                       final fundController = Get.find<FundhouseController>();
  //                       final int filterCount =
  //                           fundController.activeFilterCount;

  //                       return Badge(
  //                         isLabelVisible: filterCount > 0,
  //                         backgroundColor: Ucolors.primary,
  //                         label: Text(
  //                           '$filterCount',
  //                           style: const TextStyle(
  //                             color: Colors.white,
  //                             fontSize: 10,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                         padding: const EdgeInsets.symmetric(horizontal: 4),
  //                         alignment: const Alignment(0.7, -0.7),
  //                         child: Container(
  //                           padding: const EdgeInsets.all(8),
  //                           decoration: BoxDecoration(
  //                             border: Border.all(color: Ucolors.borderColor),
  //                             shape: BoxShape.circle,
  //                           ),
  //                           child: CompactIcon(
  //                             icon: Icons.tune,
  //                             onPressed: () async {
  //                               final result = await Get.toNamed(
  //                                 AppRoutes.filterpage,
  //                               );
  //                               if (result != null &&
  //                                   result is Map<String, dynamic>) {
  //                                 mutualController.applyFilters(result);
  //                               }
  //                             },
  //                           ),
  //                         ),
  //                       );
  //                     }),
  //                     Container(
  //                       margin: const EdgeInsets.symmetric(horizontal: 10),
  //                       height: 30,
  //                       width: 1,
  //                       color: Ucolors.borderside,
  //                     ),
  //                     Expanded(
  //                       child: SizedBox(
  //                         height: 40,
  //                         child: Obx(() {
  //                           final bool isSearching =
  //                               mutualController.hasSearchFocus.value;

  //                           return Row(
  //                             children: [
  //                               Expanded(
  //                                 child: SearchBar(
  //                                   onTap: () =>
  //                                       mutualController.setSearchFocus(true),
  //                                   onTapOutside: (event) {
  //                                     searchFocus.unfocus();
  //                                     mutualController.setSearchFocus(false);
  //                                   },
  //                                   focusNode: searchFocus,
  //                                   backgroundColor: MaterialStateProperty.all(
  //                                     Colors.white,
  //                                   ),
  //                                   leading: const Icon(Icons.search),
  //                                   hintText: 'Search',
  //                                   onChanged: (value) => mutualController
  //                                       .onSearchQueryChanged(value),
  //                                   elevation: MaterialStateProperty.all(0),
  //                                   side: MaterialStateProperty.all(
  //                                     BorderSide(color: Colors.grey.shade300),
  //                                   ),
  //                                 ),
  //                               ),
  //                               if (!isSearching) ...[
  //                                 const SizedBox(width: 8),
  //                                 InkWell(
  //                                   onTap: () =>
  //                                       mutualController.cycleGlobalSort(),
  //                                   child: _FilterChip(
  //                                     label: mutualController
  //                                         .currentSortLabel
  //                                         .value,
  //                                     icon: Icons.sort,
  //                                     isSelected:
  //                                         mutualController
  //                                             .currentSortLabel
  //                                             .value !=
  //                                         "1Y,3Y,5Y",
  //                                   ),
  //                                 ),
  //                               ],
  //                             ],
  //                           );
  //                         }),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               const Divider(),

  //               // --- 3. Dynamic Fund List ---
  //               Expanded(
  //                 child: Obx(() {
  //                   if (mutualController.isLoading.value) {
  //                     return const Center(
  //                       child: CircularProgressIndicator(
  //                         color: Ucolors.primary,
  //                       ),
  //                     );
  //                   }

  //                   if (mutualController.searchFund.isEmpty) {
  //                     return const Center(child: Text("No mutual funds found"));
  //                   }

  //                   return ListView.builder(
  //                     controller: scrollController,
  //                     itemCount:
  //                         mutualController.searchFund.length +
  //                         (mutualController.isMoreLoading.value ? 1 : 0),
  //                     itemBuilder: (context, index) {
  //                       // Show Loading Spinner at the bottom if fetching more
  //                       if (index == mutualController.searchFund.length) {
  //                         return const Padding(
  //                           padding: EdgeInsets.symmetric(vertical: 24),
  //                           child: Center(
  //                             child: SizedBox(
  //                               height: 24,
  //                               width: 24,
  //                               child: CircularProgressIndicator(
  //                                 strokeWidth: 2.5,
  //                                 color: Ucolors.primary,
  //                               ),
  //                             ),
  //                           ),
  //                         );
  //                       }

  //                       final fund = mutualController.searchFund[index];

  //                       // Wrap the card in a gesture detector to allow adding it to SipProcessController
  //                       // If you just return the card, it will use its
  //                       // default behavior (navigating to the details screen)
  //                       return MutualFundCard(entity: fund);
  //                       // return Stack(
  //                       //   children: [
  //                       //     MutualFundCard(entity: fund),

  //                       //     // Optional: An invisible tap layer so when they click the card
  //                       //     // inside the bottom sheet, it adds it to the current screen's SIP list
  //                       //     Positioned.fill(
  //                       //       child: Material(
  //                       //         color: Colors.transparent,
  //                       //         child: InkWell(
  //                       //           borderRadius: BorderRadius.circular(16),
  //                       //           onTap: () {
  //                       //             // 1. Add it to the selection on the screen underneath
  //                       //             controller.toggleSelection(fund);

  //                       //             // 2. Optionally close the bottom sheet
  //                       //             // Get.back();
  //                       //             // Get.snackbar(
  //                       //             //   "Added",
  //                       //             //   "${fund.baseSchemeName} added to your list",
  //                       //             //   snackPosition: SnackPosition.TOP,
  //                       //             // );
  //                       //           },
  //                       //         ),
  //                       //       ),
  //                       //     ),
  //                       //   ],
  //                       // );
  //                     },
  //                   );
  //                 }),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  Widget _buildWebBottomActions() {
    return Obx(() {
      final selectedCount = controller.selectedFunds.length;
      final totalAmount = controller.totalSelectedAmount;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (selectedCount > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Total Amount ($selectedCount funds): ",
                  style: AppTextStyles.bodyMedium(color: Colors.grey.shade600),
                ),
                Text(
                  controller.formatCurrency(totalAmount),
                  style: AppTextStyles.bodyLargeBold(color: Ucolors.primary),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 140,
                child: UElevatedBUtton(
                  onPressed: () => Get.back(id: 1),
                  outlined: true,
                  child: Center(
                    child: Text(
                      'Back',
                      style: AppTextStyles.bodyMedium(color: Ucolors.primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 200,
                child: UElevatedBUtton(
                  onPressed: controller.selectedFunds.isNotEmpty
                      ? controller.proceedToCart
                      : null,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add to Cart',
                          style: AppTextStyles.bodyMedium(color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.shopping_cart_checkout_sharp,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildFundList() {
    return controller.obx(
      (state) => ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: state?.length ?? 0,
        separatorBuilder: (c, i) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _buildSchemeCard(state![index], index),
      ),
      onLoading: const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(),
        ),
      ),
      onEmpty: const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text("No Funds available"),
        ),
      ),
      onError: (error) => Center(child: Text("Error: $error")),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(UImages.mfLogoLight, height: 20),
          const SizedBox(width: 10),
          Text(
            UText.freedomSipTitle,
            style: AppTextStyles.bodyLarge(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection({required bool isWeb}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: isWeb ? 0 : 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isWeb) const SizedBox(height: 15.0),
          Text(
            "Balanced Investing Style",
            style: AppTextStyles.bodyLargeBold(),
          ),
          Text(
            "Investing in fundamentally strong, well-managed companies.",
            style: AppTextStyles.bodySmall(size: 10, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: styleTags.map((tag) => _buildTag(tag)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        tag,
        style: AppTextStyles.bodySmall(size: 10, color: Colors.black87),
      ),
    );
  }

  Widget _buildListTitle({required bool isWeb}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 0 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "List Of Shortlisted high growth funds.",
            style: AppTextStyles.bodyMediumBold(),
          ),
          Text(
            "By MF radiant Finworld Team",
            style: AppTextStyles.bodySmall(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Obx(() {
      final selectedCount = controller.selectedFunds.length;
      final totalAmount = controller.totalSelectedAmount;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
          border: const Border(top: BorderSide(color: Colors.black12)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selectedCount > 0) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Amount ($selectedCount funds)",
                      style: AppTextStyles.bodySmall(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      controller.formatCurrency(totalAmount),
                      style: AppTextStyles.bodyMediumBold(
                        color: Ucolors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              Row(
                children: [
                  Expanded(
                    child: UElevatedBUtton(
                      onPressed: () => Navigator.pop(context),
                      outlined: true,
                      child: Center(
                        child: Text(
                          'Back',
                          style: AppTextStyles.bodyMedium(
                            color: Ucolors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: UElevatedBUtton(
                      onPressed: controller.selectedFunds.isNotEmpty
                          ? controller.proceedToCart
                          : null,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Add to Cart',
                              style: AppTextStyles.bodyMedium(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.shopping_cart_checkout_sharp,
                              color: Colors.white,
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSchemeCard(MutualFundListEntity fund, int index) {
    return Obx(() {
      final isSelected = controller.isSelected(fund.schemeCode ?? "");
      return GestureDetector(
        onTap: () => controller.toggleSelection(fund),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? Ucolors.primary.withOpacity(0.05)
                : Colors.white,
            border: Border.all(
              color: isSelected ? Ucolors.primary : Colors.grey.shade300,
              width: isSelected ? 1.5 : 1.0,
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: CustomCachedImage(
                      imageUrl: '${Appurl.baseUrl}${fund.amc?.amcLogoUrl}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      fund.baseSchemeName ?? "Unknown Fund",
                      style: AppTextStyles.bodyMediumSemiBold(
                        size: 14,
                      ), // Slightly increased font
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle,
                      color: Ucolors.primary,
                      size: 24,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              DashedLine(color: Colors.grey.shade300),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (isSelected) ...[
                    // Details for selected state
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              color: getRiskMeter(fund.riskLevel).color,
                              size: 10,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              fund.riskLevel ?? "N/A",
                              style: AppTextStyles.bodySmall(
                                color: getRiskMeter(fund.riskLevel).color,
                                size: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              "SIP Returns (1Y): ",
                              style: AppTextStyles.bodySmall(
                                color: Colors.grey.shade700,
                                size: 12,
                              ),
                            ),
                            Text(
                              "${fund.returnsEntity?.oneYear ?? '0.0'}%",
                              style: AppTextStyles.bodySmallBold(
                                color: Colors.green,
                                size: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        validationType: ValidationType.custom,
                        keyboardType: TextInputType.number,
                        height: 48, // Slightly taller for web
                        controller: controller.getTextController(
                          fund.schemeCode ?? "",
                        ),
                        onChanged: (val) => controller.updateFundAmount(
                          fund.schemeCode ?? "",
                          val,
                        ),
                        customValidator: (value) {
                          if (value == null || value.isEmpty) return "Required";
                          final enteredAmount = int.tryParse(value) ?? 0;
                          final minAmount = fund.minSipAmount ?? 500;
                          if (enteredAmount < minAmount)
                            return "Min. ₹$minAmount required";
                          if (enteredAmount % 100 != 0)
                            return "Must be multiple of ₹100";
                          return null;
                        },
                      ),
                    ),
                  ],
                  if (!isSelected) ...[
                    // Details for unselected state
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: getRiskMeter(fund.riskLevel).color,
                          size: 10,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          fund.riskLevel ?? "N/A",
                          style: AppTextStyles.bodySmall(
                            color: getRiskMeter(fund.riskLevel).color,
                            size: 12,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "SIP Returns (1Y): ",
                          style: AppTextStyles.bodySmall(
                            color: Colors.grey.shade700,
                            size: 12,
                          ),
                        ),
                        Text(
                          "${fund.returnsEntity?.oneYear ?? '0.0'}%",
                          style: AppTextStyles.bodySmallBold(
                            color: Colors.green,
                            size: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  const _FilterChip({required this.label, this.icon, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Ucolors.textFormEnabled : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelSmall!.copyWith(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
