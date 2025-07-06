#!/bin/bash
#
# Simple script to generate a full backup of adsb.im data via curl.
# Stores backups in user's home directory and keeps the latest N.
#
# Append port 1099 to BACKUP_URL for Stage2 and leave it out for Micro/Nano feeders.
 
 
# --- Configuration Variables (Edit These) ---
BACKUP_URL="http://BACKUP_URL/backupexecutefull"
MAX_BACKUPS_TO_KEEP=15
BACKUP_DIR_NAME="adsb-backups" # This folder will be created in your home directory if it doesn't exist
# --- End Configuration ---
 
# --- Script Logic (No need to edit below here unless you know what you're doing) ---
set -euo pipefail
 
URL_PREFIX=$(echo "$BACKUP_URL" | awk -F'[/:]' '{print $4}' | cut -d'.' -f1)
 
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
 
FULL_BACKUP_PATH="${HOME}/${BACKUP_DIR_NAME}/${URL_PREFIX}_${TIMESTAMP}.zip"
 
mkdir -p "${HOME}/${BACKUP_DIR_NAME}"
 
curl --fail --output "$FULL_BACKUP_PATH" "$BACKUP_URL"
 
find "${HOME}/${BACKUP_DIR_NAME}" -maxdepth 1 -name "${URL_PREFIX}_*.zip" -type f \
    | xargs -r ls -t \
    | tail -n +$((MAX_BACKUPS_TO_KEEP + 1)) \
    | xargs -r rm --
 
echo "Backup process completed for ${URL_PREFIX}."
