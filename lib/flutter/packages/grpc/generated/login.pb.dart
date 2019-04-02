///
//  Generated code. Do not modify.
//  source: login.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

class Empty extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i =
      new $pb.BuilderInfo('Empty', package: const $pb.PackageName('login'))
        ..hasRequiredFields = false;

  Empty() : super();
  Empty.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  Empty.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  Empty clone() => new Empty()..mergeFromMessage(this);
  Empty copyWith(void Function(Empty) updates) =>
      super.copyWith((message) => updates(message as Empty));
  $pb.BuilderInfo get info_ => _i;
  static Empty create() => new Empty();
  Empty createEmptyInstance() => create();
  static $pb.PbList<Empty> createRepeated() => new $pb.PbList<Empty>();
  static Empty getDefault() => _defaultInstance ??= create()..freeze();
  static Empty _defaultInstance;
}

class LoginResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('LoginResponse',
      package: const $pb.PackageName('login'))
    ..a<int>(1, 'appId', $pb.PbFieldType.O3)
    ..aInt64(2, 'userId')
    ..aOS(3, 'userName')
    ..m<String, String>(
        4,
        'extras',
        'LoginResponse.ExtrasEntry',
        $pb.PbFieldType.OS,
        $pb.PbFieldType.OS,
        null,
        null,
        null,
        const $pb.PackageName('login'))
    ..pPS(5, 'msg')
    ..aOB(6, 'isVip')
    ..hasRequiredFields = false;

  LoginResponse() : super();
  LoginResponse.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  LoginResponse.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  LoginResponse clone() => new LoginResponse()..mergeFromMessage(this);
  LoginResponse copyWith(void Function(LoginResponse) updates) =>
      super.copyWith((message) => updates(message as LoginResponse));
  $pb.BuilderInfo get info_ => _i;
  static LoginResponse create() => new LoginResponse();
  LoginResponse createEmptyInstance() => create();
  static $pb.PbList<LoginResponse> createRepeated() =>
      new $pb.PbList<LoginResponse>();
  static LoginResponse getDefault() => _defaultInstance ??= create()..freeze();
  static LoginResponse _defaultInstance;

  int get appId => $_get(0, 0);
  set appId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasAppId() => $_has(0);
  void clearAppId() => clearField(1);

  Int64 get userId => $_getI64(1);
  set userId(Int64 v) {
    $_setInt64(1, v);
  }

  bool hasUserId() => $_has(1);
  void clearUserId() => clearField(2);

  String get userName => $_getS(2, '');
  set userName(String v) {
    $_setString(2, v);
  }

  bool hasUserName() => $_has(2);
  void clearUserName() => clearField(3);

  Map<String, String> get extras => $_getMap(3);

  List<String> get msg => $_getList(4);

  bool get isVip => $_get(5, false);
  set isVip(bool v) {
    $_setBool(5, v);
  }

  bool hasIsVip() => $_has(5);
  void clearIsVip() => clearField(6);
}
