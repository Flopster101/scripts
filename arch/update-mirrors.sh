#!/bin/bash

# Uses the rate-mirror tool to fetch some repos. All in the name of convenience.
# https://github.com/westandskif/rate-mirrors

# Variables
ARCH_MIRRORLIST="/etc/pacman.d/mirrorlist"
CHAOTIC_MIRRORLIST="/etc/pacman.d/chaotic-mirrorlist"
ENDEAVOUR_MIRRORLIST="/etc/pacman.d/endeavouros-mirrorlist"
TMP_DIR="/tmp"
PRE_INIT_SUDO=1
RANK_ARCH=1
RANK_CHAOTIC=1
RANK_ENDEAVOUR=1

# Check if rate-mirrors is installed first.
if ! command -v rate-mirrors > /dev/null; then
    printf "Error! rate-mirrors not installed.\n" 
    exit 1
fi

# Preinitialize sudo session? This means the user won't be asked for a password when trying to copy the mirrorlist.
# This assumes the credential cache is enabled. 
if [ $PRE_INIT_SUDO = 1 ]; then
    sudo true   
fi

# Arch
if [ $RANK_ARCH = 1 ]; then
    printf "\nBegin ranking mirrors for ArchLinux...\n\n"
    rate-mirrors --save "$TMP_DIR/mirrorlist" arch
    sudo cp -f $TMP_DIR/mirrorlist $ARCH_MIRRORLIST
    printf "\nArchLinux mirrors ranked and saved to %s\n" "$ARCH_MIRRORLIST!"
    ## Delete the temporary mirrorlist.
    rm -f "$TMP/mirrorlist" 
fi

# Chaotic
if [ $RANK_CHAOTIC = 1 ]; then
    printf "\nBegin ranking mirrors for Chaotic-AUR...\n\n"
    rate-mirrors --save "$TMP_DIR/chaotic-mirrorlist" chaotic-aur
    sudo cp -f $TMP_DIR/chaotic-mirrorlist $CHAOTIC_MIRRORLIST
    printf "\nChaotic-AUR mirrors ranked and saved to %s\n" "$CHAOTIC_MIRRORLIST!"
    ## Delete the temporary mirrorlist.
    rm -f "$TMP/chaotic-mirrorlist" 
fi

# EndeavourOS
if [ $RANK_ENDEAVOUR = 1 ]; then
    printf "\nBegin ranking mirrors for EndeavourOS...\n\n"
    rate-mirrors --save "$TMP_DIR/endeavouros-mirrorlist" endeavouros
    sudo cp -f $TMP_DIR/endeavouros-mirrorlist $ENDEAVOUR_MIRRORLIST
    printf "\nEndeavourOS mirrors ranked and saved to %s\n" "$ENDEAVOUR_MIRRORLIST!"
    ## Delete the temporary mirrorlist.
    rm -f "$TMP/endeavouros-mirrorlist" 
fi
