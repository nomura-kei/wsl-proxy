@echo off
rem プロキシサーバーを起動します。
cd %~dp0

setlocal enabledelayedexpansion

rem WSL 上ファイルパス設定
set "WIN_BASE_PATH=%~dp0"
set "WIN_BASE_PATH=!WIN_BASE_PATH:~0,-1!"
for /F "usebackq delims=" %%p in (`wsl -d AlpineProxy wslpath -a -u "!WIN_BASE_PATH!"`) do set "WIN_BASE_PATH=%%p"

rem start.sh を実行
wsl -d AlpineProxy -u root --exec /bin/cp -f "!WIN_BASE_PATH!/scripts/install.sh" /tmp/
wsl -d AlpineProxy -u root --exec /bin/sh /tmp/install.sh "!WIN_BASE_PATH!"

endlocal
