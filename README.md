Overview
--------
This script will cross compile tcpdump for use on Android devices.

It was written by Loic Poulain on OMAPpedia. See http://omappedia.org/wiki/USB_Sniffing_with_tcpdump for full details.

Build
-----
Install the [Android NDK](https://developer.android.com/tools/sdk/ndk/index.html) then:  

    gpg --recv-key E089DEF1D9C15D0D
        gpg: requesting key D9C15D0D from hkp server keys.gnupg.net
        gpg: key D9C15D0D: "The Tcpdump Group (Package signing key) <release@tcpdump.org>" 2 new signatures
        gpg: 3 marginal(s) needed, 1 complete(s) needed, PGP trust model
        gpg: depth: 0  valid:   2  signed:  27  trust: 0-, 0q, 0n, 0m, 0f, 2u
        gpg: depth: 1  valid:  27  signed:  20  trust: 18-, 0q, 0n, 6m, 3f, 0u
        gpg: next trustdb check due at 2016-11-28
        gpg: Total number processed: 1
        gpg:         new signatures: 2

    gpg --fingerprint E089DEF1D9C15D0D
        pub   3104R/D9C15D0D 2013-05-13 [expires: 2023-05-11]
              Key fingerprint = 1F16 6A57 42AB B9E0 249A  8D30 E089 DEF1 D9C1 5D0D
        uid                  The Tcpdump Group (Package signing key) <release@tcpdump.org>

    export NDK=/ndk/is/here  
    ./build-tcpdump

Install on Droid
----------------
    > adb root
    > adb remount
    > adb push tcpdumpbuild/tcpdump /system/xbin/tcpdump
    > adb shell
    # mount | grep system
or  # grep system /proc/mounts
    /dev/block/xxxxxxxx /system ext4 ro,relatime,barrier=1,data=ordered 0 0
    # mount -o remount,ro /dev/block/xxxxxxxx /system

Run
---
    # tcpdump -D (or run netcfg)
    1.eth0
    2.any (Pseudo-device that captures on all interfaces)
    3.lo
    
    # tcpdump -vv -i eth0 -s 0 -w /sdcard/dump.cap
