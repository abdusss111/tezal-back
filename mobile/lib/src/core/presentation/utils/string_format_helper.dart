import 'package:url_launcher/url_launcher.dart';

class StringFormatHelper {
  static String _formatWhatsAppNumber(String phoneNumber, {String? infoText}) {
    String cleanedNumber = _getNumber(phoneNumber);
    if (infoText == null) {
      return 'https://wa.me/$cleanedNumber';
    } else {
      return 'https://wa.me/$cleanedNumber?text=$infoText';
    }
  }

  static Future<void> tryOpenWhatsAppWithNumber(String phoneNumber,
      {String? infoText}) async {
    String cleanedNumber = _getNumber(phoneNumber);
    Uri? whatsappUrl;
    if (infoText == null) {
      whatsappUrl = Uri.parse("whatsapp://send?phone=$cleanedNumber");
    } else {
      whatsappUrl =
          Uri.parse("whatsapp://send?phone=$cleanedNumber?text=$infoText");
    }

    await canLaunchUrl(whatsappUrl)
        ? launchUrl(whatsappUrl)
        : launchUrl(
            Uri.parse(_formatWhatsAppNumber(phoneNumber, infoText: infoText)));
  }

  static String _getNumber(String phoneNumber) {
    String cleanedNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');
    if (cleanedNumber.startsWith('7')) {
      return cleanedNumber;
    } else if (cleanedNumber.startsWith('8')) {
      return cleanedNumber.substring(1);
    } else {
      return '';
    }
  }

  static String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length != 11) {
      throw ArgumentError('Неверная длина номера телефона');
    }
    String firstSegment = phoneNumber.substring(1, 4);
    String secondSegment = phoneNumber.substring(4, 7);
    String thirdSegment = phoneNumber.substring(7, 9);
    String fourthSegment = phoneNumber.substring(9);
    return '$firstSegment)$secondSegment-$thirdSegment-$fourthSegment';
  }
}
