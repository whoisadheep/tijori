import 'package:flutter_test/flutter_test.dart';
import 'package:tijori/core/updater/update_models.dart';

void main() {
  group('SemanticVersion parsing & comparison', () {
    test('parses standard semantic version strings', () {
      final v1 = SemanticVersion.parse('1.2.3');
      expect(v1.major, equals(1));
      expect(v1.minor, equals(2));
      expect(v1.patch, equals(3));
      expect(v1.build, equals(0));

      final v2 = SemanticVersion.parse('v2.0.1+15');
      expect(v2.major, equals(2));
      expect(v2.minor, equals(0));
      expect(v2.patch, equals(1));
      expect(v2.build, equals(15));
    });

    test('compares semantic versions correctly', () {
      final v100 = SemanticVersion.parse('1.0.0');
      final v101 = SemanticVersion.parse('1.0.1');
      final v110 = SemanticVersion.parse('1.1.0');
      final v200 = SemanticVersion.parse('2.0.0');
      final v100Build1 = SemanticVersion.parse('1.0.0+1');
      final v100Build2 = SemanticVersion.parse('1.0.0+2');

      expect(v101 > v100, isTrue);
      expect(v110 > v101, isTrue);
      expect(v200 > v110, isTrue);
      expect(v100Build2 > v100Build1, isTrue);
      expect(v100Build1 >= v100, isTrue);
      expect(v100 <= v101, isTrue);
      expect(v100 == SemanticVersion.parse('v1.0.0'), isTrue);
    });

    test('ReleaseInfo extracts download assets accurately', () {
      final releaseJson = {
        'tag_name': 'v2.1.0',
        'body': 'Initial production release with offline SQLite support.',
        'published_at': '2025-05-01T12:00:00Z',
        'assets': [
          {
            'name': 'tijori-v2.1.0-android.apk',
            'browser_download_url':
                'https://github.com/tijori-app/tijori-releases/releases/download/v2.1.0/tijori.apk',
          },
          {
            'name': 'tijori-setup.exe',
            'browser_download_url':
                'https://github.com/tijori-app/tijori-releases/releases/download/v2.1.0/tijori-setup.exe',
          },
          {
            'name': 'tijori-linux.AppImage',
            'browser_download_url':
                'https://github.com/tijori-app/tijori-releases/releases/download/v2.1.0/tijori.AppImage',
          },
        ],
      };

      final info = ReleaseInfo.fromGitHubRelease(releaseJson);
      expect(info.latestVersion, equals('v2.1.0'));
      expect(info.androidApkUrl, contains('.apk'));
      expect(info.windowsUrl, contains('.exe'));
      expect(info.linuxUrl, contains('.AppImage'));
      expect(info.changelog, contains('offline SQLite support'));
    });
  });
}
