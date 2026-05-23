#!/bin/bash

# Define variables
DATE=$(date +"%Y-%m-%d")
BACKUP_FILE="/tmp/server_backup_$DATE.tar.gz"
SOURCE_DIR="/mnt/usb_vault"
GDRIVE_DEST="gdrive:5. Server Backup"

echo "Starting backup process..."

# 1. Stop the Docker containers safely so files don't change during the backup
sudo docker stop nextcloud_vault homepage glances

# 2. Compress the entire USB vault into a single archive
sudo tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

# 3. Restart the Docker containers immediately
sudo docker start nextcloud_vault homepage glances

# 4. Upload the archive to Google Drive silently
rclone --config /home/tingrongyou/.config/rclone/rclone.conf copy "$BACKUP_FILE" "$GDRIVE_DEST"

# 5. Delete the local archive to save space on the server
sudo rm "$BACKUP_FILE"

echo "Backup complete and uploaded to Google Drive!"
