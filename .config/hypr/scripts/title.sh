#!/bin/bash
IMAGE_PATH="/tmp/cover"

# Download the image (replace <URL> with the actual URL)
curl -s -o "$IMAGE_PATH" $(playerctl metadata --format '{{ mpris:artUrl }}')

# Detect the file type
FILE_TYPE=$(file --mime-type -b "$IMAGE_PATH")

# Convert to JPEG if necessary
if [[ "$FILE_TYPE" != "image/jpeg" ]]; then
    mv "$IMAGE_PATH" "${IMAGE_PATH}.tmp"  # Rename the original file
    convert "${IMAGE_PATH}.tmp" "$IMAGE_PATH.jpeg"  # Convert to JPEG
    rm "${IMAGE_PATH}.tmp"  # Remove the temporary file
    IMAGE_PATH="$IMAGE_PATH.jpeg"  # Update the path to the new JPEG file
fi

# Ensure the final file is named /tmp/cover.jpeg
mv "$IMAGE_PATH" "/tmp/cover.jpeg"

# truncate title to 30 characters and add ellipsis if longer
playerctl metadata --format '{{ title }}' | cut -c1-45 | awk '{if(length($0)>40) print substr($0,1,40) "..."; else print $0}'