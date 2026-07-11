import 'package:flutter/material.dart';

import '../services/update_service.dart';

/// Shows a dialog prompting the user to update, with a button that
/// downloads the APK and directly opens Android's install prompt —
/// no browser or manual download step needed.
Future<void> showUpdateDialog(BuildContext context, UpdateInfo info) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _UpdateDialogContent(info: info),
  );
}

class _UpdateDialogContent extends StatefulWidget {
  final UpdateInfo info;
  const _UpdateDialogContent({required this.info});

  @override
  State<_UpdateDialogContent> createState() => _UpdateDialogContentState();
}

class _UpdateDialogContentState extends State<_UpdateDialogContent> {
  bool _downloading = false;
  double _progress = 0;
  String? _error;

  Future<void> _startUpdate() async {
    setState(() {
      _downloading = true;
      _error = null;
    });

    try {
      await UpdateService.downloadAndInstall(
        widget.info.downloadUrl,
        onProgress: (p) {
          if (mounted) setState(() => _progress = p);
        },
      );
      // Android install screen takes over here — safe to close dialog.
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() {
          _downloading = false;
          _error = 'Download failed. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Available'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'A new version (${widget.info.latestVersion}) is available.\n\n'
            '${widget.info.releaseNotes.isNotEmpty ? widget.info.releaseNotes : 'Please update to the latest version.'}',
          ),
          if (_downloading) ...[
            const SizedBox(height: 16),
            LinearProgressIndicator(value: _progress > 0 ? _progress : null),
            const SizedBox(height: 8),
            Text('${(_progress * 100).toStringAsFixed(0)}%'),
          ],
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
        ],
      ),
      actions: _downloading
          ? []
          : [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Later'),
              ),
              ElevatedButton(
                onPressed: _startUpdate,
                child: const Text('Update Now'),
              ),
            ],
    );
  }
}
