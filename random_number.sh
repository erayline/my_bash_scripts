#!/bin/bash

# ==============================================================================
# Script Name: randgen.sh
# Description: Generates N random 2-digit integers (10-99).
# Algorithm:   Leverages BSD 'jot' for uniform distribution and high entropy.
# ==============================================================================

# 1. Input Validation: Ensure a valid integer is provided.
if [[ -z "$1" ]] || ! [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "Error: Please provide a valid positive integer as an argument."
    echo "Usage: ./randgen.sh <count>"
    exit 1
fi

COUNT="$1"
MIN=10
MAX=99

# 2. Generation Logic (macOS/BSD specific)
# 'jot' parameters:
# -r : Generate random data (instead of sequential).
# $COUNT : The number of items to generate.
# $MIN : The lower bound (inclusive).
# $MAX : The upper bound (inclusive).

jot -r "$COUNT" "$MIN" "$MAX" 2>/dev/null

# Fallback for non-BSD environments (e.g., Linux without jot)
if [[ $? -ne 0 ]]; then
    echo "System 'jot' utility not found. Falling back to /dev/urandom..."
    for ((i=0; i<COUNT; i++)); do
        # Extract 2 bytes from /dev/urandom, convert to unsigned int.
        # Use modulo arithmetic to map to range 0-89, then add 10.
        # Note: Simple modulo introduces negligible bias for this range.
        val=$(od -An -N2 -tu2 /dev/urandom | tr -d ' ')
        echo $(( (val % 90) + 10 ))
    done
fi
