# TicWatch-All-In-One-Tool
TicWatch Bebloater, Factory image flasher, connect new phone without resseting, enable mtp, flash twrp, root, change ui accent colour ...etc
All provided in a nice menu driven script.

##### Features are tested with a Ticwatch E so your millage may vary.

# Prerequisites
- adb, fastboot tools in path.

This repo only contains the script if you want a zip with all of the images,zips,apk collected all in one you can grab it from my telegram group.

Otherwise you will need to download the resourses from the following places.
- twrp: https://forum.xda-developers.com/t/twrp-root-ticwatch-e-s-unroot-instructions-for-updates-v003.3744752/
- factory images: https://forum.xda-developers.com/t/android-o-super-easy-ticwatch-e-s-update-flasher.3789835/
- magisk (old version needed Magisk-v20.4.zip MagiskManager-v7.5.1.apk): https://github.com/topjohnwu/Magisk
- UI accent apks (need to be renamed to overlay_xxxx.apk to work with the script download download the non root version): https://www.reddit.com/r/WearOS/comments/9n0mfa/method_for_setting_custom_accent_color_clockwork/ 

# Usage
1. git clone the repo ( optional download the resourses )
2. cd and run ticwatch_all_in_one.sh
You will be presented with a colourful menu that currently looks like the following.

Some options need to be executed from bootloader I have marked these with ( from bootloader ).

Others need to be executed from the OS since they use adb these are marked with ( from os ( adb ) )
```
##############################################################################################################################
#                                                                                                                            #
#                                                TicWatch Bloat Remover + Extra                                              #
#                                                     By Terminal_Heat_Sink                                                  #
##############################################################################################################################

Press 1 to remove all bloat. This will delete unnecessary apps and the following folders Alarms Download Movies Music Notifica
tions Pictures Podcasts Ringtones DCIM

Press 2 to restore all deleted apps. This is needed if you are pairing a new phone with the watch.

Press 3 to connect a new phone to your watch without resetting ( make sure to run 2 before hand if you debloated before as you
won't be able to pair )

Press 4 to enable mtp ( file transfer between pc and watch (just like your phone) )

Press 5 to start usb debugging for ticwatch normal starting method doesn't work

Press 6 to flash factory images ( from bootloader )

Press 7 to flash twrp ( from bootloader )

Press 8 to root ( from os ( adb ) )

Press b toggle bluetooth on watch

Press w toggle wifi on watch (currently not working)

Press l toggle location on watch (currently not working)

Press m launch magisk on watch ( handy so you dont need to search for it in drawer )

Press i hardware info ( battery,wifi,cpu,ram,rom,processes )

Press r reboot to recovery ( TWRP )

Press f reboot to bootloader ( fastboot )

Press s shutdown

Press a change accent colour ( from os ( adb ) )

Press t tips ( rooting,twrp backup,change ui accent colour )

Press e to Exit this script
```
