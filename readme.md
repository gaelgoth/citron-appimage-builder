# Citron AppImage Builder

This repository contains scripts to build [Citron](https://git.citron-emu.org/Citron/Citron) using either an Arch Linux Docker container or a Distrobox container for Steam Deck. It automates the process of setting up a clean environment and generating a Citron AppImage with support for multiple build modes.

## Features

- Uses Docker or Distrobox to provide a consistent build environment.
- Supports multiple build modes (`release`, `steamdeck`, `compatibility`, `debug`).
- Included Windows batch file for automated start with interactive prompt for all options.
- Outputs a Citron AppImage in the current working directory.
- Option to output Linux binaries separately.
- Option to cache the Citron Git repository for subsequent builds.
- Dedicated Steam Deck script (`start_build_steamdeck_distrobox.sh`) for easier execution on Steam Deck.

## Requirements

### Windows

- [Docker Desktop for Windows](https://docs.docker.com/desktop/setup/install/windows-install/) installed and running on your system.

### Steam Deck

- SteamOS 3.5+ with [Distrobox](https://github.com/89luca89/distrobox) preinstalled.
- Sufficient disk space (~5GB for build process).

### Linux / macOS

- [Docker](https://docs.docker.com/get-docker/) installed.

**Note for users on ARM-based devices (e.g., macOS M1/M2, Raspberry Pi, AWS Graviton, or similar ARM64 platforms):** If you encounter issues during the build process, it may be due to architecture incompatibilities. Try one of the following solutions:

1. Use an ARM64-compatible Docker image by specifying the platform explicitly:
   ```sh
   docker build --platform=linux/arm64 -t citron-builder .
   docker run --platform=linux/arm64 --rm -v "$(pwd)":/output citron-builder
   ```
2. Install Rosetta 2 (for macOS) and run the container in x86_64 emulation mode:
   ```sh
   softwareupdate --install-rosetta
   docker run --platform=linux/amd64 --rm -v "$(pwd)":/output citron-builder
   ```

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

3. The script will prompt you about build options and disk cleanup.

4. Ensure an active internet connection for downloading dependencies.

5. The Citron AppImage file will be created in the current directory.

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

### Steam Deck (Distrobox)

1. Switch to [Desktop Mode](https://help.steampowered.com/en/faqs/view/671A-4453-E8D2-323C).

2. Open a terminal (Konsole is the default terminal app).

3. Ensure you are in your home directory:
   ```sh
   cd ~
   ```

4. Clone this repository:
   ```sh
   git clone https://github.com/azazelv5/citron-appimage-builder.git
   cd citron-appimage-builder
   ```

5. Make the script executable:
   ```sh
   chmod +x start_build_steamdeck_distrobox.sh
   ```

6. Run the Steam Deck build script:
   ```sh
   ./start_build_steamdeck_distrobox.sh
   ```

7. Follow the on-screen prompts to select your build mode and Citron version.

8. The Citron AppImage file will be created in the current directory.

## Options (Docker)

For users running Linux or macOS, you can modify the Docker run command accordingly:

- Use the default command for the latest Citron build optimized for Steam Deck:
  ```sh
  docker run --rm -v "$(pwd)":/output citron-builder
  ```

- Specify a version tag or branch name if you need a specific release:
  ```sh
  docker run --rm -e CITRON_VERSION=v0.5-canary-refresh -v "$(pwd)":/output citron-builder
  ```

- Choose a different [build mode](https://git.citron-emu.org/Citron/Citron/wiki/Building-For-Linux#building-citron) (`release`, `steamdeck`, `compatibility`, `debug`):
  ```sh
  docker run --rm -e CITRON_BUILD_MODE=compatibility -e CITRON_VERSION=v0.5-canary-refresh -v "$(pwd)":/output citron-builder
  ```

- Enable Linux binary output if you need separate non-AppImage executables:
  ```sh
  docker run --rm -e OUTPUT_LINUX_BINARIES=true -v "$(pwd)":/output citron-builder
  ```

- Use cache options to speed up subsequent builds by preserving Citron's source repository between runs:
  ```sh
  docker run --rm -e USE_CACHE=true -v "$(pwd)":/output citron-builder
  ```

## Output Naming

The generated AppImage filename will follow this format:

- **Latest builds:** `citron-nightly-<build_mode>-<timestamp>-<commit_hash>.AppImage`
- **Versioned builds:** `citron-<version>-<build_mode>.AppImage`

For example:

```sh
citron-nightly-steamdeck-20250228-153045-abcdefg.AppImage
citron-v0.5-canary-refresh-release.AppImage
```

## Credits

This script was created with the help of the [Citron Wiki](https://git.citron-emu.org/Citron/Citron/wiki/?action=_pages) and members of the [Citron Discord](https://discord.gg/VcSDxrBYUJ) community.

## License

This project is licensed under the GNU GENERAL PUBLIC LICENSE. See the [LICENSE](./LICENSE) file for details.

