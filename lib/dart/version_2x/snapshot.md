1、什么是Snapshot？

快照是一个字节序列，表示一个或多个Dart对象的序列化形式。它和Dart对象在Isolate堆区（heap）中的内存形式密切对应。

Dart VM使用快照的两个主要原因：

提升应用的初始启动速度。内置库和应用脚本的快照通常包括：内置库预解析的数据，以及应用脚本。这意味着在启动期间，它不需要解析和标记库和脚本。
将对象（消息）从一个Isolate传递到另一个Isolate。
Dart VM使用一下类型的快照：

完整快照（full snapshot）。它完整地表示了一个Isolate初始化之后的堆区（heap），用于Dart VM快速启动和初始化全部核心库以及其它内置库，如dart:convert，dart:io，dart:isolate等等。
脚本快照（script snapshot）。它是一个应用脚本加载进Isolate之后，开始执行之前，在Isolate堆区中的完整表示。它用于Dart VM快速启动和初始化应用。例如启动dart2js的脚本，它使用了dart2js应用的预创建脚本快照。
对象快照（object snapshot）。在Dart VM中，通过创建一个需要发送的Dart对象（消息）的快照，实现Isolate之间的消息传递。
2、生成和使用脚本快照

你可以使用Dart VM（dart）生成和使用快照。

注意：对于仅运行几次的程序，不用费心思去创建一个脚本快照。脚本快照仅用于部署应用的时候，创建快照以分摊多个启动项的成本。

生成脚本快照时，使用dart和–snapshot选项。并且可以使用–package_root选项来指定引用的包（import ‘package:…’）的位置。

dart [--package_root=<path>] --snapshot=<output_file> <dart_file>
–snapshot选项将编写一个dart-script-file的脚本快照到out-file。例如下面的命令，将创建一个Dart脚本dart2js.dart的快照，并放入dart2js.snapshot文件。

dart --snapshot=dart2js.snapshot \
dart-sdk/lib/dart2js/lib/_internal/compiler/implementation/dart2js.dart
从快照执行脚本时，在命令行中指定快照文件：

dart <snapshot_file> <args>
你指定的所有参数将传递给脚本。例如，你可以运行dart2js，并将myscript.dart -oout.js作为命令行参数传递给dart2js：

dart dart2js.snapshot myscript.dart -oout.js