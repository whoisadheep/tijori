/// Semantic version representation and comparison for OTA updates.
class SemanticVersion implements Comparable<SemanticVersion> {
  final int major;
  final int minor;
  final int patch;
  final int build;
  final String? preRelease;

  const SemanticVersion({
    required this.major,
    required this.minor,
    required this.patch,
    this.build = 0,
    this.preRelease,
  });

  /// Parses strings like "1.2.3", "v1.2.3", "1.2.3+4", "1.2.3-beta.1+4".
  factory SemanticVersion.parse(String raw) {
    String clean = raw.trim();
    if (clean.startsWith('v') || clean.startsWith('V')) {
      clean = clean.substring(1);
    }

    int buildNum = 0;
    if (clean.contains('+')) {
      final parts = clean.split('+');
      clean = parts[0];
      buildNum = int.tryParse(parts[1]) ?? 0;
    }

    String? pre;
    if (clean.contains('-')) {
      final parts = clean.split('-');
      clean = parts[0];
      pre = parts[1];
    }

    final segments = clean.split('.');
    final major = segments.isNotEmpty ? int.tryParse(segments[0]) ?? 0 : 0;
    final minor = segments.length > 1 ? int.tryParse(segments[1]) ?? 0 : 0;
    final patch = segments.length > 2 ? int.tryParse(segments[2]) ?? 0 : 0;

    return SemanticVersion(
      major: major,
      minor: minor,
      patch: patch,
      build: buildNum,
      preRelease: pre,
    );
  }

  @override
  int compareTo(SemanticVersion other) {
    if (major != other.major) return major.compareTo(other.major);
    if (minor != other.minor) return minor.compareTo(other.minor);
    if (patch != other.patch) return patch.compareTo(other.patch);
    if (build != other.build) return build.compareTo(other.build);
    return 0;
  }

  bool operator >(SemanticVersion other) => compareTo(other) > 0;
  bool operator <(SemanticVersion other) => compareTo(other) < 0;
  bool operator >=(SemanticVersion other) => compareTo(other) >= 0;
  bool operator <=(SemanticVersion other) => compareTo(other) <= 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SemanticVersion &&
          major == other.major &&
          minor == other.minor &&
          patch == other.patch &&
          build == other.build;

  @override
  int get hashCode => Object.hash(major, minor, patch, build);

  @override
  String toString() {
    final base = '$major.$minor.$patch';
    return build > 0 ? '$base+$build' : base;
  }
}

/// Metadata describing a release published on GitHub.
class ReleaseInfo {
  final String latestVersion;
  final String minRequiredVersion;
  final String changelog;
  final String? windowsUrl;
  final String? linuxUrl;
  final String? androidApkUrl;
  final DateTime? publishedAt;

  const ReleaseInfo({
    required this.latestVersion,
    required this.minRequiredVersion,
    required this.changelog,
    this.windowsUrl,
    this.linuxUrl,
    this.androidApkUrl,
    this.publishedAt,
  });

  /// Creates a [ReleaseInfo] from GitHub release API json and optionally
  /// an embedded `version.json` payload.
  factory ReleaseInfo.fromGitHubRelease(
    Map<String, dynamic> releaseJson, {
    Map<String, dynamic>? versionConfig,
  }) {
    final tagName = releaseJson['tag_name'] as String? ?? '1.0.0';
    final publishedStr = releaseJson['published_at'] as String?;
    final releaseBody = releaseJson['body'] as String? ?? '';
    final assets = (releaseJson['assets'] as List<dynamic>?) ?? [];

    String? winUrl = versionConfig?['windows_url'] as String?;
    String? linUrl = versionConfig?['linux_url'] as String?;
    String? apkUrl = versionConfig?['android_apk_url'] as String?;

    // Auto-discover URLs from assets if not explicitly defined in versionConfig
    for (final asset in assets) {
      if (asset is Map<String, dynamic>) {
        final downloadUrl = asset['browser_download_url'] as String? ?? '';
        final name = (asset['name'] as String? ?? '').toLowerCase();

        if (name.endsWith('.apk') && apkUrl == null) {
          apkUrl = downloadUrl;
        } else if ((name.endsWith('.exe') || name.endsWith('.msix')) &&
            winUrl == null) {
          winUrl = downloadUrl;
        } else if ((name.endsWith('.appimage') ||
                name.endsWith('.deb') ||
                name.endsWith('.tar.gz')) &&
            linUrl == null) {
          linUrl = downloadUrl;
        }
      }
    }

    return ReleaseInfo(
      latestVersion: (versionConfig?['latest_version'] as String?) ?? tagName,
      minRequiredVersion:
          (versionConfig?['min_required_version'] as String?) ?? '1.0.0',
      changelog: (versionConfig?['changelog'] as String?) ?? releaseBody,
      windowsUrl: winUrl,
      linuxUrl: linUrl,
      androidApkUrl: apkUrl,
      publishedAt:
          publishedStr != null ? DateTime.tryParse(publishedStr) : null,
    );
  }
}

/// Status of the OTA update process.
enum UpdateStatus {
  idle,
  checking,
  updateAvailable,
  mandatoryUpdateRequired,
  downloading,
  readyToInstall,
  upToDate,
  error,
}

/// State maintained by the OTA Update Service.
class UpdateState {
  final UpdateStatus status;
  final ReleaseInfo? releaseInfo;
  final double downloadProgress; // 0.0 to 1.0
  final String? downloadedFilePath;
  final String? errorMessage;
  final SemanticVersion? currentVersion;

  const UpdateState({
    required this.status,
    this.releaseInfo,
    this.downloadProgress = 0.0,
    this.downloadedFilePath,
    this.errorMessage,
    this.currentVersion,
  });

  UpdateState copyWith({
    UpdateStatus? status,
    ReleaseInfo? releaseInfo,
    double? downloadProgress,
    String? downloadedFilePath,
    String? errorMessage,
    SemanticVersion? currentVersion,
  }) {
    return UpdateState(
      status: status ?? this.status,
      releaseInfo: releaseInfo ?? this.releaseInfo,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      downloadedFilePath: downloadedFilePath ?? this.downloadedFilePath,
      errorMessage: errorMessage ?? this.errorMessage,
      currentVersion: currentVersion ?? this.currentVersion,
    );
  }
}
