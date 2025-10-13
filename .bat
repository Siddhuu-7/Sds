@echo off
REM -----------------------------------------
REM SDS CLI Tool Installer (Windows)
REM Downloads ZIP from server, installs, creates wrapper, and sets PATH
REM -----------------------------------------

REM Config
set "DOWNLOAD_URL=http://localhost:3000/tcp"
set "ZIP_FILE=%USERPROFILE%\Downloads\sds.zip"
set "INSTALL_DIR=%USERPROFILE%\SDS"
set "BIN_DIR=%INSTALL_DIR%\bin"

REM Step 1: Download ZIP using curl
echo Downloading package from server...
curl -L -o "%ZIP_FILE%" "%DOWNLOAD_URL%"
if %errorlevel% neq 0 (
    echo Failed to download the package. Please check the URL or your internet connection.
    pause
    exit /b 1
)

REM Step 2: Create installation folders
if not exist "%BIN_DIR%" mkdir "%BIN_DIR%"

REM Step 3: Extract ZIP to installation folder
echo Extracting package...
powershell -Command "Expand-Archive -Force '%ZIP_FILE%' '%INSTALL_DIR%'"
if %errorlevel% neq 0 (
    echo Failed to extract the ZIP file.
    pause
    exit /b 1
)

REM Step 4: Create sds wrapper in BIN_DIR
echo Creating the SDS command wrapper...
(
echo @echo off
echo REM Wrapper for SDS CLI tool
echo "%BIN_DIR%\SDSMain.exe" %%*
) > "%BIN_DIR%\sds.bat"

REM Step 5: Add BIN_DIR to User PATH if not already
echo %PATH% | findstr /i "%BIN_DIR%" >nul
if %errorlevel% neq 0 (
    setx PATH "%PATH%;%BIN_DIR%"
    echo Added SDS bin folder to your User PATH.
) else (
    echo SDS bin folder is already in your User PATH.
)

REM Step 6: Cleanup downloaded ZIP
del "%ZIP_FILE%"

echo ---------------------------------------
echo Installation complete.
echo Please open a new terminal to start using your SDS CLI tool.
pause
