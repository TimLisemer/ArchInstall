#!/bin/sh
CommanderProPath=$(sudo find /sys/devices/ -name 0003:1B1C:0C10.*)
echo $CommanderProPath > CommanderProPath

prefix="/sys/"
CommanderProPath=${CommanderProPath#"$prefix"}


echo -n "$(cat fancontrol_begin)" > fancontrol_new
echo $CommanderProPath >> fancontrol_new
cat fancontrol_end >> fancontrol_new

sudo cp fancontrol_new /etc/fancontrol

sudo systemctl enable fancontrol --now
