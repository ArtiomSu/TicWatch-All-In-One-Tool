#!/usr/bin/env bash

BASH_COLOR_NC='\033[0m'
BASH_COLOR_Green='\033[0;32m'         
BASH_COLOR_LightBlue='\033[1;34m'    
BASH_COLOR_White='\033[1;37m'
BASH_COLOR_LightGreen='\033[1;32m'
BASH_COLOR_BOLD='\033[0;1m'

term_width=$(tput cols)

function disable_bloat(){
	adb shell pm disable-user --user 0 com.mobvoi.wear.system.aw
	adb shell pm disable-user --user 0 com.google.android.clockwork.flashlight
	#adb shell pm disable-user --user 0 com.google.android.wearable.setupwizard
	adb shell pm disable-user --user 0 com.mobvoi.wear.fitness.aw
	adb shell pm disable-user --user 0 com.google.android.apps.fitness
	adb shell pm disable-user --user 0 com.mobvoi.wear.heartrate.aw
	adb shell pm disable-user --user 0 com.mobvoi.wear.health.aw
	adb shell pm disable-user --user 0 com.mobvoi.companion.aw
	adb shell pm disable-user --user 0 com.mobvoi.wear.social.aw
	adb shell pm disable-user --user 0 com.mobvoi.wear.account.aw
	adb shell pm disable-user --user 0 com.mobvoi.wear.watchface.aw
	adb shell pm disable-user --user 0 com.google.android.clockwork.gestures.tutorial

	adb shell pm uninstall -k --user 0 com.mobvoi.wear.system.aw
	adb shell pm uninstall -k --user 0 com.google.android.clockwork.flashlight
	#adb shell pm uninstall -k --user 0 com.google.android.wearable.setupwizard
	adb shell pm uninstall -k --user 0 com.mobvoi.wear.fitness.aw
	adb shell pm uninstall -k --user 0 com.google.android.apps.fitness
	adb shell pm uninstall -k --user 0 com.mobvoi.wear.heartrate.aw
	adb shell pm uninstall -k --user 0 com.mobvoi.wear.health.aw
	adb shell pm uninstall -k --user 0 com.mobvoi.companion.aw
	adb shell pm uninstall -k --user 0 com.mobvoi.wear.social.aw
	adb shell pm uninstall -k --user 0 com.mobvoi.wear.account.aw
	adb shell pm uninstall -k --user 0 com.mobvoi.wear.watchface.aw
	adb shell pm uninstall -k --user 0 com.google.android.clockwork.gestures.tutorial
	#adb shell rm -r Alarms Download Movies Music Notifications Pictures Podcasts Ringtones DCIM
	adb reboot
}

function enable_bloat(){
	adb shell cmd package install-existing com.mobvoi.wear.system.aw
	adb shell cmd package install-existing com.google.android.clockwork.flashlight
	#adb shell cmd package install-existing com.google.android.wearable.setupwizard
	adb shell cmd package install-existing com.mobvoi.wear.fitness.aw
	adb shell cmd package install-existing com.google.android.apps.fitness
	adb shell cmd package install-existing com.mobvoi.wear.heartrate.aw
	adb shell cmd package install-existing com.mobvoi.wear.health.aw
	adb shell cmd package install-existing com.mobvoi.companion.aw
	adb shell cmd package install-existing com.mobvoi.wear.social.aw
	adb shell cmd package install-existing com.mobvoi.wear.account.aw
	adb shell cmd package install-existing com.mobvoi.wear.watchface.aw
	adb shell cmd package install-existing com.google.android.clockwork.gestures.tutorial
	adb reboot
}

function enable_mtp(){
	adb shell svc usb setFunction mtp true
}

function connect_new_phone(){
	echo "This will allow you to connect your new phone to your watch without resseting the watch."
	echo "Make sure you enabled usb debugging on your watch"
	echo "Make sure bluetooth is turned off on your phones (all of them)"
	echo "Press any key to begin"
	read -n1 n
	adb shell pm clear com.google.android.gms
	adb reboot
	echo "Your watch should now be rebooting if not check usb debugging and make sure you have adb program installed on your computer"
	sleep 1
	echo ""
	echo "Once your watch FULLY reboots press any key to allow the watch to connect to your new phone"
	read -n1 n
	adb shell am start -a android.bluetooth.adapter.action.REQUEST_DISCOVERABLE
	echo "Select the check mark on your watch to allow new phones to connect"
	echo "Now turn on bluetooth on your phone and open up the android wear app and connect the phone as normal"
	echo "Make sure to enable location on your phone also otherwise the android wear app won't see your watch"
}

