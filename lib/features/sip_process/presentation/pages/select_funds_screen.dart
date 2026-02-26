// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:my_sip/config/routes/app_routes.dart';
// import 'package:my_sip/features/freedom_sip/presentation/widgets/sip_amount_selector.dart';
// import 'package:my_sip/features/sip_process/presentation/widgets/sip_projection_chart.dart';
// import '../../../../common/widget/button/elevated_button.dart';
// import '../../../../common/widget/divider/thick_divider.dart';
// import '../../../../core/utils/constant/colors.dart';
// import '../../../../core/utils/constant/images.dart';
// import '../../../../core/utils/constant/text.dart';
// import '../../../../core/utils/constant/text_style.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';

// import '../../domain/entity/fund_entity.dart';
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
//       body: SafeArea(
//         top: true,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SvgPicture.asset(UImages.mfLogoLight, height: 20),
//                     const SizedBox(width: 10),
//                     Text(
//                       UText.freedomSipTitle,
//                       style: AppTextStyles.bodyLarge(color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10.0),

//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Container(
//                   width: double.infinity,
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 8.0,
//                           horizontal: 30,
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(height: 15.0),
//                             Text(
//                               "Balanced Investing Style",
//                               style: AppTextStyles.bodyLargeBold(),
//                             ),
//                             RichText(
//                               maxLines: 2,
//                               text: TextSpan(
//                                 text:
//                                     "Investing in fundamentally strong, well-managed companies with",
//                                 style: AppTextStyles.bodySmall(
//                                   size: 10,
//                                   color: Colors.grey,
//                                 ),
//                                 children: [
//                                   TextSpan(
//                                     text: " Know More",
//                                     style: AppTextStyles.bodySmallSemiBold(
//                                       color: Colors.black45,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 5),
//                             Wrap(
//                               spacing: 4.0,
//                               runSpacing: 4.0,
//                               children: styleTags.map((tag) {
//                                 return Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 12.0,
//                                     vertical: 6.0,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey.withAlpha(40),
//                                     borderRadius: BorderRadius.circular(20.0),
//                                   ),
//                                   child: Text(
//                                     tag,
//                                     style: AppTextStyles.bodySmall(
//                                       size: 9,
//                                       color: Colors.black54,
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                             ),
//                           ],
//                         ),
//                       ),

//                       const ThickDivider(),
//                       const SizedBox(height: 20),

//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "List Of Shortlisted high growth funds.",
//                               style: AppTextStyles.bodyMediumBold(),
//                             ),
//                             Text(
//                               "By MF radiant Finworld Team",
//                               style: AppTextStyles.bodySmall(
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 15),

//                       controller.obx(
//                         (state) => ListView.separated(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 20,
//                             vertical: 10,
//                           ),
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: state?.length ?? 0,
//                           separatorBuilder: (c, i) =>
//                               const SizedBox(height: 12),
//                           itemBuilder: (context, index) {
//                             return _buildSchemeCard(state![index], index);
//                           },
//                         ),

//                         onLoading: const Padding(
//                           padding: EdgeInsets.all(40.0),
//                           child: Center(child: CircularProgressIndicator()),
//                         ),

//                         onError: (error) => Padding(
//                           padding: const EdgeInsets.all(20.0),
//                           child: Center(child: Text("Error: $error")),
//                         ),
//                       ),

//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, -5),
//             ),
//           ],
//         ),
//         child: SafeArea(
//           child: Row(
//             children: [
//               Expanded(
//                 child: UElevatedBUtton(
//                   onPressed: () => Navigator.pop(context),
//                   outlined: true,
//                   child: Center(
//                     child: Text(
//                       'Back',
//                       style: AppTextStyles.bodyMedium(color: Ucolors.primary),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: UElevatedBUtton(
//                   onPressed: () {
//                     if (_selectedIndex != -1 && controller.state != null) {
//                       final selectedFund = controller.state![_selectedIndex];
//                       Get.toNamed(
//                         // AppRoutes.investingApproachScreen,
//                         AppRoutes.cart,
//                         arguments: selectedFund,
//                       );
//                     } else {
//                       Get.snackbar(
//                         "Selection Required",
//                         "Please select a fund to proceed",
//                       );
//                     }
//                   },
//                   child: Center(
//                     child: Text(
//                       'Next',
//                       style: AppTextStyles.bodyMedium(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSchemeCard(FundEntity fund, int index) {
//     final isSelected = _selectedIndex == index;

