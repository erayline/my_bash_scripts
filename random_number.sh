#!/bin/bash

# Validate that the input is a non-empty string composed solely of digits.
if [[ -z "$1" ]] || ! [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "Error: Please specify the quantity of integers to generate."
    exit 1
fi

# Generate random integers (10-99) using BSD 'jot'.
# -r      : Generate random data (utilizing arc4random for high entropy).
# -s " "  : Use a space as the separator/delimiter between numbers instead of a newline.
# $1      : The quantity of numbers to generate.
# 10 99   : The lower and upper bounds (inclusive).
# ; echo  : Appends a final newline character to ensure the terminal prompt resets correctly.

jot -r -s " " "$1" 10 99; echo
