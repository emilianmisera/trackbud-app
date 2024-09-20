import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';

class InviteService {
  Future<String> createInviteLink(String userId) async {
    try {
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://trackbud2.page.link', // Prüfe deine URI-Präfix
        link: Uri.parse('https://trackbud2.com/friend_invite?userId=$userId'),
        androidParameters: const AndroidParameters(
          packageName: 'com.example.track_bud',
        ),
        iosParameters: const IOSParameters(
          bundleId: 'com.example.trackBud',
        ),
      );

      // ignore: deprecated_member_use
      final ShortDynamicLink dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);

      return dynamicLink.shortUrl.toString();
    } catch (e) {
      debugPrint("Fehler beim Erstellen des Links: $e");
      rethrow;
    }
  }
}
