# Build environment and scripts for custom Nvidia Jetson Nano pinmux configurations

Nvidia provides instructions for creating custom pinmux configurations for the Jetson Nano development board over at https://developer.nvidia.com/embedded/dlc/Jetson-Nano-40-Pin-Expansion-Header-1.1.
The pinmux configurations themselves are edited in an Excel spreadsheet per the instructions and exported as both a UTF-8 formatted CSV file to rebuild the U-Boot bootloader with, as well as two .dtsi device tree files for the Cboot bootloader.

This project containers a Dockerfile to setup a build environment to compile the new bootloaders, as well as a utility script to automate the various steps of copying the custom pinmux configurations into the build tree and rebuilding bootloaders and device tree binaries.

It can be quite a mission to get the Docker container to access the Jetson Nano when it comes to flashing, so the commands in the Dockerfile and script sources can be re-entered inside a Virtual Machine environment such as VMWare or VirtualBox on top of a minimial Ubuntu 18.04 LTS installation and with the Jetson USB device passed through to the VM.

