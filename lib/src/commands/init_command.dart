import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import '../exception.dart';

/// A command to initialize the directory structure based on `clean_template.yaml`.
///
/// This command must be run from the root of a Dart or Flutter project.
class InitCommand extends Command<int> {
  @override
  final name = 'init';
  @override
  final description =
      'Initializes the directory structure based on clean_template.yaml.';

  /// Creates an instance of the [InitCommand].
  InitCommand();

  @override
  Future<int> run() async {
    final runner = InitCommandRunner(Directory.current);
    try {
      await runner.run();
      return 0;
    } on CleanTemplateException catch (e) {
      print(e.message);
      return e.exitCode;
    }
  }
}

/// A runner for the [InitCommand] that contains the actual logic.
class InitCommandRunner {
  /// Creates an instance of the [InitCommandRunner].
  InitCommandRunner(this.workingDirectory);

  /// The working directory.
  final Directory workingDirectory;

  /// Runs the command.
  Future<void> run() async {
    final libDir = Directory(p.join(workingDirectory.path, 'lib'));
    final pubspecFile = File(p.join(workingDirectory.path, 'pubspec.yaml'));

    if (!libDir.existsSync() || !pubspecFile.existsSync()) {
      throw CleanTemplateException(
        'Error: `lib` directory or `pubspec.yaml` not found. This command must be run from the root of a Dart or Flutter project.',
        exitCode: 1,
      );
    }

    final configFile = File(
      p.join(workingDirectory.path, 'clean_template.yaml'),
    );
    if (!configFile.existsSync()) {
      throw CleanTemplateException(
        'Error: `clean_template.yaml` not found. Please run `create-config` first.',
        exitCode: 1,
      );
    }

    final configString = await configFile.readAsString();
    final config = loadYaml(configString);

    final initConfig = config['init'];
    final initList = initConfig is YamlList ? initConfig : YamlList();

    if (!initList.contains('lib/features/')) {
      final dir = Directory(p.join(workingDirectory.path, 'lib', 'features'));
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
        print('Created directory: lib/features/');
      }
    }

    for (final path in initList) {
      final newPath = p.join(workingDirectory.path, path);
      if (path.endsWith('/')) {
        final dir = Directory(newPath);
        if (!dir.existsSync()) {
          await dir.create(recursive: true);
          print('Created directory: $path');
        }
      } else {
        final file = File(newPath);
        if (!file.existsSync()) {
          await file.create(recursive: true);
          print('Created file: $path');
        }
      }
    }
  }
}
