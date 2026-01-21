# Clean Template

A CLI tool to bootstrap a clean architecture for your Dart and Flutter projects.

## Installation

```bash
dart pub global activate clean_template
```

## Usage

### `create-config`

This command creates a `clean_template.yaml` file in your project's root directory. This file defines the directory structure for your project.

This command needs to be run from the root of your project, where the `lib` directory is located.

```bash
clean_template create-config
```

You can customize the `clean_template.yaml` file to fit your needs.

### Configuration File

The `clean_template.yaml` file defines the directory and file structure for your project.

**Directory and File Creation:**

- **Directories:** To define a directory, the path must end with a `/`.
  Example: `lib/core/error/`

- **Files:** To define a file, the path should not end with a `/`.
  Example: `lib/core/error/failures.dart`

**Important Notes:**

- The `lib/features/` directory is a special directory used by the `feature` command and cannot be removed or modified in the configuration.



### `init`

This command initializes the project structure based on the `init` section in `clean_template.yaml`.

This command needs to be run from the root of your project, where the `lib` directory is located.

```bash
clean_template init
```


### `feature`

This command creates a new feature based on the `feature` section in `clean_template.yaml`.

This command needs to be run from the root of your project, where the `lib` directory is located.

```bash
clean_template feature --name <feature_name>
```

Replace `<feature_name>` with the name of your feature. The command will replace all instances of `<feature_name>` in the yaml file with the provided name.

## Support

If you like this project, you can support me by buying me a coffee.

[Buy me a coffee](https://buymeacoffee.com/csezoli)