@echo off
echo Starting full security setup...

:: Check for administrator privileges
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Please run this script as an administrator.
    pause
    exit
)

:: Enable Windows Defender and update definitions
echo Enabling Windows Defender...
sc config WinDefend start= auto
sc start WinDefend
echo Updating Windows Defender definitions...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate

:: Enable Windows Firewall
echo Enabling Windows Firewall...
netsh advfirewall set allprofiles state on

:: Disable Remote Desktop if not needed
echo Disabling Remote Desktop...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v "fDenyTSConnections" /t REG_DWORD /d 1 /f

:: Disable SMBv1 (security risk)
echo Disabling SMBv1...
sc config lanmanserver start= disabled
sc config browser start= disabled

:: Disable unnecessary services (examples)
echo Disabling unnecessary services...
sc config "RemoteRegistry" start= disabled
sc config "SSDPDiscovery" start= disabled
sc config "UPnPDeviceHost" start= disabled
sc config "WSearch" start= manual
sc config "Spooler" start= disabled

:: Disable SMBv2/3 if not used (not recommended generally, but shown here)
:: Note: This can affect network sharing
:: reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "SMB2" /t REG_DWORD /d 0 /f

:: Enable User Account Control (UAC)
echo Ensuring UAC is enabled...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 1 /f

:: Set Windows Update to install automatically
echo Configuring Windows Update to automatic...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d 4 /f

:: Enable Windows Defender real-time protection
echo Enabling real-time protection...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 0 /f

:: Disable Windows Remote Assistance
echo Disabling Remote Assistance...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d 0 /f

:: Disable autorun
echo Disabling autorun...
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveAutoRun" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveAutoRun" /t REG_DWORD /d 1 /f

echo Full security setup completed.
pause
