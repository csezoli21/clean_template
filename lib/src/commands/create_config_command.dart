import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;

import '../exception.dart';

/// A command to create the `clean_template.yaml` configuration file.
///
/// This command creates a `clean_template.yaml` file with a default
/// structure for your project.
///
/// **Directory and File Creation:**
///
/// - **Directories:** To define a directory, the path must end with a `/`.
///   Example: `lib/core/error/`
///
/// - **Files:** To define a file, the path should not end with a `/`.
///   Example: `lib/core/error/error.dart`
///
/// **Important Notes:**
///
/// - The `lib/features/` directory is a special directory used by the `feature`
///   command and cannot be removed or modified in the configuration.
///
/// This command must be run from the root of a Dart or Flutter project.
class CreateConfigCommand extends Command<int> {
  @override
  final name = 'create-config';
  @override
  final description = 'Creates the clean_template.yaml configuration file.';

  /// Creates an instance of the [CreateConfigCommand].
  CreateConfigCommand();

  @override
  Future<int> run() async {
    final runner = CreateConfigCommandRunner(Directory.current);
    try {
      await runner.run();
      return 0;
    } on CleanTemplateException catch (e) {
      print(e.message);
      return e.exitCode;
    }
  }
}

/// A runner for the [CreateConfigCommand] that contains the actual logic.
class CreateConfigCommandRunner {
  /// Creates an instance of the [CreateConfigCommandRunner].
  CreateConfigCommandRunner(this.workingDirectory);

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

    final file = File(p.join(workingDirectory.path, 'clean_template.yaml'));
    if (file.existsSync()) {
      throw CleanTemplateException(
        'clean_template.yaml already exists.',
        exitCode: 1,
      );
    }

    await file.writeAsString(_defaultConfig);
    print('Created clean_template.yaml');
  }

  /// The default configuration for the `clean_template.yaml` file.
  String get _defaultConfig => '''
# Default structure for the `init` command
init:
  - lib/core/error/failures.dart
  - lib/core/network/
  - lib/core/usecases/
  - lib/core/utils/
  - lib/core/theme/
  - lib/core/widgets/
  - lib/features/

# Default structure for the `feature` command
# The <feature_name> will be replaced with the provided feature name.
feature:
  - lib/features/<feature_name>/data/datasources/
  - lib/features/<feature_name>/data/models/
  - lib/features/<feature_name>/data/repositories/
  - lib/features/<feature_name>/domain/entities/
  - lib/features/<feature_name>/domain/repositories/
  - lib/features/<feature_name>/domain/usecases/
  - lib/features/<feature_name>/presentation/pages/
  - lib/features/<feature_name>/presentation/widgets/
  - lib/features/<feature_name>/presentation/state/
''';
}
