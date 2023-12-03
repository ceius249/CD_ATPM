#!/bin/bash

# setup variable
USER_DIR="/home/$USER"
PASSPHR_FILE="$USER_DIR/passphr"
PASSPHR_CODE="$USER_DIR/passphr_code"
ENCODED_FILE="$USER_DIR/encoded"
CAT_IMG="$USER_DIR/cat_image.jpeg"
FLAG_FILE="$USER_DIR/flag"


# exiftool
## encode to exiftool
base64 "$PASSPHR_FILE" > "$ENCODED_FILE"

## encode to steghide
cat "$PASSPHR_FILE" | grep -oP '(?<=passphrase: )\w+' > "$PASSPHR_CODE" 

# steghide
## passphrase $ENCODED_FILE
## coverfile $CAT_IMG
## embedfile $FLAG_FILE

steghide embed -p "$(cat "$PASSPHR_CODE")" -cf "$CAT_IMG" -ef "$FLAG_FILE"


## add comment to cat_image.jpeg
exiftool "$CAT_IMG" -comment="$(cat "$ENCODED_FILE")" -preserve -overwrite_original -m -q -q

rm $PASSPHR_FILE $ENCODED_FILE $FLAG_FILE $PASSPHR_CODE
