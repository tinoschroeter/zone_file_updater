#!/bin/bash
zone_file="zones/bashops.sh.dns"
now_set_to=$(grep '20[1-9][1-9][0-1][1-9][1-9][0-9][0-9][0-9]' $zone_file|awk '{print $1}')
date_now=$(date +%Y%m%d)
toggle=$(grep 'www ' $zone_file)

if [[ $toggle =~ "CNAME" ]];then
    sed -i "s/$toggle/www                60    IN  A      37.120.163.181/" $zone_file
    echo "CDN disabled"
else
    sed -i "s/$toggle/www                60    IN  CNAME  g2.shared.global.fastly.net./" $zone_file
    echo "CDN enabled"
fi

if [ -z $now_set_to ];then
    echo "Could not find zone serial number"
    exit 1
fi

if [[ ${now_set_to:0:8} == $date_now ]];then
    new_serial=$(( $now_set_to + 1 ))
    sed -i "s/$now_set_to/$new_serial/g" $zone_file
else
    sed -i "s/$now_set_to/${date_now}01/g" $zone_file
fi
