
# oclint
workspaceExt=".xcworkspace"
tempPath=""
project_path=$(pwd)
project_name=$(ls | grep xcodeproj | awk -F.xcodeproj '{print $1}')

#find .xcworkspace
for workspacePath in `find ${project_path} -name "$project_name$workspaceExt" -print`
do
tempPath=${workspacePath}
break
done
echo "===========oclint=========="
if [ "$tempPath" == "" ];then
#oclint clean
xctool  -project ${project_name}.xcodeproj \
        -scheme ${project_name} \
        -reporter json-compilation-database:compile_commands.json \
        clean
echo "===========oclint=clean=done========="
#build
xctool  -project ${project_name}.xcodeproj \
        -scheme ${project_name} \
        -reporter json-compilation-database:compile_commands.json \
        build
echo "===========oclint=build=done========="
else
#oclint clean
xctool  -workspace ${project_name}.xcworkspace \
        -scheme ${project_name} \
        -reporter json-compilation-database:compile_commands.json \
        clean
echo "===========oclint=clean=done========="
#build
xctool  -workspace ${project_name}.xcworkspace \
        -scheme ${project_name} \
        -reporter json-compilation-database:compile_commands.json \
        build
echo "===========oclint=build=done========="
fi

#生成报表
oclint-json-compilation-database -v oclint_args "-report-type html -o oclintReport.html -rc=LONG_LINE=120"
#简单生成 文件
#oclint-json-compilation-database -- -o=oclintReport.html
#生成报表
#oclint-json-compilation-database -v -- -report-type html -o oclintReport.html
#删除 compile_commands.json 可能会很大
jsonPath=$project_path/"compile_commands.json"
#echo ${jsonPath}
rm $jsonPath
open oclintReport.html
exit





