import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import '../../domain/entities/ticket_entity.dart';
import '../controllers/tickets_controller.dart';
import '../widgets/ticket_card.dart';
import 'create_ticket_page.dart';
import 'ticket_detail_page.dart';

class TicketsListPage extends StatelessWidget {
  const TicketsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TicketsController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF11141C) : const Color(0xFFF8FAFC),
      appBar: CustomAppBarNormal(
        title: 'Support Tickets',
        action: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => controller.fetchTickets(isRefresh: true),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF0280C0),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Raise Ticket',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () => Get.to(() => const CreateTicketPage()),
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: controller.onRefresh,
          child: Column(
            children: [
              // Summary cards
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    _buildSummaryCard(
                      label: 'Open',
                      count: controller.openCount.value,
                      color: const Color(0xFF2563EB),
                      icon: Icons.hourglass_top_rounded,
                      isSelected: controller.selectedTab.value == 'OPEN_ONLY',
                      onTap: () => controller.changeTab('OPEN_ONLY'),
                    ),
                    const SizedBox(width: 10),
                    _buildSummaryCard(
                      label: 'Resolved',
                      count: controller.resolvedCount.value,
                      color: const Color(0xFF059669),
                      icon: Icons.check_circle_outline_rounded,
                      isSelected: controller.selectedTab.value == 'RESOLVED_ONLY',
                      onTap: () => controller.changeTab('RESOLVED_ONLY'),
                    ),
                    const SizedBox(width: 10),
                    _buildSummaryCard(
                      label: 'All Tickets',
                      count: controller.totalCount.value,
                      color: const Color(0xFF64748B),
                      icon: Icons.all_inbox_rounded,
                      isSelected: controller.selectedTab.value == 'ALL',
                      onTap: () => controller.changeTab('ALL'),
                    ),
                  ],
                ),
              ),

              // Filter Tabs Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  children: [
                    _buildFilterChip(
                      label: 'Open',
                      selected: controller.selectedTab.value == 'OPEN_ONLY',
                      onSelected: () => controller.changeTab('OPEN_ONLY'),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      label: 'Resolved / Closed',
                      selected: controller.selectedTab.value == 'RESOLVED_ONLY',
                      onSelected: () => controller.changeTab('RESOLVED_ONLY'),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      label: 'All',
                      selected: controller.selectedTab.value == 'ALL',
                      onSelected: () => controller.changeTab('ALL'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              // Tickets List / States
              Expanded(
                child: _buildTicketsList(context, controller),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCard({
    required String label,
    required int count,
    required Color color,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.12) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : Colors.grey.shade200,
              width: isSelected ? 1.6 : 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  Icon(icon, size: 18, color: color),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required VoidCallback onSelected,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        color: selected ? Colors.white : Colors.grey.shade700,
      ),
      selectedColor: const Color(0xFF0280C0),
      backgroundColor: Colors.white,
      side: BorderSide(
        color: selected ? const Color(0xFF0280C0) : Colors.grey.shade300,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildTicketsList(BuildContext context, TicketsController controller) {
    if (controller.isLoading.value) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (controller.errorMessage.value.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, size: 48, color: Colors.red.shade400),
              const SizedBox(height: 12),
              Text(
                controller.errorMessage.value,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.fetchTickets(isRefresh: true),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (controller.tickets.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFF0280C0).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.support_agent_rounded,
                  size: 38,
                  color: Color(0xFF0280C0),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'No Tickets Found',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Have a question or facing an issue? Raise a ticket and our support team will help you promptly.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0280C0),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Raise New Ticket',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                onPressed: () => Get.to(() => const CreateTicketPage()),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      controller: controller.scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: controller.tickets.length + (controller.isLoadingMore.value ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= controller.tickets.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        final TicketEntity ticket = controller.tickets[index];
        return TicketCard(
          ticket: ticket,
          onTap: () {
            Get.to(() => TicketDetailPage(ticketId: ticket.id));
          },
        );
      },
    );
  }
}
