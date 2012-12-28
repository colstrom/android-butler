android-butler
==============

Automation scripts for new devices.

Features
--------
* Unlocks your Nexus 7.
* Updates to the latest factory image (currently 4.2.1).
* Flashes a modified TWRP Recovery, including MultiROM patches from [Tassadar](https://github.com/Tasssadar/Team-Win-Recovery-Project)
* Installs the [MultiROM bootloader](https://github.com/Tasssadar/multirom/tree/nexus7), and the [kernel patches](https://github.com/Tasssadar/kernel_nexus/commits/kexec-hardboot) required to support it in stock Android.
* Roots the device, and installs [SuperSU from Chainfire](https://play.google.com/store/apps/details?id=eu.chainfire.supersu) for managing root permissions.
* Builds an [OpenRecovery Script](http://www.teamw.in/OpenRecoveryScript) to automate this installation.

Requirements
------------
* adb, curl, and fastboot available in $PATH.
* These will be installed automatically on Ubuntu 10.04+ and similar distributions (like Mint).

How to Use
----------
1. Run the script.
2. When prompted, plug in your device.