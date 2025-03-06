# Citron AppImage Builder

This repository contains scripts to build [Citron](https://git.citron-emu.org/Citron/Citron) using either an Arch Linux Docker container or a Podman container for Steam Deck. It automates the process of setting up a clean environment and generating a Citron AppImage with support for multiple build modes.

## Features

- Uses Docker or Podman to provide a consistent build environment.
- Supports multiple build modes:
  - `release`: Release mode builds Citron with optimizations for better performance.
  - `steamdeck`: Steamdeck mode builds Citron with optimizations for better performance.
  - `compatibility`: Compatibility mode builds Citron with optimizations for older architectures.
  - `debug`: Debug mode includes additional debugging symbols but is slower.
- Steam Deck starting script (`start_build_steamdeck_podman.sh`) for easier execution on Steam Deck without modifying SteamOS.
- Included Windows batch file (`start_build_windows_wsl.bat`) for automated start with interactive prompt for all options.
- Outputs a Citron AppImage in the current working directory.
- Option to output Linux binaries separately.
- Option to cache the Citron Git repository for subsequent builds.

## Requirements

### Windows

- [Docker Desktop for Windows](https://docs.docker.com/desktop/setup/install/windows-install/) installed and running on your system.
- Windows Subsystem for Linux (WSL) installed and enabled.

### Steam Deck

- [Podman](https://podman.io/) should be pre-installed with SteamOS 3.5+. Verify installation by running:
  ```sh
  podman --version
  ```
  If not installed, install it from the Software Center.
- Sufficient disk space (\~5GB for the build process).

### Linux / macOS

- [Docker](https://docs.docker.com/get-docker/) installed.

**Note for users on ARM-based devices (e.g., macOS M1/M2 or similar ARM64 platforms):** If you encounter issues during the build process, it may be due to architecture incompatibilities. Try one of the following solutions:
- Use an ARM64-compatible container image by specifying the platform explicitly:
   ```sh
   docker build --platform=linux/arm64 -t citron-builder .
   docker run --platform=linux/arm64 --rm -v "$(pwd)":/output citron-builder
   ```
- Install Rosetta 2 (for macOS) and run the container in x86\_64 emulation mode:
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

   Alternatively, download and extract the repository as a ZIP file.

2. Run the batch script:

   ```sh
   start_build_windows_wsl.bat
   ```

3. Follow the on-screen prompts to select your build options.

4. Ensure an active internet connection for downloading dependencies.

5. The Citron AppImage file will be created in the current directory.

6. The script will prompt you about optional disk cleanup.

### Linux / macOS

1. Clone this repository:

   ```sh
   git clone https://github.com/azazelv5/citron-appimage-builder.git
   cd citron-appimage-builder
   ```

   Alternatively, download and extract the repository as a ZIP file.

2. Build and run the Docker container:

   ```sh
   docker build -t citron-builder .
   docker run --rm -v "$(pwd)":/output citron-builder
   ```

3. Ensure an active internet connection for downloading dependencies.

4. The Citron AppImage file will be created in the current directory.

5. (Optional) Remove the `citron-builder` image to save disk space:

   ```sh
   docker rmi -f citron-builder
   ```

### Steam Deck (Podman)

1. Switch to [Desktop Mode](https://help.steampowered.com/en/faqs/view/671A-4453-E8D2-323C).

2. Open a terminal (Konsole is the default terminal app).

3. Ensure you are in a writable directory:
   ```sh
   cd ~
   ```

4. Clone this repository:
   ```sh
   git clone https://github.com/azazelv5/citron-appimage-builder.git
   cd citron-appimage-builder
   ```

5. Make the start script executable:
   ```sh
   chmod +x start_build_steamdeck_podman.sh
   ```

6. Run the Steam Deck build script:
   ```sh
   ./start_build_steamdeck_podman.sh
   ```

7. Follow the on-screen prompts to select your build mode and Citron version.

8. The Steam Deck may enter sleep mode during the build process. To prevent this, click on the battery icon and then on "Manually block sleep and screen locking".

9. The Citron AppImage file will be created in the current directory.

10. The script will prompt you about optional disk cleanup.

## Advanced Docker Usage

For users running Docker in Linux or macOS, you can modify the Docker run command accordingly:

- Use the default command for the latest Citron build optimized for Steam Deck:

  ```sh
  docker run --rm -v "$(pwd)":/output citron-builder
  ```

- Specify a version tag, branch name or commit hash if you need a specific release:

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

## Troubleshooting

- Verify internet connectivity or possible outages from both the Citron repository and all the external dependencies if the build process fails. Check the [Citron Discord](https://discord.gg/VcSDxrBYUJ) community for more information.

## Credits

This script was created with the help of the [Citron Wiki](https://git.citron-emu.org/Citron/Citron/wiki/?action=_pages) and members of the [Citron Discord](https://discord.gg/VcSDxrBYUJ) community.

## License

This project is licensed under the GNU GENERAL PUBLIC LICENSE. See the [LICENSE](./LICENSE) file for details.

