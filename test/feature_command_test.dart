import 'dart:io';

import 'package:clean_template/src/commands/feature_command.dart';
import 'package:clean_template/src/exception.dart';
import 'package:test/test.dart';

void main() {
  group('FeatureCommandRunner', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync();
    });

    tearDown(() {
      tempDir.deleteSync(recursive: true);
    });

    test('throws when not in a Dart or Flutter project', () {
      final runner = FeatureCommandRunner(tempDir);
      expect(runner.run('test'), throwsA(isA<CleanTemplateException>()));
    });

    test('throws when feature name is not provided', () {
      // Arrange
      final libDir = Directory('${tempDir.path}/lib');
      libDir.createSync();
      final featuresDir = Directory('${tempDir.path}/lib/features');
      featuresDir.createSync();
      final pubspecFile = File('${tempDir.path}/pubspec.yaml');
      pubspecFile.createSync();
      final runner = FeatureCommandRunner(tempDir);

      // Act & Assert
      expect(runner.run(null), throwsA(isA<CleanTemplateException>()));
    });

    test('throws when init command was not run', () {
      final libDir = Directory('${tempDir.path}/lib');
      libDir.createSync();
      final pubspecFile = File('${tempDir.path}/pubspec.yaml');
      pubspecFile.createSync();
      final runner = FeatureCommandRunner(tempDir);
      expect(runner.run('test'), throwsA(isA<CleanTemplateException>()));
    });

    test('throws when clean_template.yaml does not exist', () {
      // Arrange
      final libDir = Directory('${tempDir.path}/lib');
      libDir.createSync();
      final featuresDir = Directory('${tempDir.path}/lib/features');
      featuresDir.createSync();
      final pubspecFile = File('${tempDir.path}/pubspec.yaml');
      pubspecFile.createSync();
      final runner = FeatureCommandRunner(tempDir);

      // Act & Assert
      expect(runner.run('test'), throwsA(isA<CleanTemplateException>()));
    });

    test('creates directories and files from clean_template.yaml', () async {
      // Arrange
      final libDir = Directory('${tempDir.path}/lib');
      libDir.createSync();
      final featuresDir = Directory('${tempDir.path}/lib/features');
      featuresDir.createSync();
      final pubspecFile = File('${tempDir.path}/pubspec.yaml');
      pubspecFile.createSync();
      final configFile = File('${tempDir.path}/clean_template.yaml');
      await configFile.writeAsString('''
feature:
  - lib/features/<feature_name>/data/datasources/
  - lib/features/<feature_name>/data/models/<feature_name>_model.dart
''');
      final runner = FeatureCommandRunner(tempDir);

      // Act
      await runner.run('test');

      // Assert
      final dir = Directory(
        '${tempDir.path}/lib/features/test/data/datasources/',
      );
      final file = File(
        '${tempDir.path}/lib/features/test/data/models/test_model.dart',
      );
      expect(dir.existsSync(), isTrue);
      expect(file.existsSync(), isTrue);
    });
  });
}
