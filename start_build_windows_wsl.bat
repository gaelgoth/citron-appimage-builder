@echo off
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
pause
