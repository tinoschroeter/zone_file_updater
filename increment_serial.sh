#!/bin/bash

zone_file="zones/bashops.sh.dns"
now_set_to=$(grep '20[1-9][1-9][0-1][0-9][1-9][0-9][0-9][0-9]' $zone_file|awk '{print $1}')
date_now=$(date +%Y%m%d)

if [ -z $now_set_to ];then
    echo "Could not find zone serial number"
    exit 1
fi
if [[ ${now_set_to:0:8} == $date_now ]];then
    new_serial=$(( $now_set_to + 1 ))
    sed -i "s/$now_set_to/$new_serial/g" $zone_file
    echo "set to $new_serial"
else
    sed -i "s/$now_set_to/${date_now}01/g" $zone_file
    echo "set to ${date_now}01"
fi
