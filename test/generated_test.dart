import 'package:protobuf_wellknown/google/protobuf/empty.pb.dart';
import 'package:test/test.dart';

void main() {
  group('google/protobuf', () {
    test('Empty', () {
      expect(Empty(), isA<Empty>());
    });
  });
}
