#!/bin/bash
MPC="mpc -p 6660"
MUSIC_DIR="/TheVault/.mpd/library"
FILENAME=""

width=370
height=361


while :; do
    CURRENT_FILE=$($MPC current -f "%file%")
    CURRENT_DIR=$(dirname "$CURRENT_FILE")

    FILENAME=$(find $MUSIC_DIR/"$CURRENT_DIR" -name "*[Bb]ack*[png|jpg|bmp]")
#    if [[ -z $FILENAME ]]; then
#        FILENAME=$(find $MUSIC_DIR/"$CURRENT_DIR" -name "*[Cc]over*[png|jpg|bmp]")
#        if [[ -z $FILENAME ]]; then
#            FILENAME=$(find $MUSIC_DIR/"$CURRENT_DIR" -name "*[Ff]older*[png|jpg|bmp]")
#        fi
#    fi

    if [[ -z $FILENAME ]]; then
        FILENAME="/home/rolf/pictures/everything-is-shit-mindre.png"
    fi

    w3m_command="0;1;375;0;$width;$height;;;;;""$FILENAME""\n4;\n3;"
    echo -e $w3m_command | /usr/lib/w3m/w3mimgdisplay

    $MPC idle player update
    clear
done
