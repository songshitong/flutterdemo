import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:flutterdemo/dart/version_2x/metadata/meta_data.dart';
import 'package:source_gen/source_gen.dart';

//咸鱼https://juejin.im/entry/5c137afdf265da612e28868a
//dart提供了build、analyser、source_gen这三个库，其中source_gen利用build库和analyser库，给到了一层比较好的注解拦截的封装。从注解功能的角度来看，这三个库分别给到了如下的功能：
//build库：整套资源文件的处理
//analyser库：对dart文件生成完备的语法结构
//source_gen库：提供注解元素的拦截

//annotation_route  todo 模版引擎技术  mustache4dart

//使用：pub官网 https://pub.dartlang.org/packages/source_gen

//1 继承generator

//2 建立builder   SharedPartBuilder/PartBuilder/LibraryBuilder

//3 配置build.yaml  https://pub.dartlang.org/packages/build_config

//根据注解生成代码
class TodoGenerate extends GeneratorForAnnotation<Todo> {
  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    return '// Code for "${element.name}"';
  }
}
