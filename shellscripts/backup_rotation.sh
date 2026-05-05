#!/bin/bash

# ==============================================================================
# Script Name: backup_rotation.sh
# Description: Creates a compressed backup of a directory and rotates old backups.
# Usage: ./backup_rotation.sh <source_directory> <backup_destination>
# ==============================================================================

set -euo pipefail

# --- Configuration ---
RETENTION_DAYS=7
DATE_FORMAT=$(date '+%Y-%m-%d_%H-%M-%S')

# --- Helper Functions ---
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

error_exit() {
    echo "[ERROR] $1" >&2
    exit 1
}

# --- Validation ---
if [ "$#" -ne 2 ]; then
    error_exit "Usage: $0 <source_directory> <backup_destination>"
fi

SOURCE_DIR="$1"
BACKUP_DEST="$2"

if [ ! -d "$SOURCE_DIR" ]; then
    error_exit "Source directory '$SOURCE_DIR' does not exist."
fi

# Ensure backup destination exists
mkdir -p "$BACKUP_DEST"

# --- Create Backup ---
BACKUP_FILENAME="backup_$(basename "$SOURCE_DIR")_${DATE_FORMAT}.tar.gz"
BACKUP_PATH="${BACKUP_DEST}/${BACKUP_FILENAME}"

log "Starting backup of '$SOURCE_DIR' to '$BACKUP_PATH'..."

# Create the compressed archive
tar -czf "$BACKUP_PATH" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")" || error_exit "Failed to create tar archive."

log "Backup completed successfully: $BACKUP_FILENAME"

# --- Rotate Old Backups ---
log "Applying retention policy: Keeping backups from the last $RETENTION_DAYS days."

# Find and delete backups older than RETENTION_DAYS
# Using find to locate files matching the pattern and older than the threshold
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS find syntax
    find "$BACKUP_DEST" -name "backup_$(basename "$SOURCE_DIR")_*.tar.gz" -mtime +$RETENTION_DAYS -exec rm {} \; -exec echo "Deleted old backup: {}" \;
else
    # Linux find syntax
    find "$BACKUP_DEST" -name "backup_$(basename "$SOURCE_DIR")_*.tar.gz" -type f -mtime +$RETENTION_DAYS -exec rm {} \; -exec echo "Deleted old backup: {}" \;
fi

log "Backup rotation process finished."
