@echo off
setlocal

REM Warning message
echo WARNING! This script will replace the remote version of our shared World. Are you sure you want to overwrite? (y/n):
set /p userInput=Do you want to proceed? (y/n):  

if /i not "%userInput%"=="y" (
    echo Operation aborted.
    pause
    exit /b
)

echo I REPEAT! Are you 100 percent certain that this is script you should be running. Type 'overwrite' if you are ready to replace the world.
set /p userInput=Type 'overwrite' if you are ready to replace the world: 

if /i not "%userInput%"=="overwrite" (
    echo Operation aborted.
    pause
    exit /b
)

echo Overwriting....

REM Define the source and destination directories
set "sourceDir=%USERPROFILE%\AppData\LocalLow\IronGate\Valheim\worlds_local"
set "destDir=%~dp0Worlds"

REM Output the directories for debugging purposes
echo "Source Directory: %sourceDir%"
echo "Destination Directory: %destDir%"

REM Check if the source directory exists
if not exist "%sourceDir%" (
    echo "Source directory '%sourceDir%' does not exist."
    pause
    exit /b
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

git add ./Worlds
git commit
git push

pause
endlocal