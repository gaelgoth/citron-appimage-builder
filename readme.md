# Citron Docker Builder

This repository contains a script to build Citron using an Arch Linux Docker container. It automates the process of setting up a clean environment and generating a Citron AppImage for Steam Deck with support for multiple build modes.

## Features

- Uses Docker to provide a consistent build environment.
- Supports multiple build modes (`release`, `steamdeck`, `compatibility`, `debug`).
- Allows setting the Citron version and build mode via environment variables.
- Outputs a Citron AppImage in the current working directory.
- Option to output Linux binaries separately.

## Requirements

### Windows
- [Docker Desktop for Windows](https://docs.docker.com/desktop/setup/install/windows-install/) installed and running on your system.

### Linux / macOS
- [Docker](https://docs.docker.com/get-docker/) installed.

## Usage

### Windows

1. Clone this repository:
   ```sh
   git clone https://github.com/azazelv5/citron-appimage-builder.git
   cd citron-appimage-builder
   ```
   Alternatively, you can download the repository as a zip file and extract it.

2. Run the batch script:
   ```sh
   start_build_windows_wsl.bat
   ```

3. Ensure an active internet connection for downloading dependencies. The script will prompt you about disk space cleanup after the build.

4. The Citron AppImage file will be created in the current directory.

### Linux / macOS

1. Clone this repository:
   ```sh
   git clone https://github.com/azazelv5/citron-appimage-builder.git
   cd citron-appimage-builder
   ```
   Alternatively, you can download the repository as a zip file and extract it.

2. Build and run the Docker container:
   ```sh
   docker build -t citron-builder .
   docker run --rm -v "$(pwd)":/output citron-builder
   ```

3. Ensure an active internet connection for downloading dependencies.

4. The Citron AppImage file will be created in the current directory.

5. (Optional) Remove the citron-builder image to save disk space:
   ```sh
   docker rmi -f citron-builder
   ```

## Options

Modify the docker run command accordingly:

- Default version (latest master) with SteamDeck optimizations build mode:
  ```sh
  docker run --rm -v "$(pwd)":/output citron-builder
  ```

- Specific version (Tag or Branch name) with SteamDeck optimizations build mode:
  ```sh
  docker run --rm -e CITRON_VERSION=v0.5-canary-refresh -v "$(pwd)":/output citron-builder
  ```

- Specify a different build mode (`release`, `steamdeck`, `compatibility`, `debug`):
  ```sh
  docker run --rm -e CITRON_BUILD_MODE=compatibility -e CITRON_VERSION=v0.5-canary-refresh -v "$(pwd)":/output citron-builder
  ```
  
- Enable output of Linux binaries:
  ```sh
  docker run --rm -e OUTPUT_LINUX_BINARIES=true -v ${pwd}:/output citron-builder
  ```

## Output Naming

The generated AppImage filename will follow this format:
- **Latest builds:** `citron-nightly-<build_mode>.AppImage`
- **Versioned builds:** `citron-<version>-<build_mode>.AppImage`

For example:
```sh
citron-nightly-steamdeck.AppImage
citron-v0.5-canary-refresh-release.AppImage
```

## Credits

This script was created with the help of the [Citron Wiki](https://git.citron-emu.org/Citron/Citron/wiki/?action=_pages) and members of the [Citron Discord](https://discord.gg/VcSDxrBYUJ) community.

## License

This project is licensed under the GNU GENERAL PUBLIC LICENSE. See the LICENSE file for details.

