#!/bin/sh

# Function to check if fancontrol is running
is_fancontrol_running() {
    sleep 1
    if pgrep -x "fancontrol" > /dev/null; then
        return 0  # Program is running
    else
        return 1  # Program is not running
    fi
}

# Function to update fancontrol configuration
update_fancontrol_config() {
    old_string="$1"
    new_string="$2"
    sed -i "s/$old_string/$new_string/g" /etc/fancontrol
}

# Find the Commander Pro path
CommanderProPath=$(find /sys/devices/ -name "0003:1B1C:0C10.*")
echo "$CommanderProPath" > CommanderProPath

prefix="/sys/"
CommanderProPath=${CommanderProPath#"$prefix"}

# Debug echo: Display Commander Pro path
echo "Commander Pro Path: $CommanderProPath"

echo -n "$(cat fancontrol_begin)" > fancontrol_new
echo $CommanderProPath >> fancontrol_new
cat fancontrol_end >> fancontrol_new
cp fancontrol_new /etc/fancontrol
systemctl enable fancontrol --now

# Check if fancontrol is running
echo "Checking if fancontrol is running..."
if is_fancontrol_running; then
    echo "fancontrol is already running."
else
    echo "fancontrol is not running."

    # Change "hwmon3" to "hwmon4" in fancontrol configuration
    echo "Updating fancontrol configuration..."
    update_fancontrol_config "hwmon3" "hwmon4"
    echo "Fancontrol configuration updated."

    # Enable and start fancontrol
    echo "Enabling and starting fancontrol..."
    systemctl enable fancontrol --now
    echo "Fancontrol enabled and started."

    # Check if fancontrol is running after the update
    echo "Checking if fancontrol is running after the update..."
    if is_fancontrol_running; then
        echo "fancontrol is now running."
    else
        echo "fancontrol is still not running."

        # Change "hwmon4" to "hwmon5" in fancontrol configuration
        echo "Updating fancontrol configuration again..."
        update_fancontrol_config "hwmon4" "hwmon5"
        echo "Fancontrol configuration updated."

        # Enable and start fancontrol again
        echo "Enabling and starting fancontrol again..."
        systemctl enable fancontrol --now
        echo "Fancontrol enabled and started."

        # Check if fancontrol is running after the second update
        echo "Checking if fancontrol is running after the second update..."
        if is_fancontrol_running; then
            echo "fancontrol is now running."
        else
            echo "fancontrol is still not running after the second update."
        fi
    fi
fi

