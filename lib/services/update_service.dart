import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

/// Checks GitHub Releases for a newer app version than the one installed.
///
/// IMPORTANT: set your GitHub repo below (owner/repo).
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
      // tag format from CI is "vX.Y.Z-runN" — extract just X.Y.Z
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
      // Network error / no releases yet — fail silently.
      return null;
    }
  }

  /// Simple semver-ish comparison: returns true if [latest] > [current].
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
}
