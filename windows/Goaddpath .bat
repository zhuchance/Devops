@echo off
chcp 65001
title 一键设置GO环境变量脚本

REM 检查是否以管理员权限运行
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo 请以管理员权限运行此脚本！（鼠标右键-选择"以管理员身份运行"）
    pause
    exit /b
)

REM 手动输入JAVA_HOME路径
echo 第一步 输入要设置的GOROOT路径:(As example: D:\dev\env\go)
set /p input="请输入GOROOT路径："
echo.

REM 设置JAVA_HOME路径
echo 第二步 设置GOROOT路径
setx GOROOT "%input%" /M
echo.

REM 设置PATH
echo 第三步 设置PATH
setx path "%path%;%%GOROOT%%\bin" /M
echo.

REM 设置GOPATH
echo 第四步 设置GOPATH
setx GOPATH "%%GOROOT%%\gopath" /M
echo.

REM 设置goproxy
echo 第四步 设置goproxy
setx GOPROXY "https://goproxy.io,direct" /M
echo.

echo “执行完成”
pause

