#!/usr/bin/env sh

# add repository
sudo add-apt-repository ppa:ubuntu-nexus7/ubuntu-nexus7-installer
sudo apt-get update
sudo apt-get install android-tools-fastboot android-tools-adb

# create directories
mkdir files

# fetch binaries
curl https://dl.google.com/dl/android/aosp/nakasi-jop40d-factory-6ac58a1a.tgz -o files/factory-image.tgz
curl http://android.downloadspark.com/files/nexus7/TWRP_multirom_n7_20121220-2.img -o files/recovery.img
curl http://android.downloadspark.com/files/nexus7/multirom_v3_n7-signed.zip -o files/multirom_v3_n7-signed.zip
curl http://android.downloadspark.com/files/nexus7/kernel_kexec_42.zip -o files/kernel_kexec_42.zip
curl http://android.downloadspark.com/files/nexus7/CWM-SuperSU-v0.99.zip -o files/CWM-SuperSU-v0.99.zip

# unlock device
sudo fastboot oem unlock

# upgrade to 4.2.1
tar xzvf factory-image.tgz
cd nakasi-jop40d
sudo ./flash-all.sh

# flash recovery
sudo fastboot flash recovery files/recovery.img

# create recovery script
echo install /sdcard/multirom_v3_n7-signed.zip > files/openrecoveryscript
echo install /sdcard/kernel_kexec_42.zip >> files/openrecoveryscript
echo install /sdcard/CWM-SuperSU-v0.99.zip >> files/openrecoveryscript

# push files to device
sudo adb push files/multirom_v3_n7-signed.zip /sdcard/multirom_v3_n7-signed.zip
sudo adb push files/kernel_kexec_42.zip /sdcard//kernel_kexec_42.zip
sudo adb push files/CWM-SuperSU-v0.99.zip /sdcard/CWM-SuperSU-v0.99.zip
sudo adb push files/openrecoveryscript /cache/recovery/openrecoveryscript

# reboot to recovery
sudo fastboot reboot recovery