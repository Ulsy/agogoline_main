import '../global_url.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class MessageService {
  static Future<int> sendMessage(recipientNumber) async {
    TwilioFlutter twilioInfo = TwilioFlutter(
      accountSid: (Uri.parse(GlobalUrl.accountSid)).toString(),
      authToken: (Uri.parse(GlobalUrl.authToken)).toString(),
      twilioNumber: (Uri.parse(GlobalUrl.twilioNumber)).toString(),
    );
    try {
      final response = await twilioInfo.sendSMS(
        toNumber: '+261' + recipientNumber,
        messageBody:
            "Bonjour, vous venez d'utiliser votre numéro pour un compte agogoline",
      );
      return 1;
    } catch (e) {
      return 0;
    }
  }
}
