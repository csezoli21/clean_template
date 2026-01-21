import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import '../exception.dart';

/// A command to create a new feature based on `clean_template.yaml`.
///
/// This command must be run from the root of a Dart or Flutter project.
class FeatureCommand extends Command<int> {
  @override
  final name = 'feature';
  @override
  final description = 'Creates a new feature based on clean_template.yaml.';

  /// Creates an instance of the [FeatureCommand].
  FeatureCommand() {
    argParser.addOption('name', abbr: 'n', help: 'The name of the feature.');
  }

  @override
  Future<int> run() async {
    final runner = FeatureCommandRunner(Directory.current);
    try {
      await runner.run(argResults!['name']);
      return 0;
    } on CleanTemplateException catch (e) {
      print(e.message);
      return e.exitCode;
    }
  }
}

/// A runner for the [FeatureCommand] that contains the actual logic.
class FeatureCommandRunner {
  /// Creates an instance of the [FeatureCommandRunner].
  FeatureCommandRunner(this.workingDirectory);

  /// The working directory.
  final Directory workingDirectory;

  /// Runs the command.
  Future<void> run(String? featureName) async {
    final libDir = Directory(p.join(workingDirectory.path, 'lib'));
    final pubspecFile = File(p.join(workingDirectory.path, 'pubspec.yaml'));
    final featuresDir =
        Directory(p.join(workingDirectory.path, 'lib', 'features'));

    if (!featuresDir.existsSync()) {
      throw CleanTemplateException(
        'Error: `lib/features` directory not found. Please run `init` first.',
        exitCode: 1,
      );
    }

    if (!libDir.existsSync() || !pubspecFile.existsSync()) {
      throw CleanTemplateException(
        'Error: `lib` directory or `pubspec.yaml` not found. This command must be run from the root of a Dart or Flutter project.',
        exitCode: 1,
      );
    }

    if (featureName == null) {
      throw CleanTemplateException(
        'Error: The `name` argument is required.',
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

    final featureConfig = config['feature'];
    final featureList = featureConfig is YamlList ? featureConfig : YamlList();

    for (final path in featureList) {
      final newPath = path.replaceAll('<feature_name>', featureName);
      final absolutePath = p.join(workingDirectory.path, newPath);
      if (newPath.endsWith('/')) {
        final dir = Directory(absolutePath);
        if (!dir.existsSync()) {
          await dir.create(recursive: true);
          print('Created directory: $newPath');
        }
      } else {
        final file = File(absolutePath);
        if (!file.existsSync()) {
          await file.create(recursive: true);
          print('Created file: $newPath');
        }
      }
    }
  }
}
