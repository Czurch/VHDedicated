@echo off
setlocal

REM Warning message
echo WARNING! This script will replace the local copy of your world. If you want the latest copy type 'y'.
set /p userInput=Do you want to proceed? (y/n): 

if /i not "%userInput%"=="y" (
    echo Operation aborted.
    pause
    exit /b
)

REM Perform git fetch and pull
echo "Fetching and pulling the latest updates..."
git fetch
git pull

REM Define the source and destination directories
set "sourceDir=%~dp0Worlds"
set "destDir=%USERPROFILE%\AppData\LocalLow\IronGate\Valheim\worlds_local"

REM Output the directories for debugging purposes
echo "Source Directory: %sourceDir%"
echo "Destination Directory: %destDir%"

REM Check if the source directory exists
if not exist "%sourceDir%" (
    echo "Source directory '%sourceDir%' does not exist."
    pause
    exit /b
)

REM Create the destination directory if it does not exist
if not exist "%destDir%" (
    echo "Destination directory does not exist. Creating directory..."
    mkdir "%destDir%"
)

REM Copy files from source to destination, overwriting existing files
echo "Copying files from '%sourceDir%' to '%destDir%'..."
xcopy "%sourceDir%\*" "%destDir%\" /Y /R /S

REM Check if the copy operation was successful
if %errorlevel% equ 0 (
    echo "Files copied successfully."
) else (
    echo "Failed to copy files."
)

pause
endlocal