#!/bin/bash
MPC="mpc -p 6660"
MUSIC_DIR="/TheVault/.mpd/library"
FILENAME=""

width=370
height=361


while :; do
    CURRENT_FILE=$($MPC current -f "%file%")
    CURRENT_DIR=$(dirname "$CURRENT_FILE")

    # Check for coverart in FLAC metadata first

    METADATA_COVER=$(metaflac --list $MUSIC_DIR/"$CURRENT_FILE" | grep "Cover (front)")

    if [[ -n $METADATA_COVER ]]; then
        FILENAME="/tmp/tmuxic-front-cover"
        metaflac --export-picture-to=$FILENAME $MUSIC_DIR/"$CURRENT_FILE"
    fi

    if [[ -z $FILENAME ]]; then
        FILENAME=$(find $MUSIC_DIR/"$CURRENT_DIR" -name "*[Ff]ront*[png|jpg|bmp]")
        if [[ -z $FILENAME ]]; then
            FILENAME=$(find $MUSIC_DIR/"$CURRENT_DIR" -name "*[Cc]over*[png|jpg|bmp]")
            if [[ -z $FILENAME ]]; then
                FILENAME=$(find $MUSIC_DIR/"$CURRENT_DIR" -name "*[Ff]older*[png|jpg|bmp]")
            fi
        fi

        if [[ -z $FILENAME ]]; then
            FILENAME="/home/rolf/pictures/everything-is-shit-mindre.png"
        fi
    fi

    w3m_command="0;1;0;0;$width;$height;;;;;""$FILENAME""\n4;\n3;"
    echo -e $w3m_command | /usr/lib/w3m/w3mimgdisplay

    $MPC idle player update
    clear
done
