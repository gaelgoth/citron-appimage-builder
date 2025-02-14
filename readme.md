# Citron Arch Linux Docker Builder

This repository contains a script to build Citron using an Arch Linux Docker container. It automates the process of setting up a clean environment and generating a Citron AppImage for Arch Linux / Steam OS / Steam Deck.

## Features
- Uses Docker to provide a consistent build environment
- Automatically removes old Docker images to prevent duplication
- Outputs a Citron AppImage in the current working directory

## Requirements
- [Docker](https://docs.docker.com/desktop/setup/install/windows-install/) installed on your system
- Windows (for the provided batch script) or a manual setup for Linux/macOS

## Usage
1. Clone this repository:
   ```sh
   git clone https://github.com/azazelv5/citron-appimage-builder.git
   cd citron-appimage-builder
   ```
2. Run the batch script:
   ```sh
   start_build_windows_wsl.bat
   ```
3. The Citron AppImage will be created in the current directory.

### Examples
Modify the batch file accordingly:
- Default version (latest master):
  ```sh
  docker run --rm -v ${PWD}:/output citron-builder
  ```
- Specific version:
  ```sh
  docker run --rm -e CITRON_VERSION=v0.4-canary-refresh -v ${PWD}:/output citron-builder
  ```

## Credits
This script was created with the help of the [Citron Wiki](https://git.citron-emu.org/Citron/Citron/wiki/?action=_pages) and members of the [Citron Discord](https://discord.gg/VcSDxrBYUJ) community.

## License
This project is licensed under the GNU GENERAL PUBLIC LICENSE. See the LICENSE file for details.

