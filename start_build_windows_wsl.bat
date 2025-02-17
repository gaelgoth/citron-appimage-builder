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

:: Build the new image
docker build -t citron-builder .

:: Run the container and create the AppImage
docker run --rm -v %CD%:/output citron-builder

:: Other options
@REM docker run --rm -e CITRON_VERSION=v0.4-canary-refresh -v %CD%:/output citron-builder
@REM docker run --rm -e ENABLE_OPTIMIZATIONS=ON -v %CD%:/output citron-builder

echo Citron AppImage created in %CD%!

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
