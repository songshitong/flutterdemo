#!/usr/bin/env bash
#使用方法

if [ ! -d ./IPADir ];
then
mkdir -p IPADir;
fi

#工程绝对路径  /Users/dongfang/Documents/isoftstone/gwadar-app/gwadarpro/ios
root_path=$(pwd)
project_path=$root_path/ios
echo "project_path $project_path"
script_path=$(cd `dirname $0`; pwd)
echo "script_path $script_path"
#工程名 将XXX替换成自己的工程名
project_name=Runner

#scheme名 将XXX替换成自己的sheme名
scheme_name=Runner

#打包模式 Debug/Release
development_mode=Debug

#build文件夹路径
build_path=${project_path}/build

#plist文件所在路径
exportOptionsPlistPath=exportTest.plist


tip1="输入构建渠道 [ 1:dev 2:sit 3:preRelease 4:uat 5:release ] "
echo "$tip1"

##
read flavorNumber
while [[ ${flavorNumber} != 1 ]] && [[ ${flavorNumber} != 2 ]] && [[ ${flavorNumber} != 3 ]]&& [[ ${flavorNumber} != 4 ]]&& [[ ${flavorNumber} != 5 ]]
do
echo "$tip1"
read flavorNumber
done
tip2="输入构建后行为 [ 1:none 2:安装到设备 3:上传到蒲公英 ]"
echo "$tip2"
read afterBuildNumber
while [[ ${afterBuildNumber} != 1 ]] && [[ ${afterBuildNumber} != 2 ]] && [[ ${afterBuildNumber} != 3 ]]
do
echo "$tip2"
read afterBuildNumber
done

target=""
flavor="dev"
if [[ ${flavorNumber} == 1 ]];then
 target="main.dart"
 flavor="dev"
elif [[ ${flavorNumber} == 2 ]];then
 target="main_sit.dart"
 flavor="sit"
elif [[ ${flavorNumber} == 3 ]];then
 target="main_pre_release.dart"
 flavor="preRelease"
elif [[ ${flavorNumber} == 4 ]];then
 target="main_uat.dart"
 flavor="uat"
elif [[ ${flavorNumber} == 5 ]];then
 target="main_release.dart"
 flavor="master"
else
   target="main.dart"
   flavor="dev"
fi

  exportOptionsPlistPath=${script_path}/exportDev.plist
if [[ ${flavorNumber} == 1 ]];then
  development_mode=Release-dev
  scheme_name=dev
elif [[ ${flavorNumber} == 2 ]];then
  development_mode=Release-sit
  scheme_name=sit
elif [[ ${flavorNumber} == 3 ]];then
    development_mode=Release-preRelease
    scheme_name=preRelease
elif [[ ${flavorNumber} == 4 ]];then
    development_mode=Release-uat
    scheme_name=uat
elif [[ ${flavorNumber} == 5 ]];then
    development_mode=Release-master
    scheme_name=master
else
  development_mode=Release
fi

#导出.ipa文件所在路径
exportIpaPath=${project_path}/IPADir/${development_mode}

echo '///-----------'
echo '/// 正在清理工程'
echo '///-----------'

#xcodebuild \
#clean -configuration ${development_mode} -quiet  || exit
flutter clean || exit


echo '///--------'
echo '/// 清理完成'
echo '///--------'
echo ''

echo '///--------'
echo '/// 执行flutter编译'
echo '///--------'
echo ''
flutter build ios -t lib/${target} --flavor ${flavor}   || exit
echo '///--------'
echo '/// flutter编译完成'
echo '///--------'
echo ''


cd "$project_path" || exit
path=`pwd`
echo "现在目录是 $path"
echo '///-----------'
echo '/// 正在编译工程:'${development_mode}
echo '///-----------'
xcodebuild \
archive -workspace ${project_path}/${project_name}.xcworkspace \
-scheme ${scheme_name} \
-configuration ${development_mode} \
-archivePath ${build_path}/${project_name}.xcarchive  -quiet  || exit

echo '///--------'
echo '/// 编译完成'
echo '///--------'
echo ''

echo '///----------'
echo '/// 开始ipa打包'
echo '///----------'
xcodebuild -exportArchive -archivePath ${build_path}/${project_name}.xcarchive \
-configuration ${development_mode} \
-exportPath ${exportIpaPath} \
-exportOptionsPlist ${exportOptionsPlistPath} \
-verbose \
-quiet || exit

if [ -e $exportIpaPath/$scheme_name.ipa ]; then
echo '///----------'
echo '/// ipa包已导出'
echo '///----------'
open $exportIpaPath
else
echo '///-------------'
echo '/// ipa包导出失败 '
echo '///-------------'
fi
echo '///------------'
echo '/// 打包ipa完成  '
echo '///-----------='
echo ''

echo '///-------------'
echo '/// 开始发布ipa包 '
echo '///-------------'

#if [ $number == 1 ];then

#验证并上传到App Store
# 将-u 后面的XXX替换成自己的AppleID的账号，-p后面的XXX替换成自己的密码
#altoolPath="/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool"
#"$altoolPath" --validate-app -f ${exportIpaPath}/${scheme_name}.ipa -u XXX -p XXX -t ios --output-format xml
#"$altoolPath" --upload-app -f ${exportIpaPath}/${scheme_name}.ipa -u  XXX -p XXX -t ios --output-format xml
#else

#上传到Fir
# 将XXX替换成自己的Fir平台的token
#fir login -T XXX
#fir publish $exportIpaPath/$scheme_name.ipa

iosPublicPath="$exportIpaPath/$scheme_name.ipa"
if [[ ${afterBuildNumber} == 1 ]];then
 exit 0
elif [[ ${afterBuildNumber} == 2 ]];then
  echo "开始执行安装======================"
  ideviceinstaller -i ${iosPublicPath}
else
#上传蒲公英
desc=`cat $root_path/script/android/build_android_release_upload_pgyer_desc.txt`
if [ ! $desc ]; then
  echo "请输入描述"
  exit 1
fi
echo "开始上传"

echo "iosPublicPath $iosPublicPath"
curl  -F "file=@$iosPublicPath" -F '_api_key=4562f1bfe6e62fd5424114f069033e42' -F "buildUpdateDescription=$desc" -# --progress-bar   --verbose -o Runner.ipa https://www.pgyer.com/apiv2/app/upload

fi

exit 0
