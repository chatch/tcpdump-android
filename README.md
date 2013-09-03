Overview
--------
This script will cross compile tcpdump for use on Android devices.

It was written by Loic Poulain on OMAPpedia. See http://omappedia.org/wiki/USB_Sniffing_with_tcpdump for full details.

Build
-----
Install the [Android NDK](https://developer.android.com/tools/sdk/ndk/index.html) then:  

    export NDK=/ndk/is/here  
    ./build-tcpdump

Install on Droid
----------------
    > adb push tcpdumpbuild/tcpdump /sdcard
    > adb shell
    # su
    # mount | grep system
    /dev/block/xxxxxxxx /system ext4 ro,relatime,barrier=1,data=ordered 0 0
    # mount -o remount,rw /dev/block/xxxxxxxx /system
    # cp /sdcard/tcpdump /system/bin/tcpdump
    # mount -o remount,ro /dev/block/xxxxxxxx /system

Run
---
    # tcpdump -D (or run netcfg)
    1.eth0
    2.any (Pseudo-device that captures on all interfaces)
    3.lo
    
    # tcpdump -vv -i eth0 -s 0 -w /sdcard/dump.cap
