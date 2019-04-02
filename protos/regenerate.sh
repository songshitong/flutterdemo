#!/usr/bin/env bash
#protobuf的安装路径
PROTOBUF="/Users/issmac/grpc/protobuf-3.7.1"
#GoogleAPI 定义为自己的proto文件
GOOGLEAPIS="/Users/issmac/FlutterWorkspace/flutterdemo/protos"
#编译后的文件路径
OUTPUTPATH="/Users/issmac/FlutterWorkspace/flutterdemo/lib/flutter/packages/grpc/generated"
if [ ! -d "$PROTOBUF" ]; then
  echo "Please set the PROTOBUF environment variable to your clone of google/protobuf."
  exit -1
fi
if [ ! -d "$GOOGLEAPIS" ]; then
  echo "Please set the GOOGLEAPIS environment variable to your clone of GOOGLEAPIS."
  exit -1
fi

if [ ! -d "$OUTPUTPATH" ]; then
  echo "Please set the OUTPUTPATH environment variable to your clone of OUTPUTPATH"
  exit -1
fi

PROTOC="protoc --dart_out=grpc:$OUTPUTPATH -I$PROTOBUF/src -I$GOOGLEAPIS"

$PROTOC $GOOGLEAPIS/login.proto

$PROTOC $PROTOBUF/src/google/protobuf/any.proto
$PROTOC $PROTOBUF/src/google/protobuf/duration.proto
$PROTOC $PROTOBUF/src/google/protobuf/empty.proto
$PROTOC $PROTOBUF/src/google/protobuf/struct.proto
$PROTOC $PROTOBUF/src/google/protobuf/timestamp.proto

dartfmt -w $OUTPUTPATH
