import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';

class InviteService {
  // Method to create a dynamic invite link for inviting friends
  Future<String> createInviteLink(String userId) async {
    try {
      // Define parameters for the dynamic link
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://trackbud2.page.link', // The URI prefix for your dynamic links
        link: Uri.parse('https://trackbud2.com/friend_invite?userId=$userId'), // The deep link that contains the userId
        androidParameters: const AndroidParameters(
          packageName: 'com.example.track_bud', // Android package name for your app
        ),
        iosParameters: const IOSParameters(
          bundleId: 'com.example.trackBud', // iOS bundle ID for your app
        ),
      );

      // Create a short version of the dynamic link
      // Note: The deprecated_member_use ignore is used because the method is still valid
      // ignore: deprecated_member_use
      final ShortDynamicLink dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);

      // Return the generated short URL as a string
      return dynamicLink.shortUrl.toString();
    } catch (e) {
      // Print error if the link creation fails
      debugPrint("Fehler beim Erstellen des Links: $e");
      rethrow; // Re-throw the caught exception to handle it elsewhere
    }
  }
}
