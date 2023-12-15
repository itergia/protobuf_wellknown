The well-known types from the Google Protobuf compiler.

This is similar to [protobuf_google](https://pub.dev/packages/protobuf_google), but includes a builder to generate the files, and uses [protobuf](https://pub.dev/packages/protobuf) version 3.

See https://protobuf.dev/reference/protobuf/google.protobuf/ for more information.

## Features

Includes a library to import all types at once, for use in your day-to-day development.

It also exports each type separately, useful in the compiled Protobuf files.
You will likely only care about the `.pb.dart` files.
`protoc-gen-dart` generates separate `.pbenum` and `.pbjson` files for the sake of Dartium, and it's unclear if these should ever be imported manually.
See [the `protobuf.dart` commit](https://github.com/google/protobuf.dart/commit/f0326013944de7f11e1db8a5d60ccdf99d6c9b1f).

## Getting started

```sh
dart pub add protobuf_wellknown
```

## Usage

```dart
import "package:protobuf_wellknown/protobuf_wellknown.dart";
```

See https://pub.dev/packages/protobuf_wellknown.

## Contributions

* Includes code from https://github.com/pikaju/dart-protoc-builder.
