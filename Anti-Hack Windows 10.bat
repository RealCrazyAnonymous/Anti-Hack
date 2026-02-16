@echo off
echo ============================
echo Windows 10 Security Hardening
echo ============================

:: Ensure script runs as administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Please run this script as Administrator.
    pause
    exit
)

:: Enable Windows Defender Real-Time Protection
echo Enabling Windows Defender Real-Time Protection...
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $false"

:: Enable Windows Firewall
echo Enabling Windows Firewall...
netsh advfirewall set allprofiles state on

:: Block incoming connections for all profiles
echo Configuring Firewall to block incoming connections...
netsh advfirewall set allprofiles firewallpolicy blockinbound,allowoutbound

:: Disable SMBv1 (if not needed)
echo Disabling SMBv1...
sc.exe config lanmanserver start= disabled
sc.exe stop lanmanserver

:: Disable unnecessary services
echo Disabling unnecessary services...
sc.exe config "Remote Registry" start=disabled
sc.exe stop "Remote Registry"

sc.exe config "Server" start=disabled
sc.exe stop "Server"

sc.exe config "SSDP Discovery" start=disabled
sc.exe stop "SSDP Discovery"

sc.exe config "UPnP Device Host" start=disabled
sc.exe stop "UPnP Device Host"

:: Disable Windows PowerShell Script Execution (for security)
echo Restricting PowerShell script execution...
powershell -Command "Set-ExecutionPolicy Restricted -Force"

:: Disable Windows AutoRun
echo Disabling AutoRun...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDriveAutoRun /t REG_DWORD /d 1 /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDriveAutoRun /t REG_DWORD /d 1 /f

:: Enable User Account Control (UAC)
echo Enabling UAC...
reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 1 /f

:: Set User Account Control prompt behavior
reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 2 /f

:: Disable Guest account
echo Disabling Guest account...
net user Guest /active:no

:: Promote a standard user to administrator (if needed)
:: net localgroup Administrators [username] /add

echo ============================
echo Security configurations applied.
echo Please reboot your system for all changes to take effect.
pause
