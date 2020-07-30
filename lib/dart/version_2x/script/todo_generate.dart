import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:flutterdemo/dart/version_2x/metadata/meta_data.dart';
import 'package:path/path.dart' as p;
import 'package:source_gen/source_gen.dart';
import 'package:source_gen/src/output_helpers.dart';
//source_gen 擅长生成文件，不擅长在源文件中修改

//咸鱼https://juejin.im/entry/5c137afdf265da612e28868a
//dart提供了build、analyser、source_gen这三个库，其中source_gen利用build库和analyser库，给到了一层比较好的注解拦截的封装。从注解功能的角度来看，这三个库分别给到了如下的功能：
//build库：整套资源文件的处理
//analyser库：对dart文件生成完备的语法结构
//source_gen库：提供注解元素的拦截

//annotation_route  todo 模版引擎技术  mustache4dart

//使用：pub官网 https://pub.dartlang.org/packages/source_gen

//1 继承generator（访问每个元素）  或GeneratorForAnnotation（访问有注解的元素）

//2 建立builder   SharedPartBuilder（编写部分代码，part”允许您将库拆分为多个Dart文件。这将生成扩展名为.g.dart的文件）
//    /PartBuilder（如果您仍想使用部件方法，则可以使用PartBuilder，但可以控制扩展文件，例如.my_file.dart）/LibraryBuilder（生成可导入的独立库）

//3 配置build.yaml  https://pub.dartlang.org/packages/build_config
//build.yaml中 builder可以分为多个targets
// targets可以分为三部分sources/dependencies/builders

//builders配置
//0 keys  配置build key   包名|builder类名
//1 enabled   是否应用builder到该target
//2 generate_for  目标源中应该应用此Builder的文件子集 可以配置包含和排除  include 默认**    exclude:['**.java']
//3 options    在builder构造实例时作为BuilderOptions传入  用法因具体构建器而异。此映射中的值将覆盖构建器作者提供的缺省值。
//             也可以使用dev_options或release_options基于构建模式覆盖值。

//4 dev_options  一个自由格式的映射，它将在构造时作为BuilderOptions传递给Builder  在dev模式下起作用
//5 release_options 跟4一样在release模式下起作用

//可以使用global_options部分在所有包中全局覆盖目标级别构建器选项
// 同样可以配置options/generate_for/options

//构建Builders依赖   在build.yaml中配置为builders部分
//1 import 必选 用于导入包含Builder类库的uri  package:包名/builder文件相对路径
//2 builder_factories  包含导入库中的顶级方法的名称，这些方法是适合typedef Builder factoryName的函数（BuilderOptions选项）
//      数据为数组['']格式List<String>
//3 build_extensions 必选  从输入扩展名到可为该输入创建的输出扩展名列表的映射。
//          这必须与builder_factories中每个Builder的合并buildExtensions映射相匹配
//4 auto_apply  自动使用builder的包的范围 默认为none
//none
//dependents    dependents将此Builder应用于直接依赖于公开构建器包的包
//all_packages  将此Builder应用于传递依赖关系图中的所有包
//root_package  仅将此Builder应用于顶级包

//5 required_inputs  扩展名列表，默认为空列表  如果Builder必须看到每个带有一个或多个文件扩展名的输入，则可以在此处指定它们，
//     并保证在任何可能产生该类型输出的Builder之后运行

//6 runs_before  Builder keys列表   keys为target的build中声明的keys
//7 applies_builders Builder keys列表    指定应在将运行此Builder的任何目标上运行其他构建器
//8 is_optional  bool  指定是否可以延迟运行构建器，以便在稍后的构建器请求其中一个输出之前它不会执行。这个选项应该很少见。默认为False。

//9 build_to  生成asset的应输出位置
//source  输出将转到其主要输入旁边的源树
// cache  默认为cache 输出转到隐藏的构建缓存，不会发布。

//10 defaults  当用户未在其构建builders部分中指定相应的键时应用的默认值。可能包含以下键
//generate_for
//options
//dev_options release_options

//PostProcessBuilder   在构建结束时运行的builder
// 与普通builder的区别
// 它们不必声明输出扩展，并可以输出任何文件但它与现有的不冲突
// 他们只能读他们的主要输入
// 它们不会产生可选的操作 - 它们只会在作为正常构建的一部分assets上运行
// 它们都在一个阶段运行，因此无法看到其他[PostProcessBuilder]任何输出
// 因为他们在一个单独的阶段，在其他builder之后，他们输出不可以由[Builder]使用

