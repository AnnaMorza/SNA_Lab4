#!/bin/bash

BACKUP_DIR="/var/backups"
TIMESTAMP=$(date +"%b_%d_%Y_%H_%M_%S")
BACKUP_FILENAME="home_backup_${TIMESTAMP}.tar.gz"

sudo mkdir -p "$BACKUP_DIR"

sudo tar -czpf "${BACKUP_DIR}/${BACKUP_FILENAME}" "$HOME"

echo "Backup created: ${BACKUP_DIR}/${BACKUP_FILENAME}"
