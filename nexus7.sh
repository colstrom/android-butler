#!/usr/bin/env sh
# Copyright (c) 2012 Chris Olstrom <chris@olstrom.com>
# See included LICENSE file for details.

# fetch curl and ia32-libs if not already installed.
sudo apt-get install curl ia32-libs

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

# set execute bit for tools
chmod u+x tools/adb tools/fastboot

echo "
** ACTION REQUIRED **

If you have not already done so, please place your device into fastboot mode.
To do this, power off your device, then hold the volume down button and power it on again.
Press any key when you have done this."
read and_ignore

# unlock device
sudo ./tools/fastboot oem unlock

# upgrade to 4.2.1
tar xzvf files/nakasi-jop40d-factory-6ac58a1a.tgz
cd nakasi-jop40d
sed -i 's/fastboot/..\/tools\/fastboot/' flash-all.sh
sudo ./flash-all.sh
cd ..

# prompt user and wait for confirmation
echo "
** ACTION REQUIRED **

Please reboot into fastboot mode once more.
To do this, power off your device, then hold the volume down button and power it on again.
Press any key when you have done this."
read and_ignore

# flash recovery
sudo ./tools/fastboot flash recovery files/TWRP_multirom_n7_20121220-2.img

# create recovery script
echo install /sdcard/multirom_v3_n7-signed.zip > files/openrecoveryscript
echo install /sdcard/kernel_kexec_42.zip >> files/openrecoveryscript
echo install /sdcard/CWM-SuperSU-v0.99.zip >> files/openrecoveryscript

# prompt user to take action, and wait for confirmation.
echo "
** ACTION REQUIRED **

Please reboot into recovery mode at this time.
To do this, use the volume rocker to select 'Recovery mode', and press the power button to confirm the selection.
Press any key when you have done this."
read and_ignore

# push files to device
sudo ./tools/adb push files/multirom_v3_n7-signed.zip /sdcard/multirom_v3_n7-signed.zip
sudo ./tools/adb push files/kernel_kexec_42.zip /sdcard//kernel_kexec_42.zip
sudo ./tools/adb push files/CWM-SuperSU-v0.99.zip /sdcard/CWM-SuperSU-v0.99.zip
sudo ./tools/adb push files/openrecoveryscript /cache/recovery/openrecoveryscript

# reboot to recovery
sudo ./tools/adb reboot recovery
