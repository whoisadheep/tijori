/// Application-wide constants.
abstract final class AppConstants {
  /// GitHub repository for OTA updates.
  static const String githubOwner = 'tijori-app';
  static const String githubRepo = 'tijori-releases';
  static const String githubReleasesApi =
      'https://api.github.com/repos/$githubOwner/$githubRepo/releases/latest';

  /// Freemium limits.
  static const int freeMaxActiveLoans = 25;
  static const int offlineGraceDays = 7;

  /// Default interest config.
  static const int defaultGraceDaysForPartialMonth = 15;

  /// App info.
  static const String appName = 'Tijori';
  static const String appTagline = 'Jewellery Girvi, Karigar & Accounting ERP';
}
