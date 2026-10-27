import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../constants/app_constants.dart';
import 'update_models.dart';

export 'update_models.dart';

/// Riverpod Notifier managing over-the-air GitHub Releases update checking,
/// downloading with progress, and platform-specific installer launching.
class OtaUpdateNotifier extends Notifier<UpdateState> {
  late final Dio _dio;
  CancelToken? _cancelToken;

  @override
  UpdateState build() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          'Accept': 'application/vnd.github.v3+json',
          'User-Agent': 'Tijori-ERP-Updater',
        },
      ),
    );

    ref.onDispose(() {
      _cancelToken?.cancel('Service disposed');
      _dio.close();
    });

    _loadCurrentVersion();

    return const UpdateState(status: UpdateStatus.idle);
  }

  /// Initialises and stores current package semantic version.
  Future<void> _loadCurrentVersion() async {
    try {
      final pkg = await PackageInfo.fromPlatform();
      final current = SemanticVersion.parse('${pkg.version}+${pkg.buildNumber}');
      state = state.copyWith(currentVersion: current);
    } catch (e) {
      debugPrint('[OTA] Unable to retrieve PackageInfo: $e');
      state = state.copyWith(currentVersion: const SemanticVersion(major: 1, minor: 0, patch: 0));
    }
  }

  /// Checks GitHub Releases for a newer version.
  Future<void> checkForUpdates() async {
    state = state.copyWith(
      status: UpdateStatus.checking,
      errorMessage: null,
    );

    try {
      // 1. Resolve current installed version
      final pkg = await PackageInfo.fromPlatform();
      final current = SemanticVersion.parse('${pkg.version}+${pkg.buildNumber}');
      state = state.copyWith(currentVersion: current);

      // 2. Fetch the latest release from GitHub API
      final response = await _dio.get<Map<String, dynamic>>(
        AppConstants.githubReleasesApi,
      );

      final releaseJson = response.data;
      if (releaseJson == null) {
        state = state.copyWith(
          status: UpdateStatus.error,
          errorMessage: 'Empty response received from update server.',
        );
        return;
      }

      // 3. Inspect if a custom `version.json` asset is attached
      Map<String, dynamic>? versionConfig;
      final assets = (releaseJson['assets'] as List<dynamic>?) ?? [];
      for (final asset in assets) {
        if (asset is Map<String, dynamic> &&
            asset['name'] == 'version.json') {
          final rawDownloadUrl = asset['browser_download_url'] as String?;
          if (rawDownloadUrl != null) {
            try {
              final vRes = await _dio.get<Map<String, dynamic>>(
                rawDownloadUrl,
                options: Options(responseType: ResponseType.json),
              );
              versionConfig = vRes.data;
            } catch (e) {
              debugPrint('[OTA] Could not fetch attached version.json: $e');
            }
          }
          break;
        }
      }

      // 4. Parse Release Information
      final releaseInfo = ReleaseInfo.fromGitHubRelease(
        releaseJson,
        versionConfig: versionConfig,
      );

      final latestVer = SemanticVersion.parse(releaseInfo.latestVersion);
      final minRequiredVer =
          SemanticVersion.parse(releaseInfo.minRequiredVersion);

      // 5. Compare semantic versions
      if (current < minRequiredVer) {
        state = state.copyWith(
          status: UpdateStatus.mandatoryUpdateRequired,
          releaseInfo: releaseInfo,
        );
      } else if (current < latestVer) {
        state = state.copyWith(
          status: UpdateStatus.updateAvailable,
          releaseInfo: releaseInfo,
        );
      } else {
        state = state.copyWith(
          status: UpdateStatus.upToDate,
          releaseInfo: releaseInfo,
        );
      }
    } on DioException catch (dioErr) {
      final msg = dioErr.response?.statusCode == 403
          ? 'GitHub rate limit exceeded. Please try again later.'
          : 'Network error checking for updates: ${dioErr.message}';
      state = state.copyWith(
        status: UpdateStatus.error,
        errorMessage: msg,
      );
    } catch (e) {
      state = state.copyWith(
        status: UpdateStatus.error,
        errorMessage: 'Failed to verify updates: $e',
      );
    }
  }

  /// Downloads the platform-specific installer asset with progress tracking.
  Future<void> downloadUpdate() async {
    final info = state.releaseInfo;
    if (info == null) return;

    final targetUrl = _getPlatformDownloadUrl(info);
    if (targetUrl == null) {
      state = state.copyWith(
        status: UpdateStatus.error,
        errorMessage:
            'No installer package found for current platform (${Platform.operatingSystem}).',
      );
      return;
    }

    _cancelToken?.cancel();
    _cancelToken = CancelToken();

    state = state.copyWith(
      status: UpdateStatus.downloading,
      downloadProgress: 0.0,
      errorMessage: null,
    );

    try {
      final tempDir = await getTemporaryDirectory();
      final uri = Uri.parse(targetUrl);
      final rawFileName = p.basename(uri.path);
      final fileName = rawFileName.isNotEmpty ? rawFileName : _defaultInstallerName();
      final savePath = p.join(tempDir.path, fileName);

      // Remove any incomplete previous download
      final file = File(savePath);
      if (await file.exists()) {
        await file.delete();
      }

      await _dio.download(
        targetUrl,
        savePath,
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            final progress = (received / total).clamp(0.0, 1.0);
            state = state.copyWith(downloadProgress: progress);
          }
        },
      );

      state = state.copyWith(
        status: UpdateStatus.readyToInstall,
        downloadedFilePath: savePath,
        downloadProgress: 1.0,
      );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        state = state.copyWith(
          status: UpdateStatus.updateAvailable,
          downloadProgress: 0.0,
        );
      } else {
        state = state.copyWith(
          status: UpdateStatus.error,
          errorMessage: 'Download failed: ${e.message}',
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: UpdateStatus.error,
        errorMessage: 'An error occurred during installer download: $e',
      );
    }
  }

  /// Cancels an in-progress download.
  void cancelDownload() {
    _cancelToken?.cancel('Cancelled by user');
    state = state.copyWith(
      status: UpdateStatus.updateAvailable,
      downloadProgress: 0.0,
    );
  }

  /// Launches the downloaded installer or file.
  Future<void> installUpdate() async {
    final path = state.downloadedFilePath;
    if (path == null || !File(path).existsSync()) {
      state = state.copyWith(
        status: UpdateStatus.error,
        errorMessage: 'Downloaded installer file not found on disk.',
      );
      return;
    }

    try {
      if (Platform.isAndroid) {
        // Use OpenFilex to initiate APK Package Installer intent
        final result = await OpenFilex.open(path);
        if (result.type != ResultType.done) {
          state = state.copyWith(
            status: UpdateStatus.error,
            errorMessage: 'Could not open APK installer: ${result.message}',
          );
        }
      } else if (Platform.isWindows) {
        // Windows executable installer
        await Process.start(path, [], runInShell: true);
      } else if (Platform.isLinux) {
        // Make executable and launch or open
        await Process.run('chmod', ['+x', path]);
        if (path.endsWith('.deb')) {
          await Process.start('xdg-open', [path], runInShell: true);
        } else {
          await Process.start(path, [], runInShell: true);
        }
      }
    } catch (e) {
      state = state.copyWith(
        status: UpdateStatus.error,
        errorMessage: 'Failed to launch installer: $e',
      );
    }
  }

  /// Resolves the URL for the current host operating system.
  String? _getPlatformDownloadUrl(ReleaseInfo info) {
    if (Platform.isAndroid) return info.androidApkUrl;
    if (Platform.isWindows) return info.windowsUrl;
    if (Platform.isLinux) return info.linuxUrl;
    return null;
  }

  String _defaultInstallerName() {
    if (Platform.isAndroid) return 'tijori_update.apk';
    if (Platform.isWindows) return 'tijori_setup.exe';
    return 'tijori_update.AppImage';
  }
}

/// Singleton Riverpod provider for OTA update state.
final otaUpdateProvider =
    NotifierProvider<OtaUpdateNotifier, UpdateState>(OtaUpdateNotifier.new);
