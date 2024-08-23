import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/services.dart';

class InviteService {
  Future<String> createInviteLink(String userId) async {
    try {
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://yourapp.page.link', // Prüfe deine URI-Präfix
        link: Uri.parse('https://yourapp.com/friend_invite?userId=$userId'),
        androidParameters: AndroidParameters(
          packageName: 'com.example.track_bud', // Deine Android-Paketname
        ),
        iosParameters: IOSParameters(
          bundleId: 'com.example.trackBud', // Deine iOS-Bundle-ID
        ),
      );

      final ShortDynamicLink dynamicLink =
          await FirebaseDynamicLinks.instance.buildShortLink(parameters);

      return dynamicLink.shortUrl.toString();
    } catch (e) {
      print("Fehler beim Erstellen des Links: $e");
      throw e; // Fehler weitergeben, um den Fehler zu sehen
    }
  }
}
