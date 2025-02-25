@echo off
:: Title: Citron AppImage Build Windows Script
:: Description: Builds and runs the Citron container to create an AppImage.

:: Check if Docker is installed
echo Checking for Docker installation...
docker --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo.
    echo ==================================================================
    echo   Docker is not installed on your system.
    echo   Please install Docker from the official Docker website: 
    echo   https://docs.docker.com/desktop/setup/install/windows-install/
    echo ==================================================================
    echo.
    pause
    exit /b 1
)

:: Check if Docker is running
docker info >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo =====================================================================
    echo   Docker is not running. Please start Docker Desktop and try again.
    echo =====================================================================
    echo.
    pause
    exit /b
)

:: Check if the Docker image exists
FOR /F "tokens=* USEBACKQ" %%i IN (`docker images -q citron-builder`) DO SET IMAGE_EXISTS=%%i

IF NOT "%IMAGE_EXISTS%"=="" (
    echo Removing existing citron-builder image...
    docker rmi -f citron-builder
)

:: Ask user for version
echo ========================================================
echo   Choose the version to build:
echo   1. [Default] Latest master branch (nightly build)
echo   2. Citron Canary Refresh Version 0.5
echo   3. Citron Canary Refresh Version 0.4
echo   4. Specific version (Tag or Branch name)
echo ========================================================
set /p VERSION_CHOICE="Enter choice ([1]/2/3/4): "
if "%VERSION_CHOICE%"=="1" (
    set CITRON_VERSION=master
) else if "%VERSION_CHOICE%"=="2" (
    set CITRON_VERSION=v0.5-canary-refresh
) else if "%VERSION_CHOICE%"=="3" (
    set CITRON_VERSION=v0.4-canary-refresh
) else if "%VERSION_CHOICE%"=="4" (
    set /p CITRON_VERSION="Enter the version (Tag/Branch): "
) else (
    echo Defaulting to latest master branch.
    set CITRON_VERSION=master
)

:: Ask user for build mode
echo ========================================================
echo   Choose the build mode:
echo   1. [Default] SteamDeck optimizations
echo   2. Release mode
echo   3. Compatibility mode (for older architectures)
echo   4. Debug mode
echo ========================================================
set /p BUILD_MODE_CHOICE="Enter choice ([1]/2/3/4): "
if "%BUILD_MODE_CHOICE%"=="1" (
    set CITRON_BUILD_MODE=steamdeck
    echo Defaulting to SteamDeck optimizations.
) else if "%BUILD_MODE_CHOICE%"=="2" (
    set CITRON_BUILD_MODE=release
) else if "%BUILD_MODE_CHOICE%"=="3" (
    set CITRON_BUILD_MODE=compatibility
) else if "%BUILD_MODE_CHOICE%"=="4" (
    set CITRON_BUILD_MODE=debug
) else (
    echo Defaulting to SteamDeck optimizations.
    set CITRON_BUILD_MODE=steamdeck
)

:: Ask user if they want to output Linux binaries
echo ========================================================
echo   Do you want to output Linux binaries?
echo   1. Yes
echo   2. [Default] No
echo ========================================================
set /p OUTPUT_BINARIES="Enter choice (1/[2]): "
if "%OUTPUT_BINARIES%"=="1" (
    set OUTPUT_LINUX_BINARIES=true
) else if "%OUTPUT_BINARIES%"=="2" (
    set OUTPUT_LINUX_BINARIES=false
) else (
    echo Defaulting to No.
    set OUTPUT_LINUX_BINARIES=false
)

:: Build the new image
docker build -t citron-builder .

:: Build the container with the selected options
docker run --rm -e CITRON_VERSION=%CITRON_VERSION% -e CITRON_BUILD_MODE=%CITRON_BUILD_MODE% -e OUTPUT_LINUX_BINARIES=%OUTPUT_LINUX_BINARIES% -v %CD%:/output citron-builder

:: Ask the user if they want to delete the Docker image to save disk space (default to Yes)
echo.
echo ==================================================
echo   Do you want to remove the citron-builder image  
echo   to save disk space? (Y/n)                     
echo ==================================================
echo.
set /p DELETE_IMAGE="Enter choice: "
if /I "%DELETE_IMAGE%"=="" set DELETE_IMAGE=Y

if /I "%DELETE_IMAGE%"=="Y" ( 
    echo.
    echo ================================
    echo   Removing citron-builder image  
    echo ================================
    echo.
    docker rmi -f citron-builder
    echo citron-builder image removed.
) else (
    echo.
    echo ================================
    echo   citron-builder image kept  
    echo ================================
    echo.
)

pause
