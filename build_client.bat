cd %~dp0

call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"

msbuild UrBackupClientGUI.sln /p:Configuration=Release /p:Platform="Win32"
if %errorlevel% neq 0 exit /b %errorlevel% 

msbuild UrBackupClientGUI.sln /p:Configuration=Release /p:Platform="x64"
if %errorlevel% neq 0 exit /b %errorlevel%

call update_data.bat

if NOT "%SIGN%" == "true" GOTO skip_signing1

signtool sign /fd sha256 /t http://timestamp.digicert.com /i DigiCert data\*.exe data\*.dll data_x64\*.exe data_x64\*.dll

:skip_signing1

"C:\Program Files (x86)\NSIS\Unicode\makensis.exe" "%~dp0/urbackup.nsi"
if %errorlevel% neq 0 exit /b %errorlevel%

"C:\Program Files (x86)\NSIS\Unicode\makensis.exe" "%~dp0/urbackup_notray.nsi"
if %errorlevel% neq 0 exit /b %errorlevel%

"C:\Program Files (x86)\NSIS\Unicode\makensis.exe" "%~dp0/urbackup_update.nsi"
if %errorlevel% neq 0 exit /b %errorlevel%

call build_msi.bat

if NOT "%SIGN%" == "true" GOTO skip_signing2

signtool sign /fd sha256 /t http://timestamp.digicert.com /i DigiCert "UrBackup Client $version_short$.exe" "UrBackup Client NoTray $version_short$.exe" "UrBackup Client $version_short$(x64).msi" "UrBackup Client (No tray) $version_short$(x64).msi"

:skip_signing2