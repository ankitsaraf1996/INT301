#!/bin/bash

DEVICES="$(lsblk -l -p -o name,mountpoint| grep /media)"

COUNT=0
for i in $DEVICES
do
	if [ $(($COUNT%2)) -eq 0 ]
	then	
		echo $((( ($COUNT+1)/2) + 1)) - $i
	fi	
	((COUNT++))
done

echo "Enter device number to backup:"

read CHOICE

((COUNT--))
if (($CHOICE > $COUNT)) || (($CHOICE < 1))
then
	echo "Invalid Input"	
fi

COUNT=0
for i in $DEVICES
do
	if [ $(($COUNT%2)) -eq 1 ]
	then
		ORIG=$i
		$(rsync -r $ORIG ./backup)
		break
	fi
	((COUNT++))
done

#$(tar -czf backup.tar.gz backup)

echo "Enter password for backup:"

read ZPASS

$(zip -P $ZPASS -r backup.zip backup > /dev/null)
$(rm -rf backup)