function toggle_bluetooth(){
	if [[ -z $(adb shell dumpsys bluetooth_manager | grep "enabled: true") ]]; then
		echo "bluetooth looks like it is disabled will enable it now"
		adb shell am start -a android.bluetooth.adapter.action.REQUEST_ENABLE
	else
		echo "bluetooth looks like it is enabled will disable it now"
		adb shell am start -a android.bluetooth.adapter.action.REQUEST_DISABLE
	fi
}

function watch_info(){
	echo -en "${BASH_COLOR_LightGreen}Battery Stats${BASH_COLOR_NC}\n"
	adb shell dumpsys battery
	echo -en "${BASH_COLOR_LightGreen}Wifi Stats${BASH_COLOR_NC}\n"
	adb shell dumpsys wifi | head -n 4
	echo -en "${BASH_COLOR_LightGreen}CPU Load${BASH_COLOR_NC}\n"
	adb shell dumpsys cpuinfo | head -n 1
	echo -en "${BASH_COLOR_LightGreen}RAM Stats${BASH_COLOR_NC}\n"
	adb shell dumpsys meminfo | tail -n 6
	echo -en "${BASH_COLOR_LightGreen}Storage Stats${BASH_COLOR_NC}\n"
	adb shell df -h
	echo -en "${BASH_COLOR_LightGreen}Processes${BASH_COLOR_NC}\n"
	adb shell top -b -n 1 | head -n 20
}

function factory_flash(){
	echo "make sure you are in fastboot mode ( bootloader ) and have the images in the same folder. This will delete everything on your watch and restore it to factory defaults."
	echo "Are you sure you want to do this? y/n"
	read -n 1 ok
	if [[ $ok == "y" ]]; then
		fastboot flash boot boot.img && fastboot reboot-bootloader && sleep 5 && fastboot flash recovery recovery.img && fastboot reboot-bootloader && sleep 5 && fastboot flash system system.img && fastboot reboot-bootloader #&& fastboot format userdata && fastboot format cache
	fi
}

function flash_twrp(){
	echo "make sure you are in fastboot mode ( bootloader ) and have twrp.img in the same folder."
	echo "continue? y/n"
	read -n 1 ok
	if [[ $ok == "y" ]]; then
		fastboot flash recovery twrp.img && fastboot oem reboot-recovery
	fi	
}

function install_magisk(){
	echo "make sure you are in the os and have adb enabled and install twrp beforehand"
	echo "continue? y/n"
	read -n 1 ok
	if [[ $ok == "y" ]]; then
		adb push ./Magisk-v20.4.zip /sdcard/magisk.zip && adb install MagiskManager-v7.5.1.apk && adb reboot recovery && echo "rebooting to twrp. select install and select magisk.zip"
	fi
}

function change_accent_colour(){
	array=($(ls -1 overlay*))
	count=1
	for i in "${array[@]}"; do
		echo -en "$count "
		echo "$i" | cut -d "_" -f2 | cut -d "." -f1
		(( count++ ))
	done

	echo "pick a colour to use as accent enter 1-${#array[@]}"
	echo "Enter c to remove all installed overlays"
	read input
	choicen="${array[ (( input -1 )) ]}"
	if [[ -z $choicen ]]; then
		echo "invalid input returning to menu"
	else
		if [[ $choicen == "c" ]]; then
			adb shell pm list packages -3 | cut -d':' -f2 | tr '\r' ' ' | grep 'turndapage.android.overlay' | xargs -r -n1 -t adb uninstall
		else
			echo "uninstalling any previous installed overlays"
			adb shell pm list packages -3 | cut -d':' -f2 | tr '\r' ' ' | grep 'turndapage.android.overlay' | xargs -r -n1 -t adb uninstall
			name="$(echo "$choicen" | cut -d "_" -f2 | cut -d "." -f1)"
			echo "installing $name"	
			adb install $choicen
			adb shell cmd overlay enable turndapage.android.overlay.$name
			adb shell cmd overlay set-priority highest turndapage.android.overlay.$name
			echo "rebooting to apply changes"
			adb reboot
		fi
	fi
	
}

function install_app_to_system(){
	app_name=""
	adb shell su -c "mount -o rw,remount /system" && \
	adb push $app_name /sdcard/ && \
	adb shell su -c "mv /sdcard/$app_name /system/app/" && \
	adb shell su -c "chmod 644 /system/app/$app_name" && \
	adb reboot
}

