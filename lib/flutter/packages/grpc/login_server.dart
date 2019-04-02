import 'package:fixnum/fixnum.dart';
import 'package:flutterdemo/flutter/packages/grpc/generated/login.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:grpc/src/server/call.dart';

class LoginService extends LoginServiceBase {
  @override
  Future<LoginResponse> startLogin(ServiceCall call, Empty request) async {
    print("startLogin service call headers ${call.headers} clientMetadata ${call.clientMetadata}");
    List<String> msg = ["msg0", "msg1"];
    int appId = 110;
    Int64 userId = Int64.parseInt("111");
    bool isVip = false;
    return LoginResponse()
      ..extras["msg"] = "welcome to login"
      ..msg.addAll(msg)
      ..appId = appId
      ..userId = userId
      ..isVip = isVip
      ..userName = "this is userName";
  }

  @override
  Stream<LoginResponse> startLoginAgain(ServiceCall call, Stream<LoginResponse> request) async* {
    yield LoginResponse()..extras["msg"] = "this is startLoginAgain response";
  }
}

Future<void> main(List<String> args) async {
  final server = new Server([new LoginService()]);
  await server.serve(port: 50051);
  print('Server listening on port ${server.port}...');
}
