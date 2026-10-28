import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/ticket_detail_entity.dart';

class TicketChatBubble extends StatelessWidget {
  final TicketMessageEntity message;

  const TicketChatBubble({
    super.key,
    required this.message,
  });

  bool get isUser => message.senderType.toLowerCase() == 'user';
  bool get isSystem => message.senderType.toLowerCase() == 'system';

  String _formatTime(String rawTime) {
    if (rawTime.isEmpty) return '';
    try {
      final dt = DateTime.parse(rawTime).toLocal();
      final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      final minute = dt.minute.toString().padLeft(2, '0');
      return '$hour:$minute $ampm';
    } catch (_) {
      return rawTime;
    }
  }

  void _openAttachment(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('[TicketChatBubble] could not launch attachment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isSystem) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 0.8),
        ),
        child: Text(
          message.message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Sender Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isUser) ...[
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0280C0).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.support_agent_rounded,
                      size: 13,
                      color: Color(0xFF0280C0),
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  isUser ? 'You' : (message.senderName.isNotEmpty ? message.senderName : 'Support Agent'),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isUser
                        ? Colors.grey.shade600
                        : const Color(0xFF0280C0),
                  ),
                ),
              ],
            ),
          ),

          // Message Bubble
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.78,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser
                    ? const Color(0xFF0280C0)
                    : (isDark ? const Color(0xFF232733) : const Color(0xFFF1F5F9)),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Message Text
                  if (message.message.isNotEmpty)
                    Text(
                      message.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: isUser
                            ? Colors.white
                            : (isDark ? Colors.white : const Color(0xFF1E293B)),
                        height: 1.35,
                      ),
                    ),

                  // Attachments
                  if (message.attachments.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: message.attachments.map((att) {
                        final isImg = att.isImage;
                        return InkWell(
                          onTap: () => _openAttachment(att.url),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : (isDark ? Colors.white12 : Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isUser
                                    ? Colors.white30
                                    : Colors.grey.shade300,
                                width: 0.8,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isImg
                                      ? Icons.image_rounded
                                      : Icons.attach_file_rounded,
                                  size: 16,
                                  color: isUser ? Colors.white : Colors.black87,
                                ),
                                const SizedBox(width: 4),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 130),
                                  child: Text(
                                    att.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isUser
                                          ? Colors.white
                                          : Colors.black87,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  const SizedBox(height: 4),

                  // Timestamp
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      _formatTime(message.createdAt),
                      style: TextStyle(
                        fontSize: 10,
                        color: isUser ? Colors.white70 : Colors.grey.shade500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
