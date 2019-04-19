import 'package:build/build.dart';
import 'package:flutterdemo/dart/version_2x/script/todo_generate.dart';
import 'package:source_gen/source_gen.dart';

Builder todoBuilder(BuilderOptions options) =>
    LibraryBuilder(TodoTopGenerate(), generatedExtension: '.todo_generate.dart');
PostProcessBuilder a;
