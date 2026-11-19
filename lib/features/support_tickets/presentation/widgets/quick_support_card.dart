import 'package:flutter/material.dart';
import '../../../../core/utils/helper/support_contact_helper.dart';

/// Reusable card displaying instant contact options: Call, WhatsApp, and Email.
class QuickSupportCard extends StatelessWidget {
  final bool compact;
  final String? title;
  final String? subtitle;

  const QuickSupportCard({
    super.key,
    this.compact = false,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (compact) {
      return _buildCompact(context, isDark);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2230) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.headset_mic_rounded,
                  size: 16,
                  color: Color(0xFF2563EB),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title ?? 'Need Immediate Help?',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
              Text(
                'Mon - Sat, 9am - 7pm',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white54 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white60 : Colors.grey.shade600,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SupportChannelButton(
                  icon: Icons.phone_in_talk_rounded,
                  label: 'Call',
                  sublabel: 'Instant dial',
                  color: const Color(0xFF2563EB),
                  isDark: isDark,
                  onTap: () => SupportContactHelper.callSupport(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SupportChannelButton(
                  icon: Icons.chat_rounded,
                  label: 'WhatsApp',
                  sublabel: 'Quick chat',
                  color: const Color(0xFF25D366),
                  isDark: isDark,
                  onTap: () => SupportContactHelper.openWhatsApp(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SupportChannelButton(
                  icon: Icons.mail_outline_rounded,
                  label: 'Email',
                  sublabel: 'Send query',
                  color: const Color(0xFFEA4335),
                  isDark: isDark,
                  onTap: () => SupportContactHelper.sendEmail(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompact(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2230) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title ?? 'Need instant help? Connect directly:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : const Color(0xFF334155),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _CompactActionIcon(
            icon: Icons.phone_rounded,
            color: const Color(0xFF2563EB),
            tooltip: 'Call Support',
            onTap: () => SupportContactHelper.callSupport(),
          ),
          const SizedBox(width: 8),
          _CompactActionIcon(
            icon: Icons.chat_rounded,
            color: const Color(0xFF25D366),
            tooltip: 'WhatsApp Support',
            onTap: () => SupportContactHelper.openWhatsApp(),
          ),
          const SizedBox(width: 8),
          _CompactActionIcon(
            icon: Icons.mail_outline_rounded,
            color: const Color(0xFFEA4335),
            tooltip: 'Email Support',
            onTap: () => SupportContactHelper.sendEmail(),
          ),
        ],
      ),
    );
  }
}

class _SupportChannelButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _SupportChannelButton({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.15 : 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: color.withValues(alpha: isDark ? 0.3 : 0.2),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sublabel,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white54 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompactActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  const _CompactActionIcon({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: color.withValues(alpha: 0.12),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Icon(icon, size: 16, color: color),
          ),
        ),
      ),
    );
  }
}
