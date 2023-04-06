#!/bin/bash

# Check if the number of arguments is correct
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 DIRECTORY"
    exit 1
fi

# Assign arguments to variables
dir="$1"
output_file="./results.txt"

echo "Starting search for duplicate files in directory $dir ..."

# Create a temporary file to store the md5sum results
tmp_file=$(mktemp)

# Find all files in the specified directory and group them by size
find "$dir" -type f -printf "%s\n" | sort -n | uniq -d | while read size; do
    echo "Processing files with size: $size bytes"
    find "$dir" -type f -size "${size}c" -exec md5sum {} + >>"$tmp_file"
done

# Sort the md5sum results and find duplicates
sort "$tmp_file" | uniq -w32 -dD >"$output_file"

# Remove the temporary file
rm "$tmp_file"

echo "Search completed. Duplicate files have been written to $output_file"
