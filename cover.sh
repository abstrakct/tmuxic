#!/bin/bash
MPC="mpc"
MUSIC_DIR="/TheVault/.mpd/library"

width=448
height=480


while :; do
    FILENAME=""
    CURRENT_FILE=$($MPC current -f "%file%")
    CURRENT_DIR=$(dirname "$CURRENT_FILE")

    #echo "Current file is $CURRENT_FILE"
    #echo "Current dir is $CURRENT_DIR"
    # Check for coverart in FLAC metadata first

    if [[ $CURRENT_FILE =~ *.flac ]]; then
        #echo "It is FLAC"
        METADATA_COVER=$(metaflac --list $MUSIC_DIR/"$CURRENT_FILE" | grep "Cover (front)")

        if [[ -n $METADATA_COVER ]]; then
            FILENAME="/tmp/tmuxic-front-cover"
            metaflac --export-picture-to=$FILENAME $MUSIC_DIR/"$CURRENT_FILE"
        elif [[ -z $METADATA_COVER ]]; then 
            FILENAME=""
        fi
    fi

    if [[ -z $FILENAME ]]; then
        #echo "It is not FLAC"
        FILENAME=$(find $MUSIC_DIR/"$CURRENT_DIR" -name "*[Ff]ront*[png|jpg|bmp]")
        if [[ -z $FILENAME ]]; then
            FILENAME=$(find $MUSIC_DIR/"$CURRENT_DIR" -name "*[Cc]over*[png|jpg|bmp]")
            if [[ -z $FILENAME ]]; then
                FILENAME=$(find $MUSIC_DIR/"$CURRENT_DIR" -name "*[Ff]older*[png|jpg|bmp]")
            fi
        fi

        #echo "Filename is $FILENAME"

        if [[ -z $FILENAME ]]; then
            FILENAME="/home/rolf/pictures/everything-is-shit-mindre.png"
        fi

        #echo "Filename is $FILENAME"
    fi

    w3m_command="0;1;0;0;$width;$height;;;;;""$FILENAME""\n4;\n3;"
    echo -e $w3m_command | /usr/lib/w3m/w3mimgdisplay

    $MPC idle player update
    clear
done
