The well-known types from the Google Protobuf compiler.

This is similar to [protobuf_google](https://pub.dev/packages/protobuf_google), but includes a builder to generate the files, and uses [protobuf](https://pub.dev/packages/protobuf) version 3.

See https://protobuf.dev/reference/protobuf/google.protobuf/ for more information.

## Features

Includes a library to import all types at once, for use in your day-to-day development.

It also exports each type separately, useful in the compiled Protobuf files.

## Getting started

```sh
dart pub add protobuf_wellknown
```

## Usage

```dart
import "package:protobuf_wellknown/protobuf_wellknown.dart";
```

## Contributions

* Includes code from https://github.com/pikaju/dart-protoc-builder.
