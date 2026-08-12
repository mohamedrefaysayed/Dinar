import 'package:url_launcher/url_launcher.dart';

/// Support contact number in international format (country code + number),
/// digits only — the same number the SMS support link has always used.
const String kSupportPhone = '9607869636020';

/// Opens a WhatsApp chat with support, falling back to SMS when WhatsApp is
/// not installed or cannot be opened.
///
/// Detecting whether WhatsApp is installed relies on the `whatsapp` url scheme
/// being visible to the app: iOS must list it under LSApplicationQueriesSchemes
/// and Android under <queries> in the manifest. Without those, [canLaunchUrl]
/// always reports false and every user silently falls through to SMS.
Future<void> contactSupport() async {
  final Uri whatsAppUri = Uri.parse('whatsapp://send?phone=$kSupportPhone');
  final Uri smsUri = Uri.parse('sms:+$kSupportPhone');

  try {
    if (await canLaunchUrl(whatsAppUri)) {
      final bool opened = await launchUrl(
        whatsAppUri,
        mode: LaunchMode.externalApplication,
      );
      if (opened) return;
    }
  } catch (_) {
    // any failure probing or opening WhatsApp falls through to SMS below
  }

  try {
    await launchUrl(smsUri, mode: LaunchMode.externalApplication);
  } catch (_) {
    // device has neither WhatsApp nor an SMS app: nothing more we can do
  }
}
