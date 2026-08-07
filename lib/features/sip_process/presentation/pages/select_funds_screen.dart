import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double isWideScreen = constraints.maxWidth * 0.9;

          final double availableHeight = constraints.maxHeight * 0.9;

          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWideScreen,
              maxHeight: availableHeight,
            ),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left Blue Panel (Your Profile Summary)
                  Expanded(flex: 4, child: _buildLeftProfilePanel()),

                  // Right White Panel (Fund Selection)
                  Expanded(flex: 6, child: _buildRightWhitePanel(context)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- LEFT PANEL: PROFILE SYSTEM ---
  Widget _buildLeftProfilePanel() {
    return Container(
      color: const Color(0xFF0061A0),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "BUILD YOUR WEALTH WITH SIP",
                style: TextStyle(
                  fontFamily: FontFamily.medium,
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          Row(
            children: const [
              Icon(Icons.check_circle_outline, color: Colors.white, size: 24),
              SizedBox(width: 10),
              Text(
                "Your Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildProfileDetailCard(
            icon: Icons.person_outline,
            title: "Investor Type",
            value: "Young Investor",
          ),
          const SizedBox(height: 16),
          _buildProfileDetailCard(
            icon: Icons.shield_outlined,
            title: "Risk Appetite",
            value: "High",
          ),
          const SizedBox(height: 16),
          Obx(
            () => _buildProfileDetailCard(
              icon: Icons.money,
              title: "Monthly SIP",
              value: controller.formatCurrency(controller.amount.value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetailCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- RIGHT PANEL: FUND SELECTION SYSTEM ---
  Widget _buildRightWhitePanel(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Funds",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF142438),
            ),
          ),
          const SizedBox(height: 8),
          // Make sure your dynamic profile styling matches here
          Text(
            "Based on your High risk profile. Choose one or more funds and enter how much you want to invest in each.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),

          // Scrollable Fund Container List Box
          Expanded(child: _buildWebFundList()),
          const SizedBox(height: 8),
          Divider(color: Colors.grey.shade200),
          const SizedBox(height: 8),
          _buildInvestedAmountRow(),
          const SizedBox(height: 8),
          Divider(color: Colors.grey.shade200),
          const SizedBox(height: 20),
          _buildWebActionButtons(),
        ],
      ),
    );
  }

  // --- FUND RENDERING LOOP ---
  Widget _buildWebFundList() {
    return controller.obx(
      (state) => ListView.separated(
        padding: const EdgeInsets.only(
          right: 8,
        ), // Padding allowance for scrollbar gap
        itemCount: state?.length ?? 0,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final fund = state![index];
          return _buildWebFundCard(fund, index);
        },
      ),
      onLoading: const Center(child: CircularProgressIndicator()),
      onEmpty: const Center(child: Text("No Funds available")),
      onError: (error) => Center(child: Text("Error: $error")),
    );
  }

  // --- SCHEME DATA CARD VIEW ---
  Widget _buildWebFundCard(MutualFundListEntity fund, int index) {
    return Obx(() {
      final isSelected = controller.isSelected(fund.schemeCode ?? "");
      final textController = controller.getTextController(
        fund.schemeCode ?? "",
      );

      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? Ucolors.primary : Colors.grey.shade300,
            width: isSelected ? 2.0 : 1.2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Top Row: Category Tag & Selection Checkbox ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Ucolors.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    fund.amc?.amcName ?? "Mutual Fund",
                    style: TextStyle(
                      fontSize: 11,
                      color: Ucolors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                  width: 20,
                  child: Checkbox(
                    value: isSelected,
                    activeColor: Ucolors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onChanged: (val) => controller.toggleSelection(fund),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // --- 2. Middle Row: AMC Logo & Fund Name ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CustomCachedImage(
                      imageUrl: '${Appurl.baseUrl}${fund.amc?.amcLogoUrl}',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    fund.baseSchemeName ?? "Unknown Fund",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF142438),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // --- 3. MOVED: Dashed Line Row Leading into Returns (Matches image_71e69a.png) ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: DashedLine(color: Colors.grey.shade300),
                      ),
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
                              size: 11,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            "4.0 Rating",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${fund.returnsEntity?.oneYear ?? '0.0'}%",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const Text(
                      "3Y RETURNS", // Changed from 1Y to 3Y to match your design view
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),

            // --- 5. Bottom Row: Contextual Amount Input Box (Cleaned up style) ---
            if (isSelected) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Amount in this fund (₹)",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: CustomTextField(
                      controller: textController,
                      validationType: ValidationType.custom,
                      keyboardType: TextInputType.number,
                      height: 40, // Reduced to clean 40px bounding box
                      borderRadius: 8,
                      bgColor: const Color(
                        0xFFF1F5F9,
                      ), // Perfectly smooth light grey/blue backdrop tint
                      borderColor: const Color(0xFFCBD5E1),
                      focusedBorderColor: Ucolors.primary,
                      onChanged: (val) => controller.updateFundAmount(
                        fund.schemeCode ?? "",
                        val,
                      ),
                      customValidator: (value) {
                        if (value == null || value.isEmpty) return "Required";
                        final enteredAmount = int.tryParse(value) ?? 0;
                        final minAmount = fund.minSipAmount ?? 500;
                        if (enteredAmount < minAmount)
                          return "Min. ₹$minAmount";
                        if (enteredAmount % 100 != 0) return "Multiple of ₹100";
                        return null;
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Vertical splitting separator line
                          Container(
                            width: 1,
                            height: 20,
                            color: const Color(0xFFCBD5E1),
                          ),
                          const SizedBox(width: 4),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Increment button (+100)
                              InkWell(
                                onTap: () {
                                  int current =
                                      int.tryParse(textController.text) ?? 0;
                                  int nextValue = current + 100;
                                  textController.text = nextValue.toString();
                                  controller.updateFundAmount(
                                    fund.schemeCode ?? "",
                                    nextValue.toString(),
                                  );
                                },
                                child: const Icon(
                                  Icons.keyboard_arrow_up_rounded,
                                  size: 11,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 1),
                              // Decrement button (-100)
                              InkWell(
                                onTap: () {
                                  int current =
                                      int.tryParse(textController.text) ?? 0;
                                  int minLimit = fund.minSipAmount ?? 500;
                                  int nextValue = current - 100;
                                  if (nextValue >= minLimit) {
                                    textController.text = nextValue.toString();
                                    controller.updateFundAmount(
                                      fund.schemeCode ?? "",
                                      nextValue.toString(),
                                    );
                                  }
                                },
                                child: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 11,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    });
  }

  // --- CONTEXT CALCULATOR STATS BAR ---
  Widget _buildInvestedAmountRow() {
    return Obx(() {
      final totalAmount = controller.totalSelectedAmount;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Invested Amount",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF142438),
            ),
          ),
          Text(
            controller.formatCurrency(totalAmount),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF142438),
            ),
          ),
        ],
      );
    });
  }

  // --- NAV BUTTON PANELS ---
  Widget _buildWebActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 120,
          child: UElevatedButtonWeb(
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
        Obx(
          () => SizedBox(
            width: 160,
            child: UElevatedButtonWeb(
              onPressed: controller.selectedFunds.isNotEmpty
                  ? controller.proceedToCart
                  : null,
              color: controller.selectedFunds.isNotEmpty
                  ? Ucolors.primary
                  : Colors.grey.shade400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add to Cart',
                    style: AppTextStyles.bodyMedium(color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
                              fontFamily: FontFamily.medium,
                              fontSize: 13,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          Navigator.of(context).pop();
                        },
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
                              fontFamily: FontFamily.medium,
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
                                    backgroundColor: WidgetStateProperty.all(
                                      Colors.grey.shade50,
                                    ),
                                    leading: Icon(
                                      Icons.search,
                                      color: Colors.grey.shade600,
                                    ),
                                    hintText: 'Search mutual funds...',
                                    hintStyle: WidgetStateProperty.all(
                                      TextStyle(
                                        fontFamily: FontFamily.medium,
                                        color: Colors.grey.shade500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    onChanged: (value) => mutualController
                                        .onSearchQueryChanged(value),
                                    elevation: WidgetStateProperty.all(0),
                                    side: WidgetStateProperty.all(
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
                      return const Align(
                        alignment: Alignment.topCenter,

                        child: CircularProgressIndicator(
                          color: Ucolors.primary,
                        ),
                      );
                    }

                    if (mutualController.searchFund.isEmpty) {
                      return Center(
                        child: Text(
                          "No mutual funds found",
                          style: TextStyle(
                            fontFamily: FontFamily.medium,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      );
                    }

                    return NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        // Check if we scrolled near the bottom (within 200 pixels)
                        if (scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent - 200) {
                          // Prevent spamming the API if it's already loading or has no more data
                          if (!mutualController.isMoreLoading.value &&
                              mutualController.canLoadMore) {
                            mutualController
                                .loadNextPage(); // Triggers your pagination API!
                          }
                        }
                        return false; // Return false so the sheet can still drag up/down normally
                      },

                      child: ListView.builder(
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
                                          color: Ucolors.primary.withValues(
                                            alpha: 0.05,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
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
                        },
                      ),
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
                        color: Colors.black.withValues(alpha: 0.05),
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
    ).whenComplete(() {
      mutualController.setSearchFocus(false);
      mutualController.handleRefresh();
    });
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
  //                           style: const TextStyle(fontFamily: FontFamily.medium,
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
  //                                   backgroundColor: WidgetStateProperty.all(
  //                                     Colors.white,
  //                                   ),
  //                                   leading: const Icon(Icons.search),
  //                                   hintText: 'Search',
  //                                   onChanged: (value) => mutualController
  //                                       .onSearchQueryChanged(value),
  //                                   elevation: WidgetStateProperty.all(0),
  //                                   side: WidgetStateProperty.all(
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
                  color: Ucolors.primary,

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
              color: Colors.black.withValues(alpha: 0.05),
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
                      color: Ucolors.primary,

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
                ? Ucolors.primary.withValues(alpha: 0.05)
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
// //               color: Colors.black.withValues(alpha:0.05),
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
// //           color: isSelected ? Ucolors.primary.withValues(alpha:0.1) : Colors.white,
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
//             color: isSelected ? Ucolors.primary.withValues(alpha:0.1) : Colors.white,
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
//   //         color: isSelected ? Ucolors.primary.withValues(alpha:0.1) : Colors.white,
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
//               color: Colors.black.withValues(alpha:0.05),
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
//                       //               style: TextStyle(fontFamily: FontFamily.medium,color: Colors.grey),
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
//                       //               style: TextStyle(fontFamily: FontFamily.medium,
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
