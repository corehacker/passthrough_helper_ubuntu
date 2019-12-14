#!/bin/bash

# Source: http://vfio.blogspot.com/2015/05/


# Entry: /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/boot_vga
# GPU:   /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0
# AUDIO: /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.1
# Entry: /sys/devices/pci0000:00/0000:00:01.1/0000:02:00.0/boot_vga
# GPU:   /sys/devices/pci0000:00/0000:00:01.1/0000:02:00.0
# AUDIO: /sys/devices/pci0000:00/0000:00:01.1/0000:02:00.1

PASSTHROUGH_GPUV="0000:01:00.0"
PASSTHROUGH_GPUA="0000:01:00.1"

for i in $(find /sys/devices/pci* -name boot_vga); do
	if [ $(cat $i) -eq 0 ]; then
		GPUV=$(dirname $i)
		GPUA=$(echo $GPUV | sed -e "s/0$/1/")

		BASENAME_GPUV=$(basename $GPUV)
		BASENAME_GPUA=$(basename $GPUA)
		
		if [ "$BASENAME_GPUV" == "$PASSTHROUGH_GPUV" ] && [ "$BASENAME_GPUA" == "$PASSTHROUGH_GPUA" ]; then
			echo "vfio-pci" > $GPUV/driver_override

			if [ -d $GPUA ]; then
				echo "vfio-pci" > $GPUA/driver_override
			fi
			#echo "Entry:$i"
			#echo "GPUV: $BASENAME_GPUV"
			#echo "GPUA: $BASENAME_GPUA"
		fi

	fi
done
modprobe -i vfio-pci
