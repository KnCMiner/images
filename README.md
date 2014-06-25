Firmware Images
======

This repository contains an archive of released firmware images.

Warning: Images with -E should only be used on November units (Ericsson DCDC modules), and images before 1.0 without -E should only be used on October units. Your miner will not work if your flash the wrong version. To recover you may need to unplug all ASIC modules and then flash the right release for your unit.


.bin files are firmware upgrade files installed via web interface

_SD.zip files are SD card images for full relash. To install these format and SD card in VFAT format and unzip the archive in the root of the SD card, then instert the SD card into the SD card slot of beaglebone black and power on the miner. When the bright led flashes green remote the SD card from beaglebone black SD card slot and powercycle the miner.
