import 'dart:io';

import 'package:clean_template/src/commands/create_config_command.dart';
import 'package:clean_template/src/exception.dart';
import 'package:test/test.dart';

void main() {
  group('CreateConfigCommandRunner', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync();
    });

    tearDown(() {
      tempDir.deleteSync(recursive: true);
    });

    test('throws when not in a Dart or Flutter project', () {
      final runner = CreateConfigCommandRunner(tempDir);
      expect(runner.run(), throwsA(isA<CleanTemplateException>()));
    });

    test('creates clean_template.yaml when it does not exist', () async {
      // Arrange
      final libDir = Directory('${tempDir.path}/lib');
      libDir.createSync();
      final pubspecFile = File('${tempDir.path}/pubspec.yaml');
      pubspecFile.createSync();
      final runner = CreateConfigCommandRunner(tempDir);

      // Act
      await runner.run();

      // Assert
      final file = File('${tempDir.path}/clean_template.yaml');
      expect(file.existsSync(), isTrue);
    });

    test('throws when clean_template.yaml already exists', () {
      // Arrange
      final libDir = Directory('${tempDir.path}/lib');
      libDir.createSync();
      final pubspecFile = File('${tempDir.path}/pubspec.yaml');
      pubspecFile.createSync();
      final file = File('${tempDir.path}/clean_template.yaml');
      file.createSync();
      final runner = CreateConfigCommandRunner(tempDir);

      // Act & Assert
      expect(runner.run(), throwsA(isA<CleanTemplateException>()));
    });
  });
}
