import 'package:flutterdemo/flutter/packages/grpc/generated/login.pbgrpc.dart';
import 'package:grpc/grpc.dart';

Future<void> main() async {
  const ChannelCredentials credentials = const ChannelCredentials.insecure();
  final channel = new ClientChannel('localhost', port: 50051, options: const ChannelOptions(credentials: credentials));
  final stub = new LoginClient(channel);
  try {
    final LoginResponse response = await stub.startLogin(Empty(),
        options:
            CallOptions(metadata: {"metadata": "this is MetaData"}, providers: <MetadataProvider>[(metadata, uri) {}]));
    print('Greeter client received: ${response}');
  } catch (e) {
    print('Caught error: $e');
  }
  final response1 = stub.startLoginAgain(Stream.empty());
  response1.listen((loginResponse) async {
    print("startLoginAgain $loginResponse");
    await channel.shutdown();
  });
}
