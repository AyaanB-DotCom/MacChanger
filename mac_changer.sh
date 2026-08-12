#!/bin/bash

INTERFACE="eth0"
INTERVAL=60
COUNT=0
ORIGINAL_MAC=""
CURRENT_MAC=""
declare -a MAC_HISTORY

banner() {
cat << "EOF"
 __  __    _    ____   ____ _   _    _    _   _  ____ _____ ____  
|  \/  |  / \  / ___| / ___| | | |  / \  | \ | |/ ___| ____|  _ \ 
| |\/| | / _ \| |     | |   | |_| | / _ \ |  \| | |  _|  _| | |_) |
| |  | |/ ___ \ |___  | |___|  _  |/ ___ \| |\  | |_| | |___|  _ < 
|_|  |_/_/   \_\____|  \____|_| |_/_/   \_\_| \_|\____|_____|_| \_\

              [ MAC ADDRESS ROTATOR - eth0 ]
EOF
}

get_mac() {
    ip link show "$INTERFACE" | awk '/ether/ {print $2}'
}

restore_original() {
    tput cnorm
    echo
    echo "  Restoring original MAC address ($ORIGINAL_MAC)..."
    sudo ip link set "$INTERFACE" down
    sudo ip link set "$INTERFACE" address "$ORIGINAL_MAC"
    sudo ip link set "$INTERFACE" up
    echo "  Done. Current MAC: $(get_mac)"
    echo
    exit 0
}

trap 'restore_original' INT TERM

sudo -v

ORIGINAL_MAC=$(get_mac)

tput civis

while true; do
    clear
    banner
    echo
    echo "  Interface     : $INTERFACE"
    echo "  Interval      : ${INTERVAL}s"
    echo "  Rotations     : $COUNT"
    echo "  Original MAC  : $ORIGINAL_MAC"
    echo

    sudo macchanger -r "$INTERFACE" > /dev/null
    CURRENT_MAC=$(get_mac)
    MAC_HISTORY+=("$CURRENT_MAC")
    COUNT=$((COUNT + 1))

    echo "  Current MAC   : $CURRENT_MAC"
    echo

    if [ "${#MAC_HISTORY[@]}" -gt 1 ]; then
        echo "  MAC history:"
        for mac in "${MAC_HISTORY[@]}"; do
            if [ "$mac" == "$CURRENT_MAC" ]; then
                echo "    - $mac"
            else
                echo "    - $mac  [expired]"
            fi
        done
        echo
    fi

    SECONDS=0
    while [ "$SECONDS" -lt "$INTERVAL" ]; do
        REMAINING=$(( INTERVAL - SECONDS ))
        printf "\r  next rotation in %2ds... " "$REMAINING"
        sleep 1
    done
    echo
done