// 永远不应该使用这些构建器来输出Dart文件或任何其他应该由普通[Builder]处理的文件

//build_runner  该工具允许我们在开发阶段运行我们的generator  flutter pub run build_runner build
//pub run build_runner <command>
//
//build: 运行单个构建并退出 --release/-r 运行在release模式  -h 帮助命令
//watch: 运行一个守护程序，该守护程序将在文件更改时运行并在必要时进行重建
//serve: 类似于watch，但也作为开发server运行
//test: 用于测试
//--delete-conflicting-outputs  删除冲突

//根据注解生成代码  识别类注解,顶层函数注解，顶层变量，不能识别类内函数
class TodoTopGenerate extends GeneratorForAnnotation<Todo> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    print("TodoGenerate start work ==============================");
    var soure = "";
    if (element is ClassElement) {
      soure = element.source.contents.data;
      print('''
        soure $soure
        enclosingElement ${element.enclosingElement}
        name ${element.name}
        kind ${element.kind}
        metadata ${element.metadata}
      ''');
      print('''buildStep
      path ${buildStep.inputId.path}
      extension ${buildStep.inputId.extension}
      package ${buildStep.inputId.package}
      uri ${buildStep.inputId.uri}
      pathSegments ${buildStep.inputId.pathSegments}
      ''');

      ///获取该类的属性
      var visitor = ModelVisitor();
      element.visitChildren(visitor);
      print(
          "visitor ${visitor.className} \n ${visitor.fields} \n ${visitor.metaData}");
      var objectValue = annotation.objectValue;
      var what = annotation.read("what");
      var who = annotation.read("who");
      soure = soure.replaceFirst("class ${visitor.className} {", '''
      // Code for ${element.name} ${element.runtimeType} who: ${who.stringValue} what: ${what.stringValue} 
      class ${visitor.className} {
      ''');
      return ' //source: \n $soure';
    } else {
      return "";
    }
  }
}

class ModelVisitor extends SimpleElementVisitor {
  DartType className;
  Map<String, DartType> fields = {};
  Map<String, dynamic> metaData = {};

  @override
  visitConstructorElement(ConstructorElement element) {
    className = element.type.returnType;
  }

  @override
  visitFieldElement(FieldElement element) {
    fields[element.name] = element.type;
    metaData[element.name] = element.metadata;
  }
}

//查找类内方法的注解
class TodoMethodGenerate extends MethodGenerate<Todo> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    final sourcePathDir = p.dirname(buildStep.inputId.path);
    print("sourcePathDir $sourcePathDir");
    final fileId = AssetId(
        buildStep.inputId.package, p.join(sourcePathDir, "meta_data.dart"));
    print("fileId $fileId");
    final content = await buildStep.readAsString(fileId);
    print("contecnt $content");
    return null;
  }
}

abstract class MethodGenerate<T> extends Generator {
  @override
  FutureOr<String> generate(LibraryReader libra, BuildStep buildStep) async {
    var values = Set<String>();
    TypeChecker tc = TypeChecker.fromRuntime(T);
    for (var value in libra.allElements) {
      //拿到类型为类的
//      print("classElement ${value.runtimeType}");
//      print("${value is ClassElement}");
      //ClassElement 实现了element的方法
      if (value is ClassElement) {
        ClassElement classElement = value;
        //value.displayName 是代码中展示的名字
//        print("classElement ${classElement.displayName}");
        for (var annotatedElement in classAnnotated(classElement, tc)) {
          var generatedValue = generateForAnnotatedElement(
              annotatedElement.element, annotatedElement.annotation, buildStep);
          await for (var value in normalizeGeneratorOutput(generatedValue)) {
            assert(value == null || (value.length == value.trim().length));
            values.add(value);
          }
        }
      }
    }
    return values.join('\n\n');
  }

  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep);
}

Iterable<AnnotatedElement> classAnnotated(
    ClassElement classElement, TypeChecker checker,
    {bool throwOnUnresolved}) sync* {
  //拿到类所有方法
  for (var value1 in classElement.methods) {
    final annotation = checker.firstAnnotationOf(value1);
//          print("annotation $annotation");
    if (annotation != null) {
      print("value1 method ${value1.displayName} annotation $annotation");
      yield AnnotatedElement(ConstantReader(annotation), value1);
    }
  }
}
