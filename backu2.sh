#!/bin/bash

DEVICES="$(lsblk -l -p -o name,mountpoint| grep /media)"     
#-l=list -p=searching all path -o=outpit only name and mount grep/media=only external devices

COUNT=0
for i in $DEVICES
do
	if [ $(($COUNT%2)) -eq 0 ]	#-eq  is equalto operator,    2o/p, 1required,i.e name
	then	
		echo $((( ($COUNT+1)/2) + 1)) - $i	#index for every devices
	fi	
	((COUNT++))
done

echo "Enter device number to backup:"

read CHOICE

((COUNT--))	#to get it back
if (($CHOICE > $COUNT)) || (($CHOICE < 1))
then
	echo "Invalid Input"	
fi

COUNT=0
for i in $DEVICES
do
	if [ $(($COUNT%2)) -eq 1 ]
	then
		ORIG=$i		#copying device path to orig
		$(cp -r $ORIG ./backup)
		break
	fi
	((COUNT++))
done

#$(tar -czf backup.tar.gz backup)	

echo "Enter password for backup:"

read ZPASS

$(zip -P $ZPASS -r backup.zip backup > /dev/null)	#r=recursive
$(rm -rf backup) #rm remove, -rf= remove by force, removed that folder
