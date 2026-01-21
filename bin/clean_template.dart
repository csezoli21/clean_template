import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:clean_template/src/commands/create_config_command.dart';
import 'package:clean_template/src/commands/feature_command.dart';
import 'package:clean_template/src/commands/init_command.dart';

/// The main entry point of the CLI.
void main(List<String> arguments) {
  final runner = CommandRunner<int>('clean_template',
      'A CLI tool for creating a clean architecture template for Flutter projects.')
    ..addCommand(CreateConfigCommand())
    ..addCommand(InitCommand())
    ..addCommand(FeatureCommand());

  runner.run(arguments).catchError((error) {
    if (error is! UsageException) throw error;
    print(error);
    exit(64); // Exit code 64 indicates a usage error.
  });
}
