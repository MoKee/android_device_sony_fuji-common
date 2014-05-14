#!/sbin/busybox sh

main_menu()
{
    exit_mainloop=0

    while  [ "$exit_mainloop" == "0" ]
    do
	/sbin/fbmenu -c select -T "$TITLE" -t "Select Boot Option"  -t "Boot Android" -t "Start Recovery" -t "Reboot" -t "PowerOff" -d 0 -o 3
	    case $? in 
		0) cmd="BOOT";;
		1) cmd="RECOVERY";;
		2) cmd="REBOOT";;
		3) cmd="POWEROFF";;
	    esac

	case "$cmd" in 
	BOOT) busybox echo 1 > /proc/bootsel
            busybox echo '0' > /sys/class/leds/blue/brightness
            busybox echo '0' > /sys/class/leds/red/brightness
            busybox echo '0' > /sys/class/leds/green/brightness
            busybox echo '0' > /sys/class/leds/button-backlight/brightness
            busybox dd if=/dev/graphics/fb1 of=/dev/graphics/fb0
            exit_mainloop=1;;
	RECOVERY) busybox echo 0 > /proc/bootsel
            busybox echo '0' > /sys/class/leds/blue/brightness
            busybox echo '0' > /sys/class/leds/red/brightness
            busybox echo '0' > /sys/class/leds/green/brightness
            busybox echo '0' > /sys/class/leds/button-backlight/brightness
            busybox touch /cache/recovery/boot
            busybox reboot;;
	REBOOT) echo 0 > /proc/bootsel
            busybox reboot;;
	POWEROFF) echo 0 > /proc/bootsel
            busybox halt;;
	esac
    done
}

# Globals
TITLE="Boot Manager v1.0"

# trigger amber LED
busybox echo '200' > /sys/class/leds/blue/brightness
busybox echo '200' > /sys/class/leds/red/brightness
busybox echo '0' > /sys/class/leds/green/brightness
# trigger button-backlight
busybox echo '0' > /sys/class/leds/button-backlight/brightness

main_menu
