@echo off
title Anti-Hack Security Hardener for Windows 11 Pro - Made by Crazy Anonymous
color 0A
echo ======================================================================
echo   Anti-Hack Batch Script for Windows 11 Pro - Made by Crazy Anonymous
echo ======================================================================
echo.

:: Check if running as Administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: This script must be run as Administrator!
    echo Right-click the file and select "Run as administrator".
    pause
    exit /b 1
)

:: Check OS Version (Windows 11 Pro only - build 22000+)
echo Checking OS version...
for /f "tokens=*" %%i in ('systeminfo ^| findstr /B /C:"OS Name"') do (
    set OS_NAME=%%i
)
echo %OS_NAME% | findstr /C:"Microsoft Windows 11 Pro" >nul
if %errorLevel% neq 0 (
    echo ERROR: This script is designed ONLY for Windows 11 Pro.
    echo Detected: %OS_NAME%
    pause
    exit /b 1
)

:: Extract build number for confirmation (Windows 11 is 10.0.22000+)
for /f "tokens=2 delims= " %%a in ('ver') do set WIN_VER=%%a
echo Windows Version: %WIN_VER%
if not "%WIN_VER:~0,8%"=="10.0.220" (
    echo WARNING: Build number suggests this may not be Windows 11. Proceeding with caution.
)

:: Log file
set LOGFILE=C:\AntiHackLog.txt
echo Anti-Hack Script Run on %date% %time% > %LOGFILE%
echo OS: %OS_NAME% >> %LOGFILE%

echo.
echo [1/6] Enabling Windows Defender Real-Time Protection...
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $false" >> %LOGFILE% 2>&1
powershell -Command "Set-MpPreference -MAPSReporting Advanced" >> %LOGFILE% 2>&1
powershell -Command "Set-MpPreference -SubmitSamplesConsent SendSafeSamples" >> %LOGFILE% 2>&1
echo   - Real-time protection: ENABLED
echo   - Cloud protection: ENABLED
echo   Log: %LOGFILE%

echo.
echo [2/6] Running Quick Scan with Windows Defender...
echo Scanning for threats... This may take a few minutes.
MpCmdRun -Scan -ScanType 1 >> %LOGFILE% 2>&1
if %errorLevel% equ 0 (
    echo   - Scan completed successfully. Check %LOGFILE% for details.
) else (
    echo   - Scan finished with warnings. Review %LOGFILE%.
)

echo.
echo [3/6] Disabling Common Exploit Services (RDP and Telnet)...
:: Disable Remote Desktop (if enabled) - Pro supports RDP, so secure it
sc config TermService start= disabled >> %LOGFILE% 2>&1
sc stop TermService >> %LOGFILE% 2>&1
echo   - Remote Desktop: DISABLED (Re-enable via System Settings if needed)

:: Disable Telnet (if installed)
sc config TlntSvr start= disabled >> %LOGFILE% 2>&1
sc stop TlntSvr >> %LOGFILE% 2>&1
echo   - Telnet: DISABLED

echo.
echo [4/6] Ensuring Windows Firewall is Enabled...
netsh advfirewall set allprofiles state on >> %LOGFILE% 2>&1
echo   - Firewall: ENABLED for all profiles (Domain, Private, Public)

echo.
echo [5/6] Checking for Windows Updates...
wuauclt /detectnow /updatenow >> %LOGFILE% 2>&1
echo   - Update check triggered. Go to Settings ^> Windows Update to install.

echo.
echo [6/6] Security Hardening Complete!
echo.
echo Summary:
echo - Defender protections enabled.
echo - Quick scan run.
echo - RDP and Telnet disabled.
echo - Firewall enabled.
echo - Updates checked.
echo.
echo Pro-Specific: Consider enabling BitLocker for full-disk encryption (Settings ^> Privacy & security ^> Device encryption).
echo.
echo Review full log at: %LOGFILE%
echo.
echo WARNING: This is basic hardening. For full security:
echo - Use strong passwords and 2FA.
echo - Avoid suspicious downloads/links.
echo - Run full Defender scans regularly.
echo - Leverage Pro features like Group Policy for advanced controls.
echo.
pause
