import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/services.dart';

class InviteService {
  Future<String> createInviteLink(String userId) async {
    try {
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://trackbud.page.link', // Prüfe deine URI-Präfix
        link: Uri.parse('https://trackbud.com/friend_invite?userId=$userId'),
        androidParameters: AndroidParameters(
          packageName: 'com.example.track_bud',
        ),
        iosParameters: IOSParameters(
          bundleId: 'com.example.trackBud',
        ),
      );

      final ShortDynamicLink dynamicLink =
          await FirebaseDynamicLinks.instance.buildShortLink(parameters);

      return dynamicLink.shortUrl.toString();
    } catch (e) {
      print("Fehler beim Erstellen des Links: $e");
      throw e;
    }
  }
}
