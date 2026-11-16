import 'package:flutter_test/flutter_test.dart';
import 'package:tijori/core/updater/update_models.dart';

void main() {
  group('SemanticVersion Pre-Release & SemVer 2.0.0 Compliance', () {
    test('parses pre-release and build numbers simultaneously', () {
      final v = SemanticVersion.parse('v2.1.0-beta.2+42');
      expect(v.major, equals(2));
      expect(v.minor, equals(1));
      expect(v.patch, equals(0));
      expect(v.preRelease, equals('beta.2'));
      expect(v.build, equals(42));
      expect(v.toString(), equals('2.1.0-beta.2+42'));
    });

    test('pre-release has lower precedence than a normal release version', () {
      final release = SemanticVersion.parse('1.0.0');
      final beta = SemanticVersion.parse('1.0.0-beta');
      final alpha = SemanticVersion.parse('1.0.0-alpha');

      expect(beta < release, isTrue);
      expect(release > beta, isTrue);
      expect(alpha < beta, isTrue);
      expect(beta.compareTo(release), equals(-1));
      expect(release.compareTo(beta), equals(1));
    });

    test('pre-release lexicographical comparison works between pre-releases', () {
      final rc1 = SemanticVersion.parse('2.0.0-rc.1');
      final rc2 = SemanticVersion.parse('2.0.0-rc.2');

      expect(rc1 < rc2, isTrue);
      expect(rc2 > rc1, isTrue);
    });

    test('equality and hashcode accurately reflect pre-release differences', () {
      final v1 = SemanticVersion.parse('1.0.0-beta');
      final v2 = SemanticVersion.parse('1.0.0-beta');
      final v3 = SemanticVersion.parse('1.0.0-rc');
      final v4 = SemanticVersion.parse('1.0.0');

      expect(v1, equals(v2));
      expect(v1.hashCode, equals(v2.hashCode));
      expect(v1 == v3, isFalse);
      expect(v1 == v4, isFalse);
    });

    test('toString formats correctly in all configurations', () {
      expect(const SemanticVersion(major: 1, minor: 2, patch: 3).toString(), '1.2.3');
      expect(const SemanticVersion(major: 1, minor: 2, patch: 3, build: 5).toString(), '1.2.3+5');
      expect(const SemanticVersion(major: 1, minor: 2, patch: 3, preRelease: 'rc1').toString(), '1.2.3-rc1');
      expect(const SemanticVersion(major: 1, minor: 2, patch: 3, preRelease: 'rc1', build: 9).toString(), '1.2.3-rc1+9');
    });
  });

  group('UpdateState isMandatory Logic', () {
    test('isMandatory is true when status is mandatoryUpdateRequired', () {
      const state = UpdateState(status: UpdateStatus.mandatoryUpdateRequired);
      expect(state.isMandatory, isTrue);
    });

    test('isMandatory evaluates version thresholds accurately', () {
      const releaseInfo = ReleaseInfo(
        latestVersion: '2.0.0',
        minRequiredVersion: '1.5.0',
        changelog: 'Breaking migration',
      );

      const stateBelow = UpdateState(
        status: UpdateStatus.downloading,
        releaseInfo: releaseInfo,
        currentVersion: SemanticVersion(major: 1, minor: 2, patch: 0),
      );
      expect(stateBelow.isMandatory, isTrue);

      const stateEqual = UpdateState(
        status: UpdateStatus.downloading,
        releaseInfo: releaseInfo,
        currentVersion: SemanticVersion(major: 1, minor: 5, patch: 0),
      );
      expect(stateEqual.isMandatory, isFalse);

      const stateAbove = UpdateState(
        status: UpdateStatus.downloading,
        releaseInfo: releaseInfo,
        currentVersion: SemanticVersion(major: 1, minor: 8, patch: 0),
      );
      expect(stateAbove.isMandatory, isFalse);
    });

    test('isMandatory returns false if releaseInfo or currentVersion is missing and status not mandatory', () {
      const state = UpdateState(status: UpdateStatus.idle);
      expect(state.isMandatory, isFalse);
    });
  });
}
