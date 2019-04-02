///
//  Generated code. Do not modify.
//  source: google/protobuf/struct.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'struct.pbenum.dart';

export 'struct.pbenum.dart';

class Struct extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Struct',
      package: const $pb.PackageName('google.protobuf'))
    ..m<String, Value>(
        1,
        'fields',
        'Struct.FieldsEntry',
        $pb.PbFieldType.OS,
        $pb.PbFieldType.OM,
        Value.create,
        null,
        null,
        const $pb.PackageName('google.protobuf'))
    ..hasRequiredFields = false;

  Struct() : super();
  Struct.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  Struct.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  Struct clone() => new Struct()..mergeFromMessage(this);
  Struct copyWith(void Function(Struct) updates) =>
      super.copyWith((message) => updates(message as Struct));
  $pb.BuilderInfo get info_ => _i;
  static Struct create() => new Struct();
  Struct createEmptyInstance() => create();
  static $pb.PbList<Struct> createRepeated() => new $pb.PbList<Struct>();
  static Struct getDefault() => _defaultInstance ??= create()..freeze();
  static Struct _defaultInstance;

  Map<String, Value> get fields => $_getMap(0);
}

enum Value_Kind {
  nullValue,
  numberValue,
  stringValue,
  boolValue,
  structValue,
  listValue,
  notSet
}

class Value extends $pb.GeneratedMessage {
  static const Map<int, Value_Kind> _Value_KindByTag = {
    1: Value_Kind.nullValue,
    2: Value_Kind.numberValue,
    3: Value_Kind.stringValue,
    4: Value_Kind.boolValue,
    5: Value_Kind.structValue,
    6: Value_Kind.listValue,
    0: Value_Kind.notSet
  };
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Value',
      package: const $pb.PackageName('google.protobuf'))
    ..e<NullValue>(1, 'nullValue', $pb.PbFieldType.OE, NullValue.NULL_VALUE,
        NullValue.valueOf, NullValue.values)
    ..a<double>(2, 'numberValue', $pb.PbFieldType.OD)
    ..aOS(3, 'stringValue')
    ..aOB(4, 'boolValue')
    ..a<Struct>(
        5, 'structValue', $pb.PbFieldType.OM, Struct.getDefault, Struct.create)
    ..a<ListValue>(6, 'listValue', $pb.PbFieldType.OM, ListValue.getDefault,
        ListValue.create)
    ..oo(0, [1, 2, 3, 4, 5, 6])
    ..hasRequiredFields = false;

  Value() : super();
  Value.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  Value.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  Value clone() => new Value()..mergeFromMessage(this);
  Value copyWith(void Function(Value) updates) =>
      super.copyWith((message) => updates(message as Value));
  $pb.BuilderInfo get info_ => _i;
  static Value create() => new Value();
  Value createEmptyInstance() => create();
  static $pb.PbList<Value> createRepeated() => new $pb.PbList<Value>();
  static Value getDefault() => _defaultInstance ??= create()..freeze();
  static Value _defaultInstance;

  Value_Kind whichKind() => _Value_KindByTag[$_whichOneof(0)];
  void clearKind() => clearField($_whichOneof(0));

  NullValue get nullValue => $_getN(0);
  set nullValue(NullValue v) {
    setField(1, v);
  }

  bool hasNullValue() => $_has(0);
  void clearNullValue() => clearField(1);

  double get numberValue => $_getN(1);
  set numberValue(double v) {
    $_setDouble(1, v);
  }

  bool hasNumberValue() => $_has(1);
  void clearNumberValue() => clearField(2);

  String get stringValue => $_getS(2, '');
  set stringValue(String v) {
    $_setString(2, v);
  }

  bool hasStringValue() => $_has(2);
  void clearStringValue() => clearField(3);

  bool get boolValue => $_get(3, false);
  set boolValue(bool v) {
    $_setBool(3, v);
  }

  bool hasBoolValue() => $_has(3);
  void clearBoolValue() => clearField(4);

  Struct get structValue => $_getN(4);
  set structValue(Struct v) {
    setField(5, v);
  }

  bool hasStructValue() => $_has(4);
  void clearStructValue() => clearField(5);

  ListValue get listValue => $_getN(5);
  set listValue(ListValue v) {
    setField(6, v);
  }

  bool hasListValue() => $_has(5);
  void clearListValue() => clearField(6);
}

class ListValue extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ListValue',
      package: const $pb.PackageName('google.protobuf'))
    ..pc<Value>(1, 'values', $pb.PbFieldType.PM, Value.create)
    ..hasRequiredFields = false;

  ListValue() : super();
  ListValue.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ListValue.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ListValue clone() => new ListValue()..mergeFromMessage(this);
  ListValue copyWith(void Function(ListValue) updates) =>
      super.copyWith((message) => updates(message as ListValue));
  $pb.BuilderInfo get info_ => _i;
  static ListValue create() => new ListValue();
  ListValue createEmptyInstance() => create();
  static $pb.PbList<ListValue> createRepeated() => new $pb.PbList<ListValue>();
  static ListValue getDefault() => _defaultInstance ??= create()..freeze();
  static ListValue _defaultInstance;

  List<Value> get values => $_getList(0);
}
