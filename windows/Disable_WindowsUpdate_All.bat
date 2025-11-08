@echo off
title 禁用 Windows Update 全套服务
color 1f

@echo off
title ?? 禁用 Windows 10 自动更新（LTSC 适用）
echo ================================================
echo       Windows 10 自动更新彻底禁用脚本
echo ================================================
echo.

:: 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo 请以管理员身份运行此脚本！
    pause
    exit
)

echo [1/3] 停止并禁用更新相关服务...
sc stop wuauserv >nul 2>&1
sc config wuauserv start= disabled >nul 2>&1
sc stop UsoSvc >nul 2>&1
sc config UsoSvc start= disabled >nul 2>&1
sc stop DoSvc >nul 2>&1
sc config DoSvc start= disabled >nul 2>&1
sc stop WaaSMedicSvc >nul 2>&1
sc config WaaSMedicSvc start= disabled >nul 2>&1

echo [2/3] 禁用更新计划任务...
schtasks /Change /TN "Microsoft\Windows\WindowsUpdate\Automatic App Update" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\WindowsUpdate\Scheduled Start" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\WindowsUpdate\AUScheduledInstall" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\WindowsUpdate\sih" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\WindowsUpdate\sihboot" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\UpdateOrchestrator\Schedule Scan" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\UpdateOrchestrator\Schedule Scan Static Task" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\UpdateOrchestrator\USO_UxBroker_Display" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\UpdateOrchestrator\USO_UxBroker_ReadyToReboot" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\UpdateOrchestrator\Reboot" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\TaskScheduler\Maintenance Configurator" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\TaskScheduler\Regular Maintenance" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\TaskScheduler\Idle Maintenance" /Disable >nul 2>&1


:: 设置注册表锁死（Start = 4 表示禁用）
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wuauserv" /v Start /t REG_DWORD /d 4 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v Start /t REG_DWORD /d 4 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\UsoSvc" /v Start /t REG_DWORD /d 4 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DoSvc" /v Start /t REG_DWORD /d 4 /f >nul

echo.
echo ? 所有更新服务与任务已禁用。
echo ?? 若要恢复更新，请运行相反脚本或手动启用服务。
echo ? 已成功禁用所有 Windows 更新服务。
echo ?? 请重启电脑以确保设置生效。
echo [3/3] 检查状态...
sc query wuauserv | find "STATE"
echo.
pause
exit
