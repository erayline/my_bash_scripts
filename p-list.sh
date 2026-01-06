#!/bin/bash

# sorted-pdfs.sh
shopt -s nullglob

# 1. Print the Header (so it doesn't get sorted into the files)
echo "Pages | Filename"
echo "------+------------------------"

# 2. The Data Stream
# We group the loop in a subshell or block so the entire output is piped to sort
(
    for file in *.pdf; do
        # Extract page count
        pages=$(mdls -name kMDItemNumberOfPages -raw "$file")

        # Handle unindexed files by assigning '0' or '000' to ensure they sort predictability
        # or keep "N/A" (Note: sort -n treats non-digits as 0)
        if [[ "$pages" == "(null)" ]]; then
            pages="0"
        fi

        # Print raw format
        printf "%5s | %s\n" "$pages" "$file"
    done
) | sort -n  # Pipe to sort: -r (reverse/descending), -n (numeric)
