#!/bin/bash

# EINGABEN
#---------------------------------

MIN_LONG=1200         # Ziellänge der längeren Seite
MIN_SHORT=900         # Ziellänge der kürzeren Seite
Q=95                  # JPG-Qualität

#---------------------------------

# Ziel: Fläche des Bildes in Pixel
TARGET_AREA=$((MIN_LONG * MIN_SHORT))


# Finder-Dialog zur Ordnerauswahl
SOURCE=$(osascript -e 'POSIX path of (choose folder with prompt "Ordner mit Bilddateien auswählen")')

[ -z "$SOURCE" ] && exit

OUT="${SOURCE}/_OUTPUT (skaliert)"
SMALL="${SOURCE}/_Zu klein (unbearbeitet)"

mkdir -p "$OUT"
mkdir -p "$SMALL"

count=0
smallcount=0
current=0

shopt -s nullglob nocaseglob

FILES=(
    "$SOURCE"/*.jpg
    "$SOURCE"/*.jpeg
    "$SOURCE"/*.png
    "$SOURCE"/*.gif
    "$SOURCE"/*.tif
    "$SOURCE"/*.tiff
    "$SOURCE"/*.bmp
)

TOTAL=${#FILES[@]}

if (( TOTAL == 0 )); then
    echo "Keine Bilddateien gefunden."
    exit
fi

draw_progress() {
    local CURRENT=$1
    local TOTAL=$2

    local WIDTH=30
    local FILLED=$(( CURRENT * WIDTH / TOTAL ))
    local EMPTY=$(( WIDTH - FILLED ))

    BAR=$(printf "%${FILLED}s" | tr ' ' '█')
    SPACE=$(printf "%${EMPTY}s")

    PERCENT=$(( CURRENT * 100 / TOTAL ))

    printf "\r[%s%s] %3d%% (%d/%d)" \
        "$BAR" "$SPACE" "$PERCENT" "$CURRENT" "$TOTAL"
}

for FILE in "${FILES[@]}"
do
    ((current++))

    WIDTH=$(magick identify -format "%w" "$FILE")
    HEIGHT=$(magick identify -format "%h" "$FILE")

    if (( WIDTH >= HEIGHT )); then
        LONGSIDE=$WIDTH
        SHORTSIDE=$HEIGHT
    else
        LONGSIDE=$HEIGHT
        SHORTSIDE=$WIDTH
    fi

    NAME=$(basename "$FILE")
    BASENAME="${NAME%.*}.jpg"

    # Qualitätsfilter
    if (( LONGSIDE < MIN_LONG && SHORTSIDE < MIN_SHORT )); then
        cp "$FILE" "$SMALL/$NAME"
        ((smallcount++))
        draw_progress "$current" "$TOTAL"
        continue
    fi

    # Seitenverhältnis
    RATIO=$(awk -v w="$WIDTH" -v h="$HEIGHT" 'BEGIN{print w/h}')

    # Zielbreite und -höhe für konstante Fläche
    NEW_W=$(awk -v A="$TARGET_AREA" -v R="$RATIO" \
        'BEGIN{printf("%d",sqrt(A*R)+0.5)}')

    NEW_H=$(awk -v A="$TARGET_AREA" -v R="$RATIO" \
        'BEGIN{printf("%d",sqrt(A/R)+0.5)}')

    magick "$FILE" \
        -auto-orient \
        -colorspace sRGB \
        -resize "${NEW_W}x${NEW_H}!" \
        -strip \
        -quality $Q \
        "$OUT/$BASENAME"

    ((count++))
    draw_progress "$current" "$TOTAL"
done

echo
echo
echo "======================================="
echo "Fertig!"
echo
echo "Skaliert: $count"
echo "Zu klein: $smallcount"
echo "Gesamt  : $TOTAL"
echo
echo "Ausgabe:"
echo "$OUT"
echo "======================================="
echo
echo