import 'dart:convert';
import 'dart:io';

import 'package:build/build.dart';
import 'package:path/path.dart';

Builder protocBuilder(BuilderOptions options) => ProtocBuilder();

const wellKnownTypeFiles = [
  "google/protobuf/any.proto",
  "google/protobuf/api.proto",
  "google/protobuf/descriptor.proto",
  "google/protobuf/duration.proto",
  "google/protobuf/empty.proto",
  "google/protobuf/field_mask.proto",
  "google/protobuf/source_context.proto",
  "google/protobuf/struct.proto",
  "google/protobuf/timestamp.proto",
  "google/protobuf/type.proto",
  "google/protobuf/wrappers.proto",
];

class ProtocBuilder implements Builder {
  final String outPath = "lib";

  @override
  Future build(BuildStep buildStep) async {
    final pluginPath = absolute('tool/protoc-gen-dart.sh');

    // We run protoc against a temporary directory for two reasons:
    //
    //   1) buildStep tracks which files were written and
    //   2) to support writing to the Dart cache directory,
    //      which we don't "know" the name of.
    final tempDir =
        await Directory.systemTemp.createTemp('protobuf_wellknown_builder');

    final tempOutDir = await Directory(join(tempDir.path, outPath)).create();

    try {
      await ProcessExtensions.runSafely(
        'protoc',
        [
          '--plugin=protoc-gen-dart=$pluginPath',
          '--dart_out=${tempOutDir.path}',
          ...wellKnownTypeFiles.map((f) => join('/usr/include', f)),
        ],
      );

      // The build runner spies on what we write, so we
      // need to write each output file explicitly, even though they've already
      // been written by protoc. This will ensure that if an output file is
      // deleted, a future build will recreate it. This also checks that the files
      // we were expected to write were actually written, since this will fail if
      // an output file wasn't created by protoc.
      await Future.wait(buildStep.allowedOutputs.map((AssetId out) async {
        await buildStep.writeAsBytes(
            out, File(join(tempDir.path, out.path)).readAsBytes());
      }));
    } finally {
      await tempDir.delete(recursive: true);
    }
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        r'$package$': wellKnownTypeFiles
            .map(
              (f) => join(outPath, f),
            )
            .expand((f) => [
                  f.replaceFirst('.proto', '.pb.dart'),
                  f.replaceFirst('.proto', '.pbenum.dart'),
                  f.replaceFirst('.proto', '.pbjson.dart'),
                  f.replaceFirst('.proto', '.pbserver.dart'),
                ])
            .toList()
      };
}

/// An error describing the failure of a [Process].
class ProcessError extends Error {
  ProcessError(this.executable, this.arguments, this.result);

  final String executable;
  final List<String> arguments;
  final ProcessResult result;

  @override
  String toString() {
    return '''
A process finished with exit code ${result.exitCode}:

Call:
"$executable", ${json.encode(arguments)}

Standard error output:
${result.stderr}
    ''';
  }
}

extension ProcessExtensions on Process {
  /// Runs [Process#run] but throws a [ProcessError] if the [Process] exits with
  /// a non-zero status code.
  static Future<ProcessResult> runSafely(
      String executable, List<String> arguments,
      {String? workingDirectory,
      Map<String, String>? environment,
      bool includeParentEnvironment = true,
      bool runInShell = false,
      Encoding? stdoutEncoding = systemEncoding,
      Encoding? stderrEncoding = systemEncoding}) async {
    final result = await Process.run(
      executable,
      arguments,
      workingDirectory: workingDirectory,
      environment: environment,
      includeParentEnvironment: includeParentEnvironment,
      runInShell: runInShell,
      stdoutEncoding: stdoutEncoding,
      stderrEncoding: stderrEncoding,
    );
    if (result.exitCode != 0) throw ProcessError(executable, arguments, result);
    return result;
  }
}
