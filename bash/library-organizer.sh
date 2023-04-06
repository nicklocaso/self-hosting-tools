#!/bin/bash

# Archive mode is -rlptgoD (no -A,-X,-U,-N,-H)
# -r recurse into directories
# -l copy symlinks as symlinks
# -p preserve permissions
# -t preserve modification times
# -g preserve group
# -o preserve owner (super-user only)
# --devices preserve device files (super-user only)
# --specials preserve special files

if [ $# -ne 2 ]; then
    echo "Usage: $0 source_folder destination_folder"
    exit 1
fi

SOURCE=$1
DESTINATION=$2
SOURCE_LIST="/tmp/source_list_$(date +%Y%m%d_%H%M%S)"

SSH_LOGIN=$(echo "$DESTINATION" | grep -oE '[^@]+@[^:]+')
CLEAN_DESTINATION=${DESTINATION#$SSH_LOGIN:}

# Define a function to handle ctrl + c
trap_ctrlc() {
    # Print a message to the console
    echo -e "\nTerminated with Ctrl+C"
    # Remove the temporary source files list
    rm "${SOURCE_LIST}"
    # Exit the script with code 130 (128 + SIGINT)
    exit 130
}

# Set a trap for SIGINT signal (ctrl + c)
trap "trap_ctrlc" SIGINT

# Loop through all the image files in the source folder and its subdirectories
# find "${SOURCE}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | while read file; do
find "${SOURCE}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" -o -iname "*.tiff" -o -iname "*.webp" -o -iname "*.heif" -o -iname "*.heic" -o -iname "*.avi" -o -iname "*.mp4" -o -iname "*.mov" -o -iname "*.mkv" -o -iname "*.wmv" -o -iname "*.flv" -o -iname "*.m4v" -o -iname "*.mpeg" -o -iname "*.mpg" -o -iname "*.3gp" -o -iname "*.f4v" \) >"${SOURCE_LIST}"

# Get the total number of files to copy
TOTAL_FILES=$(cat "${SOURCE_LIST}" | wc -l)
PROGRESS=0

# Loop through all the files in the source files list
while read file; do
    # Increment the progress counter
    PROGRESS=$((PROGRESS + 1))

    # Calculate the percentage of files copied and print the progress to the console
    PERCENTAGE=$((PROGRESS * 100 / TOTAL_FILES))
    echo -ne "Copying files: ${PERCENTAGE}%\r"

    # Get the creation time of the file
    created_date=$(date -r "$file" +"%Y/%m/%d")
    # Extract year and month from the date
    year=$(echo "$created_date" | cut -d'/' -f1)
    month=$(echo "$created_date" | cut -d'/' -f2)

    # Copy the file to the destination folder using rsync
    if [ -n "$SSH_LOGIN" ]; then
        rsync -ahP --rsync-path="mkdir -p ${CLEAN_DESTINATION}/${year}/${month}/ && rsync" "$file" "${DESTINATION}/${year}/${month}/"
    else
        mkidr -p "${CLEAN_DESTINATION}/${year}/${month}/"
        rsync -ahP --partial "$file" "${DESTINATION}/${year}/${month}/"
    fi

done <"${SOURCE_LIST}"

rm "${SOURCE_LIST}"

echo "Done organizing images."
