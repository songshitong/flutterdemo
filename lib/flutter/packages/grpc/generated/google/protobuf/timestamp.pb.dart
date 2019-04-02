///
//  Generated code. Do not modify.
//  source: google/protobuf/timestamp.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'dart:core' as $core show DateTime, Duration;

class Timestamp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Timestamp',
      package: const $pb.PackageName('google.protobuf'))
    ..aInt64(1, 'seconds')
    ..a<int>(2, 'nanos', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  Timestamp() : super();
  Timestamp.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  Timestamp.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  Timestamp clone() => new Timestamp()..mergeFromMessage(this);
  Timestamp copyWith(void Function(Timestamp) updates) =>
      super.copyWith((message) => updates(message as Timestamp));
  $pb.BuilderInfo get info_ => _i;
  static Timestamp create() => new Timestamp();
  Timestamp createEmptyInstance() => create();
  static $pb.PbList<Timestamp> createRepeated() => new $pb.PbList<Timestamp>();
  static Timestamp getDefault() => _defaultInstance ??= create()..freeze();
  static Timestamp _defaultInstance;

  Int64 get seconds => $_getI64(0);
  set seconds(Int64 v) {
    $_setInt64(0, v);
  }

  bool hasSeconds() => $_has(0);
  void clearSeconds() => clearField(1);

  int get nanos => $_get(1, 0);
  set nanos(int v) {
    $_setSignedInt32(1, v);
  }

  bool hasNanos() => $_has(1);
  void clearNanos() => clearField(2);

  /// Converts an instance to [DateTime].
  ///
  /// The result is in UTC time zone and has microsecond precision, as
  /// [DateTime] does not support nanosecond precision.
  $core.DateTime toDateTime() => new $core.DateTime.fromMicrosecondsSinceEpoch(
      seconds.toInt() * $core.Duration.microsecondsPerSecond + nanos ~/ 1000,
      isUtc: true);

  /// Creates a new instance from [dateTime].
  ///
  /// Time zone information will not be preserved.
  static Timestamp fromDateTime($core.DateTime dateTime) {
    int micros = dateTime.microsecondsSinceEpoch;
    return new Timestamp()
      ..seconds = new Int64(micros ~/ $core.Duration.microsecondsPerSecond)
      ..nanos = (micros % $core.Duration.microsecondsPerSecond).toInt() * 1000;
  }
}
