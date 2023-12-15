import 'package:protobuf_wellknown/protobuf_wellknown.dart';
import 'package:test/test.dart';

void main() {
  group('google/protobuf', () {
    test('Empty', () {
      expect(Empty(), isA<Empty>());
    });
  });
}
