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
set "destDir=%USERPROFILE%\AppData\LocalLow\IronGate\Valheim\Worlds"

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

REM Function to compare modified dates and copy the latest file
echo "Comparing file modified dates and copying the latest versions..."
powershell -Command ^
    "Get-ChildItem -Path '%sourceDir%' | ForEach-Object { ^
        $sourceFile = $_; ^
        $destFile = Join-Path -Path '%destDir%' -ChildPath $sourceFile.Name; ^
        if (Test-Path $destFile) { ^
            $sourceDate = (Get-Item $sourceFile.FullName).LastWriteTime; ^
            $destDate = (Get-Item $destFile).LastWriteTime; ^
            if ($sourceDate -gt $destDate) { ^
                Copy-Item -Path $sourceFile.FullName -Destination $destFile -Force; ^
                echo 'Copied newer file from source: ' $sourceFile.Name; ^
            } else { ^
                echo 'Kept existing file in destination: ' $sourceFile.Name; ^
            } ^
        } else { ^
            Copy-Item -Path $sourceFile.FullName -Destination $destFile -Force; ^
            echo 'Copied new file from source: ' $sourceFile.Name; ^
        } ^
    }"

echo "File comparison and copy operation completed."
pause
endlocal
