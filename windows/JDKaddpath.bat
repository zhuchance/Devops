@echo off
chcp 65001
title 一键设置Java 8/Java11环境变量脚本

REM 检查是否以管理员权限运行
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo 请以管理员权限运行此脚本！（鼠标右键-选择"以管理员身份运行"）
    pause
    exit /b
)

REM 手动输入JAVA_HOME路径
echo 第一步 输入要设置的JAVA_HOME路径:(As example: D:\dev\env\java\jdk-21.0.5+11)
set /p input="请输入JAVA_HOME路径："
echo.

REM 设置JAVA_HOME路径
echo 第二步 设置JAVA_HOME路径
setx JAVA_HOME "%input%" /M
echo.

REM 设置PATH
echo 第三步 设置PATH
setx path "%path%;%%JAVA_HOME%%\bin" /M
echo.

REM 设置classpath
echo 第四步 设置classpath
setx classpath .;%%JAVA_HOME%%\lib\dt.jar;%%JAVA_HOME%%\lib\tools.jar /M
echo.

echo “执行完成”
pause

