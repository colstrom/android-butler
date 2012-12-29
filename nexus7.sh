#!/usr/bin/env sh
# Copyright (c) 2012 Chris Olstrom <chris@olstrom.com>
# See included LICENSE file for details.

# fetch curl if not already present
sudo apt-get install curl

# create directories
mkdir files tools

# fetch binaries
curl -C - https://dl.google.com/dl/android/aosp/nakasi-jop40d-factory-6ac58a1a.tgz -o files/nakasi-jop40d-factory-6ac58a1a.tgz
curl -C - http://android.downloadspark.com/nexus7/TWRP_multirom_n7_20121220-2.img -o files/TWRP_multirom_n7_20121220-2.img
curl -C - http://android.downloadspark.com/nexus7/multirom_v3_n7-signed.zip -o files/multirom_v3_n7-signed.zip
curl -C - http://android.downloadspark.com/nexus7/kernel_kexec_42.zip -o files/kernel_kexec_42.zip
curl -C - http://android.downloadspark.com/nexus7/CWM-SuperSU-v0.99.zip -o files/CWM-SuperSU-v0.99.zip
curl -C - http://android.downloadspark.com/tools/fastboot -o tools/fastboot
curl -C - http://android.downloadspark.com/tools/adb -o tools/adb

# unlock device
sudo ./tools/fastboot oem unlock

# upgrade to 4.2.1
tar xzvf files/files/nakasi-jop40d-factory-6ac58a1a.tgz
cd nakasi-jop40d
sed 's/fastboot/..\/tools\/fastboot/' flash-all.sh
sudo ./flash-all.sh

# flash recovery
sudo ./tools/fastboot flash recovery files/TWRP_multirom_n7_20121220-2.img

# create recovery script
echo install /sdcard/multirom_v3_n7-signed.zip > files/openrecoveryscript
echo install /sdcard/kernel_kexec_42.zip >> files/openrecoveryscript
echo install /sdcard/CWM-SuperSU-v0.99.zip >> files/openrecoveryscript

# push files to device
sudo ./tools/adb push files/multirom_v3_n7-signed.zip /sdcard/multirom_v3_n7-signed.zip
sudo ./tools/adb push files/kernel_kexec_42.zip /sdcard//kernel_kexec_42.zip
sudo ./tools/adb push files/CWM-SuperSU-v0.99.zip /sdcard/CWM-SuperSU-v0.99.zip
sudo ./tools/adb push files/openrecoveryscript /cache/recovery/openrecoveryscript

# reboot to recovery
sudo ./tools/fastboot reboot recovery