function grab_twrp_backup(){
	adb shell su -c "echo 'cd /sdcard/TWRP/BACKUPS \&\& tar -czvf backup.tar.gz \* \&\& mv backup.tar.gz /sdcard/backup.tar.gz' > /sdcard/backup.sh"
	adb shell su -c "sh /sdcard/backup.sh"
	#adb shell su -c "cd /sdcard/TWRP/BACKUPS && tar -czvf backup.tar.gz * && mv backup.tar.gz /sdcard/backup.tar.gz"
}

function tips(){
	echo -e "${BASH_COLOR_LightGreen}Rooting guide${BASH_COLOR_NC}" 
	echo "https://www.youtube.com/watch?v=Jq3aCh5d8ng" 
	echo ""
	echo -e "${BASH_COLOR_LightGreen}Backup twrp backup${BASH_COLOR_NC}"
	echo -en "# retrieve backup \n \
adb shell\n \
su\n \
cd /sdcard/TWRP/BACKUPS\n \
tar -czvf backup.tar.gz M6600TB19Z41\n \
mv backup.tar.gz /sdcard/backup.tar.gz\n \
rm -r /sdcard/TWRP/BACKUPS/M6600TB19Z41\n \

 adb pull /sdcard/backup.tar.gz\n \
adb shell rm /sdcard/backup.tar.gz\n \

# send backup\n \
adb push backup.tar.gz /sdcard/\n \
adb shell\n \
su\n \
cd /sdcard\n \
tar -xzvf backup.tar.gz -C /sdcard/TWRP/BACKUPS\n \
rm backup.tar.gz\n"
	echo ""
	echo -e "${BASH_COLOR_LightGreen}Change UI Accent Colour${BASH_COLOR_NC}"
	echo "https://www.reddit.com/r/WearOS/comments/adflek/tutorial_how_to_change_the_background_color_of/"
	echo "https://www.reddit.com/r/WearOS/comments/9n0mfa/method_for_setting_custom_accent_color_clockwork/"
	echo ""
	echo -e "${BASH_COLOR_LightGreen}Bootloop to twrp${BASH_COLOR_NC}"
	echo "flash the stock recovery by running"
	echo "fastboot flash recovery recovery.img"
	echo "fastboot reboot"
	echo "you will see a red ! after a reboot. Simply hold down the power button until it dissapears and the watch should reboot back into the OS"
}

function print_empty_line(){
	echo -en "\n#"
	for width in $(seq 1 $((term_width -2))); do	
			echo -en " "
	done
	echo -en "#"
}

function print_full_line(){
	for width in $(seq 1 $term_width); do	
			echo -en "#"
	done
}

function print_header(){
	echo -en "\n#"
	for width in $(seq 1 $((term_width/2 - 15))); do	
			echo -en " "
	done
	echo -en "TicWatch Bloat Remover + Extra"
	for width in $(seq 1 $((term_width - ((term_width/2 - 15) + 32) ))); do	
			echo -en " "
	done
	echo -en "#"

	echo -en "\n#"
	for width in $(seq 1 $((term_width/2 - 11))); do	
			echo -en " "
	done
	echo -en " By Terminal_Heat_Sink"
	for width in $(seq 1 $((term_width - ((term_width/2 - 11) + 24) ))); do	
			echo -en " "
	done
	echo -en "#"
}

