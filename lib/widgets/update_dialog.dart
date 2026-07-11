import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/update_service.dart';

/// Call this after checking for an update to show a dialog prompting
/// the user to download & install the new APK from GitHub Releases.
Future<void> showUpdateDialog(BuildContext context, UpdateInfo info) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: const Text('Update Available'),
      content: Text(
        'A new version (${info.latestVersion}) is available.\n\n'
        '${info.releaseNotes.isNotEmpty ? info.releaseNotes : 'Please update to the latest version.'}',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Later'),
        ),
        ElevatedButton(
          onPressed: () async {
            final uri = Uri.parse(info.downloadUrl);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
            if (ctx.mounted) Navigator.of(ctx).pop();
          },
          child: const Text('Download & Install'),
        ),
      ],
    ),
  );
}