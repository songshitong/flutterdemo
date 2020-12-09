///
//  Generated code. Do not modify.
//  source: login.proto
///
import 'dart:async' as $async;

import 'package:grpc/service_api.dart' as $grpc;

import 'login.pb.dart';

export 'login.pb.dart';

class LoginClient extends $grpc.Client {
  static final _$startLogin = new $grpc.ClientMethod<Empty, LoginResponse>(
      '/login.Login/startLogin',
      ((Empty value) => value.writeToBuffer()) as List<int> Function(Empty),
      (List<int> value) => new LoginResponse.fromBuffer(value));
  static final _$startLoginAgain =
      new $grpc.ClientMethod<LoginResponse, LoginResponse>(
          '/login.Login/startLoginAgain',
          ((LoginResponse value) => value.writeToBuffer()) as List<int>
              Function(LoginResponse),
          (List<int> value) => new LoginResponse.fromBuffer(value));

  LoginClient($grpc.ClientChannel channel, {$grpc.CallOptions? options})
      : super(channel, options: options);

  $grpc.ResponseFuture<LoginResponse> startLogin(Empty request,
      {required $grpc.CallOptions options}) {
    final call = $createCall(
        _$startLogin, new $async.Stream.fromIterable([request]),
        options: options);
    return new $grpc.ResponseFuture(call);
  }

  $grpc.ResponseStream<LoginResponse> startLoginAgain(
      $async.Stream<LoginResponse> request,
      {$grpc.CallOptions? options}) {
    final call = $createCall(_$startLoginAgain, request, options: options);
    return new $grpc.ResponseStream(call);
  }
}

abstract class LoginServiceBase extends $grpc.Service {
  String get $name => 'login.Login';

  LoginServiceBase() {
    $addMethod(new $grpc.ServiceMethod<Empty, LoginResponse>(
        'startLogin',
        startLogin_Pre,
        false,
        false,
        (List<int> value) => new Empty.fromBuffer(value),
        (LoginResponse value) => value.writeToBuffer()));
    $addMethod(new $grpc.ServiceMethod<LoginResponse, LoginResponse>(
        'startLoginAgain',
        startLoginAgain,
        true,
        true,
        (List<int> value) => new LoginResponse.fromBuffer(value),
        (LoginResponse value) => value.writeToBuffer()));
  }

  $async.Future<LoginResponse> startLogin_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return startLogin(call, await (request as $async.FutureOr<Empty>));
  }

  $async.Future<LoginResponse> startLogin(
      $grpc.ServiceCall call, Empty request);
  $async.Stream<LoginResponse> startLoginAgain(
      $grpc.ServiceCall call, $async.Stream<LoginResponse> request);
}
