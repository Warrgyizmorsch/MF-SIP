import 'package:flutter/material.dart';
import '../../domain/entities/ticket_entity.dart';
import 'ticket_priority_badge.dart';
import 'ticket_status_badge.dart';

class TicketCard extends StatelessWidget {
  final TicketEntity ticket;
  final VoidCallback onTap;

  const TicketCard({
    super.key,
    required this.ticket,
    required this.onTap,
  });

  String _formatTimestamp(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);

      if (diff.inMinutes < 1) {
        return 'Just now';
      } else if (diff.inMinutes < 60) {
        return '${diff.inMinutes}m ago';
      } else if (diff.inHours < 24) {
        return '${diff.inHours}h ago';
      } else if (diff.inDays < 7) {
        return '${diff.inDays}d ago';
      } else {
        return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
      }
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2230) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Ticket ID + Status badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          ticket.ticketNumber,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue.shade700,
                            letterSpacing: 0.3,
                          ),
                        ),
                        if (ticket.category != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              ticket.category!.name,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    TicketStatusBadge(
                      status: ticket.status,
                      isCompact: true,
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Subject
                Text(
                  ticket.subject,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                // Latest message snippet
                if (ticket.latestMessage != null &&
                    ticket.latestMessage!.message.trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    ticket.latestMessage!.message,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                const SizedBox(height: 12),
                const Divider(height: 1, thickness: 0.8),
                const SizedBox(height: 10),

                // Bottom row: Priority, unread badge, and updated time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        TicketPriorityBadge(
                          priority: ticket.priority,
                          isCompact: true,
                        ),
                        if (ticket.unreadMessages > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.shade600,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${ticket.unreadMessages} new',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      _formatTimestamp(ticket.updatedAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