//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedIndex = index;
//         });
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isSelected ? Ucolors.primary.withOpacity(0.1) : Colors.white,
//           border: Border.all(
//             color: isSelected ? Ucolors.primary : Colors.grey.shade300,
//             width: isSelected ? 1.5 : 1.0,
//           ),
//           borderRadius: BorderRadius.circular(15.0),
//         ),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 18,
//                   backgroundColor: Colors.transparent,
//                   backgroundImage: AssetImage(fund.icon),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Text(
//                     fund.name,
//                     style: AppTextStyles.bodyMediumSemiBold(),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Divider(color: Colors.grey.shade300, thickness: 1),
//             const SizedBox(height: 10),

//             FittedBox(
//               fit: BoxFit.scaleDown,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       const Icon(Icons.circle, color: Colors.red, size: 8),
//                       const SizedBox(width: 4),
//                       Text(
//                         fund.riskType,
//                         style: AppTextStyles.bodySmall(
//                           color: Colors.grey,
//                           size: 11,
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(width: 12),

//                   Row(
//                     children: [
//                       Text(
//                         "SIP Returns: ",
//                         style: AppTextStyles.bodySmall(
//                           color: Colors.grey,
//                           size: 11,
//                         ),
//                       ),
//                       Text(
//                         fund.sipReturns,
//                         style: AppTextStyles.bodySmall(
//                           color: Colors.green,
//                           size: 11,
//                         ),
//                       ),
//                       Text(
//                         " pa",
//                         style: AppTextStyles.bodySmall(color: Colors.grey),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(width: 12),

