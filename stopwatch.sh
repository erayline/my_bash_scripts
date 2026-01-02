#!/bin/bash

# --- 1. WINDOW SETUP ( The "Widget" Trick ) ---
# Instantly resize terminal to 3 rows high, 20 columns wide
printf '\e[8;3;20t'
# Clear screen
clear

# --- 2. TERMINAL CONFIGURATION ---
# Save original settings
saved_stty=$(stty -g)
# Set "Non-Blocking" mode (Instant input detection)
stty -icanon min 0 time 0 -echo
# Hide cursor
tput civis

# Cleanup function (Restores window and settings on exit)
cleanup() {
    stty "$saved_stty" # Restore settings
    tput cnorm         # Restore cursor
    # Optional: You can resize it back to a normal size on exit if you want
    # printf '\e[8;24;80t' 
    echo ""
    exit
}
trap cleanup SIGINT SIGTERM

# --- 3. VARIABLES ---
start_time=$(date +%s)
running=true
elapsed=0
paused_at=0

# --- 4. THE LOOP ---
while true; do
    # A. Math
    if $running; then
        current_time=$(date +%s)
        elapsed=$((current_time - start_time))
    fi

    minutes=$((elapsed / 60))
    seconds=$((elapsed % 60))

    # B. Graphics
    # We position the text in the middle of our tiny window
    printf "\r\033[K"
    
    if $running; then
        printf "    %02d:%02d" "$minutes" "$seconds"
    else
        printf "    %02d:%02d (s)" "$minutes" "$seconds"
    fi

    # C. Input (Instant)
    read key

    # Space or 's' to Toggle
    if [[ "$key" == " " || "$key" == "s" ]]; then
        if $running; then
            running=false
            paused_at=$elapsed
        else
            start_time=$(($(date +%s) - paused_at))
            running=true
        fi
    fi

    # Quit
    if [[ "$key" == "q" ]]; then
        cleanup
    fi

    sleep 0.1
done