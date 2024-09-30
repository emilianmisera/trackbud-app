import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/services/connectivity_service.dart';
import 'package:track_bud/utils/strings.dart';

/// Widget that listens for offline status and shows a snackbar
class OfflineNotificationWrapper extends StatelessWidget {
  final Widget child;

  const OfflineNotificationWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityService>(
      builder: (context, connectivityService, childWidget) {
        if (!connectivityService.isOnline) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppTexts.offlineNotification),
                duration: Duration(seconds: 10),
                backgroundColor: Colors.red,
              ),
            );
          });
        }
        return childWidget!;
      },
      child: child,
    );
  }
}
