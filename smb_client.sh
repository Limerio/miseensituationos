#!/bin/sh

PASSWORD=""
IP_SERVER="192.168.0.1"
$FOLDER=""

sudo mkdir /mnt/$FOLDER
sudo mount -t cifs -o username=Administrateur,password=$PASSWORD //$IP_SERVER/$FOLDER /mnt/$FOLDER