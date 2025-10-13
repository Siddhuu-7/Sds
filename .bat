REM -----------------------------------------
REM SDS CLI Tool Installer (Windows)
REM Downloads ZIP from server, installs, creates wrapper, and sets PATH
REM -----------------------------------------

REM Config
set "DOWNLOAD_URL=https://sds-w8ob.onrender.com/tcp"
set "ZIP_FILE=%USERPROFILE%\Downloads\sds.zip"
set "INSTALL_DIR=%USERPROFILE%\SDS"

REM Step 1: Download ZIP using curl
echo Downloading package from server...
curl -L -o "%ZIP_FILE%" "%DOWNLOAD_URL%"
if %errorlevel% neq 0 (
    echo Failed to download the package. Please check the URL or your internet connection.
    pause
    exit /b 1
)

REM Step 2: Create installation folder
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

REM Step 3: Extract ZIP to installation folder
echo Extracting package...
powershell -Command "Expand-Archive -Force '%ZIP_FILE%' '%INSTALL_DIR%'"
if %errorlevel% neq 0 (
    echo Failed to extract the ZIP file.
    pause
    exit /b 1
)

REM Step 4: Create sds wrapper in INSTALL_DIR
echo Creating the SDS command wrapper...
(
echo @echo off
echo REM Wrapper for SDS CLI tool
echo "%INSTALL_DIR%\SDS.bat" %%*
) > "%INSTALL_DIR%\sds.bat"

REM Step 5: Add INSTALL_DIR to User PATH if not already
echo %PATH% | findstr /i "%INSTALL_DIR%" >nul
if %errorlevel% neq 0 (
    setx PATH "%PATH%;%INSTALL_DIR%"
    echo Added SDS folder to your User PATH.
) else (
    echo SDS folder is already in your User PATH.
)

REM Step 6: Cleanup downloaded ZIP
del "%ZIP_FILE%"

echo ---------------------------------------
echo Installation complete.
echo Please open a new terminal to start using your SDS CLI tool.
pause
