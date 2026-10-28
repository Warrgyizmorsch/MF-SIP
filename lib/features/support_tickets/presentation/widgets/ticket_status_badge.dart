import 'package:flutter/material.dart';

class TicketStatusBadge extends StatelessWidget {
  final String status;
  final bool isCompact;

  const TicketStatusBadge({
    super.key,
    required this.status,
    this.isCompact = false,
  });

  static Color getStatusColor(String rawStatus) {
    switch (rawStatus.toUpperCase()) {
      case 'OPEN':
        return const Color(0xFF2563EB); // Blue
      case 'IN_PROGRESS':
        return const Color(0xFFD97706); // Amber
      case 'WAITING_FOR_USER':
        return const Color(0xFF7C3AED); // Purple
      case 'RESOLVED':
        return const Color(0xFF059669); // Green
      case 'CLOSED':
        return const Color(0xFF64748B); // Slate / Gray
      default:
        return const Color(0xFF2563EB);
    }
  }

  static String getStatusLabel(String rawStatus) {
    switch (rawStatus.toUpperCase()) {
      case 'OPEN':
        return 'Open';
      case 'IN_PROGRESS':
        return 'In Progress';
      case 'WAITING_FOR_USER':
        return 'Action Required';
      case 'RESOLVED':
        return 'Resolved';
      case 'CLOSED':
        return 'Closed';
      default:
        return rawStatus.replaceAll('_', ' ');
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getStatusColor(status);
    final label = getStatusLabel(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 10,
        vertical: isCompact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
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
