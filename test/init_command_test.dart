import 'dart:io';

import 'package:clean_template/src/commands/init_command.dart';
import 'package:clean_template/src/exception.dart';
import 'package:test/test.dart';

void main() {
  group('InitCommandRunner', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync();
    });

    tearDown(() {
      tempDir.deleteSync(recursive: true);
    });

    test('throws when not in a Dart or Flutter project', () {
      final runner = InitCommandRunner(tempDir);
      expect(runner.run(), throwsA(isA<CleanTemplateException>()));
    });

    test('throws when clean_template.yaml does not exist', () {
      // Arrange
      final libDir = Directory('${tempDir.path}/lib');
      libDir.createSync();
      final pubspecFile = File('${tempDir.path}/pubspec.yaml');
      pubspecFile.createSync();
      final runner = InitCommandRunner(tempDir);

      // Act & Assert
      expect(runner.run(), throwsA(isA<CleanTemplateException>()));
    });

    test('creates directories and files from clean_template.yaml', () async {
      // Arrange
      final libDir = Directory('${tempDir.path}/lib');
      libDir.createSync();
      final pubspecFile = File('${tempDir.path}/pubspec.yaml');
      pubspecFile.createSync();
      final configFile = File('${tempDir.path}/clean_template.yaml');
      await configFile.writeAsString('''
init:
  - lib/core/error/
  - lib/core/error/failures.dart
''');
      final runner = InitCommandRunner(tempDir);

      // Act
      await runner.run();

      // Assert
      final dir = Directory('${tempDir.path}/lib/core/error/');
      final file = File('${tempDir.path}/lib/core/error/failures.dart');
      expect(dir.existsSync(), isTrue);
      expect(file.existsSync(), isTrue);
    });

    test('creates lib/features/ directory even if not in config', () async {
      // Arrange
      final libDir = Directory('${tempDir.path}/lib');
      libDir.createSync();
      final pubspecFile = File('${tempDir.path}/pubspec.yaml');
      pubspecFile.createSync();
      final configFile = File('${tempDir.path}/clean_template.yaml');
      await configFile.writeAsString('''
init:
''');
      final runner = InitCommandRunner(tempDir);

      // Act
      await runner.run();

      // Assert
      final dir = Directory('${tempDir.path}/lib/features/');
      expect(dir.existsSync(), isTrue);
    });
  });
}
