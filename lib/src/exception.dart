/// An exception that contains a message and an exit code.
class CleanTemplateException implements Exception {
  /// Creates an instance of the [CleanTemplateException].
  CleanTemplateException(this.message, {this.exitCode = 1});

  /// The message to display.
  final String message;

  /// The exit code to use.
  final int exitCode;
}
