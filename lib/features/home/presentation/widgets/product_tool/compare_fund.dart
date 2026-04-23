import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/features/fund_details/domain/entity/fund_detail_entity.dart';
import 'package:my_sip/features/fund_details/domain/entity/portfolio_analysis_entity.dart';
import 'package:my_sip/features/fund_details/presentation/controllers/comparefund_controller.dart';
import 'package:my_sip/features/fund_details/presentation/pages/fund_deatails.dart'
    hide parseFundManagers;
import 'package:my_sip/features/wishlist/presentation/controller/wishlist_controller.dart';

class CompareFundsPage extends GetView<CompareFundController> {
  CompareFundsPage({super.key});

  final MutualFundController mutualFundController =
      Get.find<MutualFundController>();

  final CartController cartController = Get.find<CartController>();
  final WishlistController wishlistController = Get.find<WishlistController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.985),
      appBar: AppBar(
        centerTitle: true,
        leading: const BackButton(),
        title: const Text("Compare Funds"),
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          // Listen to Controller State
          final f1Basic = controller.fund1Basic.value;
          final f2Basic = controller.fund2Basic.value;
          final f1Detail = controller.fund1Detail.value;
          final f2Detail = controller.fund2Detail.value;
          final f1Port = controller.fund1Portfolio.value;
          final f2Port = controller.fund2Portfolio.value;

          return Column(
            children: [
              const Gap(12),

              // --- 1. HEADER SELECTION CARDS ---
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 12),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: CompareCard(
              //           fund: f1Basic,
              //           isLoading: controller.isFund1Loading.value,
              //           onTap: () => _openSearchSheet(context, 1),
              //           onRemove: () => controller.removeFund(1),
              //         ),
              //       ),
              //       const Gap(8),
              //       Expanded(
              //         child: CompareCard(
              //           fund: f2Basic,
              //           isLoading: controller.isFund2Loading.value,
              //           onTap: () => _openSearchSheet(context, 2),
              //           onRemove: () => controller.removeFund(2),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // --- 1. HEADER SELECTION CARDS ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    // FUND 1
                    Expanded(
                      child: CompareCardOption(
                        fund: f1Basic,
                        isLoading: controller.isFund1Loading.value,
                        onTap: () => _openSearchSheet(context, 1),
                        onRemove: () => controller.removeFund(1),
                        onAddToCart: () async {
                          if (f1Basic != null) {
                            await cartController.addToCart(
                              f1Basic.schemeCode ?? '',
                              f1Basic.baseSchemeName ?? '',
                              f1Basic.minSipAmount ?? 0,
                              null,
                            );
                          }
                        },
                        onAddToWishlist: () async {
                          if (f1Basic != null) {
                            await wishlistController.addToWishList(
                              f1Basic.schemeCode ?? '',
                              f1Basic.baseSchemeName ?? '',
                            );
                          }
                        },
                      ),
                    ),
                    const Gap(8),
                    // FUND 2
                    Expanded(
                      child: CompareCardOption(
                        fund: f2Basic,
                        isLoading: controller.isFund2Loading.value,
                        onTap: () => _openSearchSheet(context, 2),
                        onRemove: () => controller.removeFund(2),
                        onAddToCart: () async {
                          if (f2Basic != null) {
                            await cartController.addToCart(
                              f2Basic.schemeCode ?? '',
                              f2Basic.baseSchemeName ?? '',
                              f2Basic.minSipAmount ?? 0,
                              null,
                            );
                          }
                        },
                        onAddToWishlist: () async {
                          if (f2Basic != null) {
                            await wishlistController.addToWishList(
                              f2Basic.schemeCode ?? '',
                              f2Basic.baseSchemeName ?? '',
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(12),
              _compareTitle(),
              const SizedBox(height: 12),

              // --- 2. COMPARISON TABLES (Dynamic Data) ---
              DashedLine(dashSpace: 0, color: Colors.grey.shade300),
              CompareExpansion(
                title: "FUND DETAILS",
                child: FundDetailsTable(d1: f1Detail, d2: f2Detail),
              ),

              DashedLine(dashSpace: 0, color: Colors.grey.shade300),
              CompareExpansion(
                title: "RETURNS",
                child: CompareTable(data: _getReturnsData(f1Detail, f2Detail)),
              ),

              DashedLine(dashSpace: 0, color: Colors.grey.shade300),
              CompareExpansion(
                title: "TOP 5 HOLDINGS",
                // Pass Portfolio Entities here
                child: HoldingsCompareTable(p1: f1Port, p2: f2Port),
              ),

              DashedLine(dashSpace: 0, color: Colors.grey.shade300),
              CompareExpansion(
                title: "FUND MANAGERS",
                child: CompareTable(data: _getManagerData(f1Detail, f2Detail)),
              ),

              const Gap(50),
            ],
          );
        }),
      ),
    );
  }

  // --- DATA MAPPING HELPERS ---

  List<Map<String, dynamic>> _getReturnsData(
    FundDetailEntity? d1,
    FundDetailEntity? d2,
  ) {
    // Helper to extract return safely
    String ret(FundDetailEntity? d, String type) {
      if (d == null || d.schemePerformanceList.isEmpty) return "-";
      final p =
          d.schemePerformanceList.first; // Assuming 1st item is the Scheme

      switch (type) {
        case '1Y':
          return "${p.oneYearReturn}%";
        case '3Y':
          return "${p.threeYearReturn}%";
        case '5Y':
          return "${p.fiveYearReturn}%";
        case 'Inception':
          return "${d.schemeInceptionReturn}%";
        default:
          return "-";
      }
    }

    return [
      {
        "title": "1Y",
        "values": [ret(d1, '1Y'), ret(d2, '1Y')],
      },
      {
        "title": "3Y",
        "values": [ret(d1, '3Y'), ret(d2, '3Y')],
      },
      {
        "title": "5Y",
        "values": [ret(d1, '5Y'), ret(d2, '5Y')],
      },
      {
        "title": "Inception",
        "values": [ret(d1, 'Inception'), ret(d2, 'Inception')],
      },
    ];
  }

  List<Map<String, dynamic>> _getManagerData(
    FundDetailEntity? d1,
    FundDetailEntity? d2,
  ) {
    String formatManagers(String? raw) {
      final List<String> names = parseFundManagers(raw);

      if (names.isEmpty) return "-";

      return names.join("\n");
    }

    return [
      {
        "title": "Manager",
        "values": [
          formatManagers(d1?.schemeManager),
          formatManagers(d2?.schemeManager),
        ],
      },
    ];
  }

  void _openSearchSheet(BuildContext context, int slot) {
    mutualFundController.onSearchQueryChanged;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.96,
        minChildSize: 0.5,
        maxChildSize: 0.96,
        builder: (_, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Ucolors.primary,
                  width: double.infinity,
                  child: const Center(
                    child: Text(
                      "SEARCH MUTUAL FUNDS",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintText: "Search fund",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (val) =>
                        mutualFundController.onSearchQueryChanged(val),
                  ),
                ),

                // Fund List
                Expanded(
                  child: Obx(() {
                    final list = mutualFundController.searchFund;
                    if (mutualFundController.isLoading.value) {
                      return Align(
                        alignment: Alignment.topCenter,
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (list.isEmpty)
                      return const Center(child: Text("No funds found"));

                    return ListView.separated(
                      controller: scrollController,
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (ctx, index) {
                        final item = list[index];
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.grey.shade100,
                            // Placeholder icon since list entity doesn't have image
                            // child: const Icon(Icons.show_chart, size: 18),
                            child: CustomCachedImage(
                              imageUrl:
                                  '${Appurl.baseUrl}${item.amc?.amcLogoUrl}',
                            ),
                          ),
                          title: Text(
                            item.baseSchemeName ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () {
                            // 1. Update Controller
                            controller.setFund(slot, item);
                            // 2. Close Sheet
                            Navigator.maybePop(context);
                          },
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _compareTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Compare Funds",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "Detailed comparison on parameters...",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ================== WIDGETS ==================

class CompareCard extends StatelessWidget {
  final MutualFundListEntity? fund;
  final bool isLoading;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const CompareCard({
    super.key,
    required this.fund,
    required this.isLoading,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Card(
        color: Colors.white,
        child: SizedBox(
          height: 130,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (fund == null) {
      return GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 2,
          color: Colors.white,
          child: SizedBox(
            height: 130,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add_circle_outline, color: Colors.blue, size: 30),
                SizedBox(height: 8),
                Text(
                  "Add a fund",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      color: Colors.white,
      child: SizedBox(
        height: 130,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: CustomCachedImage(
                      imageUrl:
                          '${Appurl.baseUrl}${fund?.amc?.amcLogoUrl}' ?? '',
                    ),
                  ),
                  const Gap(8),
                  Text(
                    fund?.baseSchemeName ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: UTextStyles.medium.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                onPressed: onRemove,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FundDetailsTable extends StatelessWidget {
  final FundDetailEntity? d1;
  final FundDetailEntity? d2;

  const FundDetailsTable({super.key, this.d1, this.d2});

  @override
  Widget build(BuildContext context) {
    // Helper to create row data
    Map<String, String> row(String title, String Function(FundDetailEntity) f) {
      return {
        "title": title,
        "left": d1 != null ? f(d1!) : "-",
        "right": d2 != null ? f(d2!) : "-",
      };
    }

    final rows = [
      row("Risk", (e) => e.riskometerValue),
      // row("Rating", (e) => "${e.ratingValue} ★"),
      row(
        "NAV",
        (e) => "₹${e.nav} (${DateFormat('d MMM yyyy').format(DateTime.now())})",
      ),
      row("Min SIP", (e) => "₹${e.sipMinimumAmount}"),
      row("Min Inv", (e) => "₹${e.minimumInvestment}"),
      row("Min Topup", (e) => "₹${e.minimumTopup}"),
      row("Exp Ratio", (e) => "${e.expenseRatioPercentage}%"),
      row("Nav", (e) => "₹${e.nav}"),
      row("AUM", (e) => "₹${e.schemeAssets} Cr."),
      row("Launch", (e) => e.schemeInceptionDate),
      row("Status", (e) => e.schemeStatus),
      row("Exit load", (e) => e.exitLoad),
    ];

    return Column(children: rows.map((r) => _buildRow(r)).toList());
  }

  Widget _buildRow(Map<String, String> row) {
    return Column(
      children: [
        Container(
          color: Colors.grey.shade100,
          padding: const EdgeInsets.symmetric(vertical: 8),
          width: double.infinity,
          child: Center(
            child: Text(
              row["title"]!,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Row(children: [_cell(row["left"]!), _cell(row["right"]!)]),
      ],
    );
  }

  Widget _cell(String txt) => Expanded(
    child: Container(
      // height: 45,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          // bottom: BorderSide(color: Colors.grey.shade300),
          right: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Text(
        txt,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12),
      ),
    ),
  );
}

// Simple Table for Returns/Managers
class CompareTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  const CompareTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: data.map((row) {
        final List<String> values = List<String>.from(row["values"]);
        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: Colors.grey.shade100,
              child: Center(
                child: Text(
                  row["title"],
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Row(
              children: values
                  .map(
                    (val) => Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        // height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.grey.shade300),
                            // bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Text(val, style: const TextStyle(fontSize: 13)),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class HoldingsCompareTable extends StatelessWidget {
  final SchemeDetailsEntity? p1;
  final SchemeDetailsEntity? p2;

  const HoldingsCompareTable({super.key, this.p1, this.p2});

  @override
  Widget build(BuildContext context) {
    // 1. Get Top 5 Cleaned Names for Scheme 1
    final list1 = getCleanedTopHoldings(
      names: p1?.schemePortfolioHoldingsNamesString,
      values: p1?.schemePortfolioHoldingsValuesString,
      limit: 5,
    );

    // 2. Get Top 5 Cleaned Names for Scheme 2
    final list2 = getCleanedTopHoldings(
      names: p2?.schemePortfolioHoldingsNamesString,
      values: p2?.schemePortfolioHoldingsValuesString,
      limit: 5,
    );

    return Column(
      // Ensure we always render 5 rows, even if data is missing
      children: List.generate(5, (index) {
        // Safe access: if index exceeds list length, show "-"
        final name1 = index < list1.length ? list1[index] : "-";
        final name2 = index < list2.length ? list2[index] : "-";

        return Row(
          children: [
            // --- Column 1 (Scheme 1) ---
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 5,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.grey.shade300),
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Text(
                  name1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            ),

            // --- Column 2 (Scheme 2) ---
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 5,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Text(
                  name2,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

// Standard Widgets
class DashedLine2 extends StatelessWidget {
  final double height;
  final double dashWidth;
  final Color color;
  const DashedLine2({
    super.key,
    this.height = 1,
    this.dashWidth = 5,
    // this.dashSpace = 3,
    this.color = Colors.black,
    required int dashSpace,
  });
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashCount = (constraints.constrainWidth() / (2 * dashWidth))
            .floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(
            dashCount,
            (_) => SizedBox(
              width: dashWidth,
              height: height,
              child: DecoratedBox(decoration: BoxDecoration(color: color)),
            ),
          ),
        );
      },
    );
  }
}

class CompareExpansion extends StatelessWidget {
  final String title;
  final Widget child;
  const CompareExpansion({super.key, required this.title, required this.child});
  @override
  Widget build(BuildContext context) => ExpansionTile(
    dense: true,
    initiallyExpanded: true, // Keep open by default
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    children: [child],
  );
}

class CompareCardOption extends StatelessWidget {
  final MutualFundListEntity? fund;
  final bool isLoading;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final VoidCallback? onAddToCart; // 👈 NEW
  final VoidCallback? onAddToWishlist; // 👈 NEW

  const CompareCardOption({
    super.key,
    required this.fund,
    required this.isLoading,
    required this.onTap,
    required this.onRemove,
    this.onAddToCart,
    this.onAddToWishlist,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Card(
        color: Colors.white,
        child: SizedBox(
          height: 130,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (fund == null) {
      return GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Colors.grey.shade200,
              style: BorderStyle.solid,
            ), // Modern dashed/dotted look alternative
          ),
          child: SizedBox(
            height: 130,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: Ucolors.primary,
                  size: 30,
                ),
                const SizedBox(height: 8),
                Text(
                  "Add a fund",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 130,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Container(
                      height: 40,
                      width: 40,
                      color: Colors.grey.shade50,
                      child: CustomCachedImage(
                        imageUrl: '${Appurl.baseUrl}${fund?.amc?.amcLogoUrl}',
                      ),
                    ),
                  ),
                  const Gap(8),
                  Text(
                    fund?.baseSchemeName ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: UTextStyles.medium.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            // --- THE NEW 3-DOT MENU ---
            Positioned(
              top: 0,
              right: 0,
              child: PopupMenuButton<int>(
                icon: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                elevation: 4,
                onSelected: (value) {
                  if (value == 0 && onAddToCart != null) onAddToCart!();
                  if (value == 1 && onAddToWishlist != null) onAddToWishlist!();
                  if (value == 2) onRemove();
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 0,
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.shopping_cart,
                          size: 18,
                          color: Ucolors.primary,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Add to Cart',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.archive_add,
                          size: 18,
                          color: Ucolors.primary,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Watchlist',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: [
                        const Icon(Icons.close, size: 18, color: Colors.red),
                        const SizedBox(width: 10),
                        const Text(
                          'Remove',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
