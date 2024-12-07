***## window安装完成后需要设置

1. 激活
``` bash
irm https://get.activated.win | iex
```
1. Windows11 恢复完整右键经典菜单
```bash
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f
taskkill /F /IM explorer.exe
explorer.exe
```