function print_menu(){
	echo -en "$BASH_COLOR_Green \n"
	print_full_line
	print_empty_line
	print_header
	print_empty_line
	print_full_line
	echo -en "$BASH_COLOR_LightGreen\n"
	echo -en "\nPress ${BASH_COLOR_White}1$BASH_COLOR_LightGreen to remove all bloat. This will delete unnecessary apps and the following folders Alarms Download Movies Music Notifications Pictures Podcasts Ringtones DCIM"
	echo -en "\n\nPress ${BASH_COLOR_White}2$BASH_COLOR_LightGreen to restore all deleted apps. This is needed if you are pairing a new phone with the watch."
	echo -en "\n\nPress ${BASH_COLOR_White}3$BASH_COLOR_LightGreen to connect a new phone to your watch without resetting ( make sure to run 2 before hand if you debloated before as you won't be able to pair )"
	echo -en "\n\nPress ${BASH_COLOR_White}4$BASH_COLOR_LightGreen to enable mtp ( file transfer between pc and watch (just like your phone) )"
	echo -en "\n\nPress ${BASH_COLOR_White}5$BASH_COLOR_LightGreen to start usb debugging for ticwatch normal starting method doesn't work"
	echo -en "\n\nPress ${BASH_COLOR_White}6$BASH_COLOR_LightGreen to flash factory images ( from bootloader )"
	echo -en "\n\nPress ${BASH_COLOR_White}7$BASH_COLOR_LightGreen to flash twrp ( from bootloader )"
	echo -en "\n\nPress ${BASH_COLOR_White}8$BASH_COLOR_LightGreen to root ( from os ( adb ) )"
	echo -en "\n\nPress ${BASH_COLOR_White}b$BASH_COLOR_LightGreen toggle bluetooth on watch"
	echo -en "\n\nPress ${BASH_COLOR_White}w$BASH_COLOR_LightGreen toggle wifi on watch (currently not working)"
	echo -en "\n\nPress ${BASH_COLOR_White}l$BASH_COLOR_LightGreen toggle location on watch (currently not working)"
	echo -en "\n\nPress ${BASH_COLOR_White}m$BASH_COLOR_LightGreen launch magisk on watch ( handy so you dont need to search for it in drawer )"
	echo -en "\n\nPress ${BASH_COLOR_White}i$BASH_COLOR_LightGreen hardware info ( battery,wifi,cpu,ram,rom,processes )"
	echo -en "\n\nPress ${BASH_COLOR_White}r$BASH_COLOR_LightGreen reboot to recovery ( TWRP )"
	echo -en "\n\nPress ${BASH_COLOR_White}f$BASH_COLOR_LightGreen reboot to bootloader ( fastboot )"
	echo -en "\n\nPress ${BASH_COLOR_White}s$BASH_COLOR_LightGreen shutdown"
	echo -en "\n\nPress ${BASH_COLOR_White}a$BASH_COLOR_LightGreen change accent colour ( from os ( adb ) )"
	echo -en "\n\nPress ${BASH_COLOR_White}t$BASH_COLOR_LightGreen tips ( rooting,twrp backup,change ui accent colour )"
	echo -en "\n\nPress ${BASH_COLOR_White}e$BASH_COLOR_LightGreen to Exit this script"
	echo -en "$BASH_COLOR_NC \n"
}



print_menu
choice="0"
while [[ $choice != "e" ]]; do
	read -n1 choice
	echo ""
	print_sub_menu=true

	if [[ $choice == "1" ]]; then
		echo -en "${BASH_COLOR_BOLD}Removing all bloat${BASH_COLOR_NC}\n"
		disable_bloat
	elif [[ $choice == "2" ]]; then
		echo -en "${BASH_COLOR_BOLD}Restoring Deleted Apps${BASH_COLOR_NC}\n"
		enable_bloat
	elif [[ $choice == "3" ]]; then
		connect_new_phone
	elif [[ $choice == "4" ]]; then
		enable_mtp
	elif [[ $choice == "5" ]]; then
		adb kill-server
		sleep 1
		sudo adb usb
	elif [[ $choice == "b" ]]; then
		toggle_bluetooth
	elif [[ $choice == "w" ]]; then
		echo "currently not working"
	elif [[ $choice == "l" ]]; then
		echo "currently not working"		
	elif [[ $choice == "m" ]]; then
		#latest magisk
		#adb shell am start -n com.topjohnwu.magisk/com.topjohnwu.magisk.core.SplashActivity
		adb shell am start -n com.topjohnwu.magisk/a.c
	elif [[ $choice == "r" ]]; then
		adb reboot recovery
	elif [[ $choice == "f" ]]; then
		adb reboot bootloader	
	elif [[ $choice == "s" ]]; then
		adb shell reboot -p
	elif [[ $choice == "i" ]]; then
		watch_info	
	elif [[ $choice == "t" ]]; then
		tips	
	elif [[ $choice == "p" ]]; then
		print_menu	
		print_sub_menu=false
	elif [[ $choice == "e" ]]; then
		echo "Bye Bye"
		print_sub_menu=false
	elif [[ $choice == "6" ]]; then
		factory_flash
	elif [[ $choice == "7" ]]; then
		flash_twrp	
	elif [[ $choice == "8" ]]; then
		install_magisk	
	elif [[ $choice == "a" ]]; then
		change_accent_colour		
	else
		echo -en "Invalid Choice"	
	fi
	if [[ $print_sub_menu == true ]]; then
		echo -en "\n\n${BASH_COLOR_LightGreen}Press ${BASH_COLOR_White}e$BASH_COLOR_LightGreen to Exit this script"
		echo -en "\nPress ${BASH_COLOR_White}p$BASH_COLOR_LightGreen to print the menu again\n$BASH_COLOR_NC"
	fi

done

echo -en "\nCheck out my menu driven watchface ${BASH_COLOR_LightBlue}https://play.google.com/store/apps/details?id=terminalheatsink.nixieface${BASH_COLOR_NC}\n"
