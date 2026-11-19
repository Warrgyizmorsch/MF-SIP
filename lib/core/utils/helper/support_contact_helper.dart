import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common/widget/animated/custom_toast.dart';

/// Helper utility to launch direct support channels: Phone, WhatsApp, and Email.
class SupportContactHelper {
  SupportContactHelper._();

  static const String supportPhone = '+917850888522';
  static const String supportPhoneDisplay = '+91 78508 88522';
  static const String whatsappNumber = '917850888522';
  static const String supportEmail = 'support@mfsip.com';

  /// Initiates a phone call to support team.
  static Future<void> callSupport() async {
    try {
      final Uri uri = Uri(scheme: 'tel', path: supportPhone);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        CustomSnackbar.warning(
          title: 'Call Support',
          message:
              'Unable to open phone dialer. Please dial $supportPhoneDisplay directly.',
        );
      }
    } catch (e) {
      debugPrint('[SupportContactHelper] call error: $e');
      CustomSnackbar.error(
        title: 'Error',
        message: 'Could not initiate call. Please dial $supportPhoneDisplay.',
      );
    }
  }

  /// Opens WhatsApp chat with prefilled support query.
  static Future<void> openWhatsApp({String? message}) async {
    final String queryText = message?.trim().isNotEmpty == true
        ? message!.trim()
        : 'Hello Support, I need assistance with my MF-SIP account.';

    // Try web/app universal link first
    final Uri waUri = Uri.parse(
      'https://wa.me/$whatsappNumber?text=${Uri.encodeComponent(queryText)}',
    );

    try {
      if (await canLaunchUrl(waUri)) {
        await launchUrl(waUri, mode: LaunchMode.externalApplication);
        return;
      }

      // Fallback custom scheme
      final Uri fallbackScheme = Uri.parse(
        'whatsapp://send?phone=$whatsappNumber&text=${Uri.encodeComponent(queryText)}',
      );
      if (await canLaunchUrl(fallbackScheme)) {
        await launchUrl(fallbackScheme, mode: LaunchMode.externalApplication);
        return;
      }

      CustomSnackbar.warning(
        title: 'WhatsApp Support',
        message:
            'Could not open WhatsApp. Please ensure WhatsApp is installed or message $supportPhoneDisplay.',
      );
    } catch (e) {
      debugPrint('[SupportContactHelper] whatsapp error: $e');
      CustomSnackbar.error(
        title: 'WhatsApp Error',
        message:
            'Could not launch WhatsApp. Please contact $supportPhoneDisplay.',
      );
    }
  }

  static String _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  /// Opens default email composer addressed to support.
  static Future<void> sendEmail({String? subject, String? body}) async {
    final String emailSubject = subject?.trim().isNotEmpty == true
        ? subject!.trim()
        : 'Support Request - MF-SIP';
    final String emailBody = body?.trim().isNotEmpty == true
        ? body!.trim()
        : 'Hi Support Team,\n\nI need help with:\n\nAccount / CAN: \nDetails: \n';

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      query: _encodeQueryParameters({
        'subject': emailSubject,
        'body': emailBody,
      }),
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri, mode: LaunchMode.externalApplication);
        return;
      }

      // Try launching directly without canLaunchUrl gate (some Android OEM intent resolvers return false for canLaunchUrl)
      final bool launched = await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication,
      );
      if (launched) return;

      // Fallback: copy email to clipboard if no mail app exists on device
      await Clipboard.setData(const ClipboardData(text: supportEmail));
      CustomSnackbar.info(
        title: 'Email Copied',
        message:
            'No active email app found. Support email ($supportEmail) has been copied to your clipboard.',
      );
    } catch (e) {
      debugPrint('[SupportContactHelper] email error: $e');
      await Clipboard.setData(const ClipboardData(text: supportEmail));
      CustomSnackbar.info(
        title: 'Email Copied',
        message:
            'Support email ($supportEmail) copied to clipboard. You can paste it into your preferred mail app.',
      );
    }
  }
}
