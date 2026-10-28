import 'package:flutter/material.dart';

class TicketPriorityBadge extends StatelessWidget {
  final String priority;
  final bool isCompact;

  const TicketPriorityBadge({
    super.key,
    required this.priority,
    this.isCompact = false,
  });

  static Color getPriorityColor(String rawPriority) {
    switch (rawPriority.toUpperCase()) {
      case 'URGENT':
        return const Color(0xFFDC2626);
      case 'HIGH':
        return const Color(0xFFEA580C);
      case 'MEDIUM':
        return const Color(0xFF0284C7);
      case 'LOW':
        return const Color(0xFF64748B);
      default:
        return const Color(0xFF0284C7);
    }
  }

  static IconData getPriorityIcon(String rawPriority) {
    switch (rawPriority.toUpperCase()) {
      case 'URGENT':
        return Icons.keyboard_double_arrow_up_rounded;
      case 'HIGH':
        return Icons.keyboard_arrow_up_rounded;
      case 'MEDIUM':
        return Icons.drag_handle_rounded;
      case 'LOW':
        return Icons.keyboard_arrow_down_rounded;
      default:
        return Icons.drag_handle_rounded;
    }
  }

  static String getPriorityLabel(String rawPriority) {
    switch (rawPriority.toUpperCase()) {
      case 'URGENT':
        return 'Urgent';
      case 'HIGH':
        return 'High';
      case 'MEDIUM':
        return 'Medium';
      case 'LOW':
        return 'Low';
      default:
        return rawPriority;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getPriorityColor(priority);
    final icon = getPriorityIcon(priority);
    final label = getPriorityLabel(priority);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 6 : 8,
        vertical: isCompact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: isCompact ? 13 : 15,
            color: color,
          ),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: isCompact ? 11 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
