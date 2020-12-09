///flutter 1.20.2
///链接https://www.jianshu.com/p/4e8ccb02e92d
///https://juejin.im/post/6844903928417484814#heading-9

在pubspec点击pub get可看到flutter路径,同时在环境变量中也可看到 echo $path|grep "flutter"
/Users/issmac/Library/Android/flutter/bin/flutter --no-color pub get

flutter.sh
执行 flutter/bin/internal/shared.sh   execute方法

shared.sh upgrade_flutter  升级flutter
STAMP_PATH="$FLUTTER_ROOT/bin/cache/flutter_tools.stamp" flutter tool构建的revision，删除后执行flutter build tool
SNAPSHOT_PATH="$FLUTTER_ROOT/bin/cache/flutter_tools.snapshot"  flutter tool构建生成的snapshot
升级标准
# Invalidate cache if:
  #  * SNAPSHOT_PATH is not a file, or
  #  * STAMP_PATH is not a file with nonzero size, or
  #  * Contents of STAMP_PATH is not our local git HEAD revision, or
  #  * pubspec.yaml last modified after pubspec.lock

shared.sh execute
最终执行dart
类似于 java -c a.jar
"$DART" --disable-dart-dev --packages="$FLUTTER_TOOLS_DIR/.packages" $FLUTTER_TOOL_ARGS "$SNAPSHOT_PATH" "$@"
DART /bin/cache/dart-sdk/bin/dart
FLUTTER_TOOL  flutter/packages/flutter_tools
SNAPSHOT_PATH flutter/bin/cache/flutter_tools.snapshot



flutter_tools.dart
flutter_tools main方法 执行executable的main

executable.dart main方法 实际命令的解析
await runner.run(args, () => <FlutterCommand>[
    BuildCommand(verboseHelp: verboseHelp),
  ]);


BuildCommand 负责执行不同平台命令
BuildCommand({bool verboseHelp = false}) {
    ///构建Android apk命令
    addSubcommand(BuildApkCommand(verboseHelp: verboseHelp));
    ///构建ios
    addSubcommand(BuildIOSCommand());
  }
addSubcommand 中定义的命令就是-h输出的语法
Flutter build commands.

Usage: flutter build <subcommand> [arguments]
-h, --help    Print this usage information.

Available subcommands:
  aot      Build an ahead-of-time compiled snapshot of your app's Dart code.
  apk      Build an Android APK file from your app.
  bundle   Build the Flutter assets directory from your app.
  flx      Deprecated
  ios      Build an iOS application bundle (Mac OS X host only).


  BuildCommand继承了FlutterCommand，而外部调用BuildCommand的时候，执行的是这个父类FlutterCommand的run方法

  run主要调用了verifyThenRunCommand方法
  verifyThenRunCommand{
    //1 执行pub get 获取相应依赖
    await pub.get();
    //2 准备特定平台的编译环境
    await project.ensureReadyForPlatformSpecificTooling();
    //3 供子类的实现的真正运行方法
    return await runCommand();
  }


  ///不同平台的准备实现
  Future<void> ensureReadyForPlatformSpecificTooling({bool checkProjects = false}) async {
      if ((android.existsSync() && checkProjects) || !checkProjects) {
        ///调用 gradle.updateLocalProperties用于更新flutter.versionName和flutter.versionCode
        await android.ensureReadyForPlatformSpecificTooling();
      }
      if ((ios.existsSync() && checkProjects) || !checkProjects) {
        await ios.ensureReadyForPlatformSpecificTooling();
      }
  }

  BuildApkCommand 的runCommand实现
  runCommand{
   await androidBuilder.buildApk(
         project: FlutterProject.current(),
         target: targetFile,
         androidBuildInfo: androidBuildInfo,
       );
  }

  buildApk 调用buildGradleApp
  最终执行命令 Mac
  android/gradlew -q -Ptarget=lib/main.dart -Ptrack-widget-creation=false -Ptarget-platform=android-arm assembleRelease

  gradlew执行app/build.gradle时
  1.读取local.properties的flutter.sdk、flutter.versionCode和flutter.versionName
  2.调用flutter/packages/flutter_tools/gradle/flutter.gradle

  flutter.gradle
  FlutterPlugin集成Plugin
  void apply(Project project) {
    ///添加task和相应的依赖
    project.afterEvaluate this.&addFlutterTasks
  }

  1. processXXXResources这个Task会依赖于copyFlutterAssetsTask，这就会使得快执行到processXXXResources的时候必须先执行完copyFlutterAssetsTask才能继续。
    就这样，flutter的相关处理就嵌入到gradle的编译流程中了
  2. copyFlutterAssetsTask依赖了flutterTask和mergeXXXAssets。也就是说，当flutterTask使得flutter编译完成，并且mergeXXXAssets执行完毕，
    也就是正常Android的assets处理完成后，flutter相应的产物就会被copyFlutterAssetsTask复制到build/app/intermediates/merged_assets/debug/mergeXXXAssets/out目录下。
    这里的XXX指代各种build variant，也就是Debug或者Release

  addFlutterTasks{
         Task copyFlutterAssetsTask = project.tasks.create(
                         name: "copyFlutterAssets${variant.name.capitalize()}",
                         type: Copy,
                     ) {
                         dependsOn compileTask
                         with compileTask.assets
                         if (isUsedAsSubproject) {
                             dependsOn packageAssets
                             dependsOn cleanPackageAssets
                             into packageAssets.outputDir
                             return
                         }
                         // `variant.mergeAssets` will be removed at the end of 2019.
                         def mergeAssets = variant.hasProperty("mergeAssetsProvider") ?
                             variant.mergeAssetsProvider.get() : variant.mergeAssets
                         dependsOn mergeAssets
                         dependsOn "clean${mergeAssets.name.capitalize()}"
                         mergeAssets.mustRunAfter("clean${mergeAssets.name.capitalize()}")
                         into mergeAssets.outputDir
                     }
         if (!isUsedAsSubproject) {
                def variantOutput = variant.outputs.first()
                def processResources = variantOutput.hasProperty("processResourcesProvider") ?
                    variantOutput.processResourcesProvider.get() : variantOutput.processResources
                processResources.dependsOn(copyFlutterAssetsTask)
                return
            }
  }

  FlutterTask
  flutter的编译产物，具体是由flutterTask的getAssets方法指定的：
  CopySpec getAssets() {
          return project.copySpec {
              from "${intermediateDir}"
              include "flutter_assets/**" // the working dir and its files
          }
      }
  具体的FlutterTask核心只有一句话{
      void build() {
             buildBundle()
         }
  }

  buildBundle结合 FlutterTask compileTask = project.tasks.create(name: taskName, type: FlutterTask)
  //组装和构建flutter资源
  flutter assemble --depfile "${intermediateDir}/flutter_build.d" --output  intermediateDir -dTargetPlatform=android args -dBuildMode=${buildMode}

  flutter run
  assemble --depfile build/app/intermediates/flutter/devDebug/flutter_build.d --output build/app/intermediates/flutter/devDebug -dTargetFile=lib/main.dart -dTargetPlatform=android -dBuildMode=debug -dTrackWidgetCreation=true debug_android_application

  flutter build apk -t lib/main.dart --release --flavor dev --target-platform=android-arm
  assemble, --depfile /build/app/intermediates/flutter/devRelease/flutter_build.d --output build/app/intermediates/flutter/devRelease -dTargetFile=lib/main.dart -dTargetPlatform=android -dBuildMode=release -dTrackWidgetCreation=true -dTreeShakeIcons=true android_aot_bundle_release_android-arm