//                   Row(
//                     children: [
//                       Text(
//                         "Rating: ",
//                         style: AppTextStyles.bodySmall(
//                           color: Colors.grey,
//                           size: 11,
//                         ),
//                       ),
//                       const Icon(Icons.star, color: Colors.amber, size: 12),
//                       Text(
//                         " ${fund.rating}",
//                         style: AppTextStyles.bodySmall(
//                           color: Colors.black,
//                           size: 11,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/divider/thick_divider.dart';
import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';
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
  int _selectedIndex = -1;

  final styleTags = [
    "12 - 15 % CAGR",
    "Medium Volatility",
    "Ideal for 5+ Years",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Ucolors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildAppBar(),
              const SizedBox(height: 10.0),
              _buildContent(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
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

  Widget _buildContent() {
    return Padding(
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
            _buildInfoSection(),
            const ThickDivider(),
            const SizedBox(height: 20),
            _buildListTitle(),
            const SizedBox(height: 15),
            // RECOGNIZES MutualFundListEntity STATE
            controller.obx(
              (state) => ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state?.length ?? 0,
                separatorBuilder: (c, i) => const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    _buildSchemeCard(state![index], index),
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
                  child: Text("No Best SIP Funds available"),
                ),
              ),
              onError: (error) => Center(child: Text("Error: $error")),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSchemeCard(MutualFundListEntity fund, int index) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Ucolors.primary.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? Ucolors.primary : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1.0,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Icon and Name
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
                    style: AppTextStyles.bodyMediumSemiBold(size: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            DashedLine(color: Colors.grey.shade300),
            const SizedBox(height: 10),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Risk Level
                Icon(
                  Icons.circle,
                  color: getRiskMeter(fund.riskLevel).color,
                  size: 10,
                ),

                const SizedBox(width: 3),
                Text(
                  fund.riskLevel ?? "N/A",
                  style: AppTextStyles.bodySmall(
                    color: getRiskMeter(fund.riskLevel).color,
                    size: 10,
                  ),
                ),
                const SizedBox(width: 20),
                // SIP Returns
                Text(
                  "SIP Returns (3Y): ",
                  style: AppTextStyles.bodySmall(
                    color: Colors.grey.shade700,
                    size: 10,
                  ),
                ),
                Text(
                  "${fund.returnsEntity?.threeYear ?? '0.0'}%",
                  style: AppTextStyles.bodySmall(color: Colors.green, size: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildSchemeCard(MutualFundListEntity fund, int index) {
  //   final isSelected = _selectedIndex == index;

  //   return GestureDetector(
  //     onTap: () => setState(() => _selectedIndex = index),
  //     child: AnimatedContainer(
  //       duration: const Duration(milliseconds: 200),
  //       padding: const EdgeInsets.all(12),
  //       decoration: BoxDecoration(
  //         color: isSelected ? Ucolors.primary.withOpacity(0.1) : Colors.white,
  //         border: Border.all(
  //           color: isSelected ? Ucolors.primary : Colors.grey.shade300,
  //           width: isSelected ? 1.5 : 1.0,
  //         ),
  //         borderRadius: BorderRadius.circular(15.0),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               Expanded(
  //                 child: Text(
  //                   fund.baseSchemeName ?? "N/A",
  //                   style: AppTextStyles.bodyMediumSemiBold(),
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //               ),
  //               if (isSelected) const Icon(Icons.check_circle, color: Ucolors.primary, size: 20),
  //             ],
  //           ),
  //           const SizedBox(height: 8),
  //           Row(
  //             children: [
  //               Text("Risk: ${fund.riskLevel ?? 'Moderate'}", style: AppTextStyles.bodySmall(color: Colors.orange, size: 10)),
  //               const Spacer(),
  //               const Icon(Icons.star, color: Colors.amber, size: 12),
  //               Text(" ${fund.riskLevel ?? '0'}", style: AppTextStyles.bodySmall(size: 11)),
  //             ],
  //           ),
  //           const Divider(),
  //           // DISPLAYING TRAILING RETURNS
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               _returnItem("1Y", fund.returnsEntity?.oneYear),
  //               _returnItem("3Y", fund.returnsEntity?.threeYear),
  //               _returnItem("5Y", fund.returnsEntity?.fiveYear),
  //             ],
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _returnItem(String label, dynamic value) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall(size: 9, color: Colors.grey),
        ),
        Text(
          "${value ?? '0.0'}%",
          style: AppTextStyles.bodySmall(size: 10, color: Colors.green),
        ),
      ],
    );
  }

  // --- Helper Widgets ---
  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15.0),
          Text(
            "Balanced Investing Style",
            style: AppTextStyles.bodyLargeBold(),
          ),
          Text(
            "Investing in fundamentally strong, well-managed companies.",
            style: AppTextStyles.bodySmall(size: 10, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 4.0,
            children: styleTags.map((tag) => _buildTag(tag)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        tag,
        style: AppTextStyles.bodySmall(size: 8, color: Colors.black54),
      ),
    );
  }

  Widget _buildListTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black12)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: UElevatedBUtton(
                onPressed: () => Navigator.pop(context),
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
            Expanded(
              child: UElevatedBUtton(
                onPressed: () {
                  if (_selectedIndex != -1 && controller.state != null) {
                    Get.toNamed(
                      AppRoutes.cart,
                      // arguments: controller.state![_selectedIndex],
                    );
                  } else {
                    Get.snackbar(
                      "Selection Required",
                      "Please select a fund to proceed",
                    );
                  }
                },
                child: Center(
                  child: Text(
                    'Next',
                    style: AppTextStyles.bodyMedium(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
