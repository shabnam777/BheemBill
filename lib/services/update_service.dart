import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

/// Checks GitHub Releases for a newer app version than the one installed,
/// and can download + trigger install of the new APK directly.
class UpdateInfo {
  final String latestVersion;
  final String downloadUrl;
  final String releaseNotes;

  UpdateInfo({
    required this.latestVersion,
    required this.downloadUrl,
    required this.releaseNotes,
  });
}

class UpdateService {
  static const String owner = 'shabnam777';
  static const String repo = 'BheemBill';

  static Uri get _latestReleaseUrl => Uri.parse('https://api.github.com/repos/$owner/$repo/releases/latest');

  /// Returns UpdateInfo if a newer version is available on GitHub, else null.
  static Future<UpdateInfo?> checkForUpdate() async {
    try {
      final response = await http.get(_latestReleaseUrl, headers: {
        'Accept': 'application/vnd.github+json',
      });

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final tagName = (data['tag_name'] as String?) ?? '';
      final latestVersion = tagName.replaceFirst('v', '').split('-').first;

      final assets = (data['assets'] as List?) ?? [];
      String? apkUrl;
      for (final asset in assets) {
        final name = asset['name'] as String? ?? '';
        if (name.endsWith('.apk')) {
          apkUrl = asset['browser_download_url'] as String?;
          break;
        }
      }
      if (apkUrl == null) return null;

      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      if (_isNewer(latestVersion, currentVersion)) {
        return UpdateInfo(
          latestVersion: latestVersion,
          downloadUrl: apkUrl,
          releaseNotes: (data['body'] as String?) ?? '',
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static bool _isNewer(String latest, String current) {
    List<int> parse(String v) => v.split('.').map((p) => int.tryParse(p) ?? 0).toList();

    final l = parse(latest);
    final c = parse(current);
    final len = l.length > c.length ? l.length : c.length;

    for (var i = 0; i < len; i++) {
      final lv = i < l.length ? l[i] : 0;
      final cv = i < c.length ? c[i] : 0;
      if (lv != cv) return lv > cv;
    }
    return false;
  }

  /// Downloads the APK to app-specific storage and opens the
  /// Android install prompt directly — no browser involved.
  /// [onProgress] gives a value between 0.0 and 1.0.
  static Future<void> downloadAndInstall(
    String url, {
    void Function(double progress)? onProgress,
  }) async {
    final dir = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/app-update.apk';

    // Remove old file if it exists, to avoid conflicts.
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }

    final dio = Dio();
    await dio.download(
      url,
      filePath,
      onReceiveProgress: (received, total) {
        if (total > 0 && onProgress != null) {
          onProgress(received / total);
        }
      },
    );

    // Opens Android's package installer with the downloaded APK.
    await OpenFile.open(filePath);
  }
}
