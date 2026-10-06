import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/explore/domain/entities/fund_house_entity.dart';
import 'package:my_sip/features/explore/presentation/bindings/fundhousebinding.dart';
import 'package:my_sip/features/explore/presentation/controller/fundhouse_controller.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';

class AmcListScreen extends StatefulWidget {
  const AmcListScreen({super.key});

  @override
  State<AmcListScreen> createState() => _AmcListScreenState();
}

class _AmcListScreenState extends State<AmcListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final RxString _searchQuery = ''.obs;

  @override
  void initState() {
    super.initState();
    // Ensure dependencies and controller are registered
    if (!Get.isRegistered<FundhouseController>()) {
      Fundhousebinding().dependencies();
    }
    final controller = Get.find<FundhouseController>();
    if (controller.fundlist.isEmpty && !controller.isLoading.value) {
      controller.fetchFundHouse();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _launchAmcUrl(String? rawUrl) async {
    if (rawUrl == null || rawUrl.trim().isEmpty) {
      Get.snackbar(
        'Notice',
        'Website URL is not available for this AMC.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        backgroundColor: Colors.black87,
        colorText: Colors.white,
      );
      return;
    }

    var formattedUrl = rawUrl.trim();
    if (!formattedUrl.startsWith('http://') &&
        !formattedUrl.startsWith('https://')) {
      formattedUrl = 'https://$formattedUrl';
    }

    final uri = Uri.tryParse(formattedUrl);
    if (uri != null) {
      try {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched) {
          Get.snackbar(
            'Error',
            'Could not launch $formattedUrl',
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to open link: $e',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      }
    } else {
      Get.snackbar(
        'Error',
        'Invalid website URL: $rawUrl',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final FundhouseController controller = Get.find<FundhouseController>();
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : Ucolors.light,
      appBar: CustomAppBarNormal(
        title: 'AMCs, SEBI & AMFI',
        backIcon: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 900 : double.infinity,
            ),
            child: Padding(
              padding: isDesktop
                  ? const EdgeInsets.symmetric(horizontal: 24, vertical: 20)
                  : const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => _searchQuery.value = val.trim(),
                      decoration: InputDecoration(
                        hintText: 'Search AMC by name or code...',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                          fontFamily: FontFamily.medium,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Ucolors.darkgrey,
                          size: 20,
                        ),
                        suffixIcon: Obx(() {
                          if (_searchQuery.value.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.grey,
                              size: 18,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              _searchQuery.value = '';
                            },
                          );
                        }),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),
                  const Gap(16),

                  // Regulatory Authorities (SEBI & AMFI)
                  Obx(() {
                    // Only show regulatory quick links when not filtering by search query
                    if (_searchQuery.value.isNotEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.verified_user_outlined,
                              size: 16,
                              color: Ucolors.primary,
                            ),
                            const Gap(6),
                            Text(
                              'Regulatory & Industry Bodies',
                              style: TextStyle(
                                fontFamily: FontFamily.medium,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                        const Gap(10),
                        Row(
                          children: [
                            // SEBI Card
                            Expanded(
                              child: _buildAuthorityCard(
                                title: 'SEBI',
                                subtitle: 'Regulator',
                                url: 'https://www.sebi.gov.in/',
                                icon: Icons.gavel_rounded,
                              ),
                            ),
                            const Gap(12),
                            // AMFI Card
                            Expanded(
                              child: _buildAuthorityCard(
                                title: 'AMFI',
                                subtitle: 'Industry Body',
                                url: 'https://www.amfiindia.com/',
                                icon: Icons.account_balance_rounded,
                              ),
                            ),
                          ],
                        ),
                        const Gap(16),
                        Row(
                          children: [
                            Text(
                              'Asset Management Companies',
                              style: TextStyle(
                                fontFamily: FontFamily.medium,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                        const Gap(10),
                      ],
                    );
                  }),

                  // AMC List
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value &&
                          controller.fundlist.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final query = _searchQuery.value.toLowerCase();
                      final List<FundHouseItemEntity> amcs =
                          controller.fundlist.where((item) {
                        if (query.isEmpty) return true;
                        final name = item.amcName?.toLowerCase() ?? '';
                        final code = item.amcCode?.toLowerCase() ?? '';
                        return name.contains(query) || code.contains(query);
                      }).toList();

                      if (amcs.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.business_outlined,
                                size: 64,
                                color: Colors.grey.shade300,
                              ),
                              const Gap(12),
                              Text(
                                query.isEmpty
                                    ? 'No Fund Houses found'
                                    : 'No AMC matches "$query"',
                                style: UTextStyles.bodyMedium.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          await controller.fetchFundHouse();
                        },
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: amcs.length,
                          separatorBuilder: (_, __) => const Gap(12),
                          itemBuilder: (context, index) {
                            final item = amcs[index];
                            final hasUrl = item.websiteUrl != null &&
                                item.websiteUrl!.trim().isNotEmpty;

                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Colors.black.withValues(alpha: 0.02),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: hasUrl
                                      ? () => _launchAmcUrl(item.websiteUrl)
                                      : null,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      children: [
                                        // AMC Logo
                                        Container(
                                          width: 46,
                                          height: 46,
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: Colors.grey.shade200,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: CustomCachedImage(
                                              imageUrl: item.amcLogoUrl,
                                            ),
                                          ),
                                        ),
                                        const Gap(14),

                                        // AMC Name & Website
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                item.amcName ?? 'AMC',
                                                style: const TextStyle(
                                                  fontFamily: FontFamily.medium,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Ucolors.dark,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const Gap(4),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.language,
                                                    size: 13,
                                                    color: hasUrl
                                                        ? Ucolors.primary
                                                        : Colors.grey.shade400,
                                                  ),
                                                  const Gap(4),
                                                  Expanded(
                                                    child: Text(
                                                      hasUrl
                                                          ? item.websiteUrl!
                                                          : 'Website not available',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            FontFamily.regular,
                                                        fontSize: 12,
                                                        color: hasUrl
                                                            ? Ucolors.primary
                                                            : Colors
                                                                .grey.shade400,
                                                        decoration: hasUrl
                                                            ? TextDecoration
                                                                .underline
                                                            : TextDecoration
                                                                .none,
                                                        decorationColor:
                                                            Ucolors.primary,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Action icon
                                        if (hasUrl) ...[
                                          const Gap(8),
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Ucolors.primary
                                                  .withValues(alpha: 0.08),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.open_in_new_rounded,
                                              size: 16,
                                              color: Ucolors.primary,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthorityCard({
    required String title,
    required String subtitle,
    required String url,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _launchAmcUrl(url),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: Ucolors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: Ucolors.primary,
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: FontFamily.medium,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Ucolors.dark,
                        ),
                      ),
                      const Gap(2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontFamily: FontFamily.regular,
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.open_in_new_rounded,
                  size: 15,
                  color: Ucolors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
