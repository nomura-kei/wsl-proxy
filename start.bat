@echo off

cd %~dp0

setlocal

rem WSL 上ファイルパス設定
set "WIN_CONF_PATH=%~dp0conf"
for /F "usebackq delims=" %%p in (`wsl -d AlpineProxy wslpath -a -u "%WIN_CONF_PATH%"`) do set "WIN_CONF_PATH=%%p"

wsl -d AlpineProxy -u root --exec /bin/mkdir -p /etc/squid/conf.d
wsl -d AlpineProxy -u root --exec /bin/cp "%WIN_CONF_PATH%/proxy.conf" /etc/squid/conf.d/

wsl --terminate AlpineProxy
wsl -d AlpineProxy -u root --exec /sbin/openrc default

endlocal
