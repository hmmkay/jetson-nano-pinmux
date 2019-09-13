# Build environment and scripts for custom Nvidia Jetson Nano pinmux configurations

Nvidia provides instructions for creating custom pinmux configurations for the Jetson Nano development board over at https://developer.nvidia.com/embedded/dlc/Jetson-Nano-40-Pin-Expansion-Header-1.1.
The pinmux configurations themselves are edited in an Excel spreadsheet per the instructions and exported as both a UTF-8 formatted CSV file to rebuild the U-Boot bootloader with, as well as two .dtsi device tree files for the Cboot bootloader.

This project containers a Dockerfile to setup a a dedicated build environment to compile the new bootloaders, as well as a utility script to automate the various steps of copying the custom pinmux configurations into the build tree and rebuilding bootloaders and device tree binaries.

To build the container image, change to the directory containing the Dockerfile and execute: `docker build --tag=jetson-nano-build .`
This will pull down a minimal Ubuntu 18.04 image, add packages for the build process, pull down and unpack the Nvidia source code and scripts into various directories under /jetson-buil/ inside the image.

Save your custom pinumx files (the .csv and the two .dtsi files, pr Nvidia's instructions) somewhere on your filesystem, then from that directory where you saved to execute  `docker run -it -p 222:22 -v ``pwd``:/sync jetson-nano-build` to launch the container the first time (subsequent launches you can just execute `docker start <container_id>`. This will startup the container with the directory /sync/ inside the container able to copy files to/from the directory on the host from within which you ran the docker run command.

From the shell inside the container, change to the /jetson-build/jetson-nano-pinmux directory (`cd /jetson-build/jetson-nano-pinmux`) and execute the build-custom-pinmux.sh command with the full path and filename of the .csv and .dtsi files from the pinmux template spreadsheet (e.g. `./build-custom-pinmux.sh /sync/jetson-nano-sd.csv /sync/tegra210-jetson-nano-sd-pinmux.dtsi /sync/tegra210-jetson-nano-sd-gpio-default.dtsi`). This will kick off the process of compiling the device tree files and bootloader images and result in a filesystem ready to flash to the Nano.

When it comes to flashing it can be quite a mission to get the Docker container to access the Jetson Nano, so the commands in the Dockerfile and script sources can be re-entered inside a Virtual Machine environment such as VMWare or VirtualBox (with the Jetson USB device passed through to the VM) bare metal installation on top of a minimial Ubuntu 18.04 LTS installation.

