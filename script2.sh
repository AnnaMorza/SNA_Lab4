#!/bin/bash

BACKUP_DIR="/var/backups"
TIMESTAMP=$(date +"%b_%d_%Y_%H_%M_%S")
BACKUP_FILENAME="home_backup_${TIMESTAMP}.tar.gz"

sudo mkdir -p "$BACKUP_DIR"

sudo tar -czpf "${BACKUP_DIR}/${BACKUP_FILENAME}" "$HOME"

echo "Backup created: ${BACKUP_DIR}/${BACKUP_FILENAME}"

# Output:
# [sudo] password for annamorozova: 
# tar: Removing leading `/' from member names
# tar: /home/annamorozova/.cache/ibus/dbus-drsmchlP: socket ignored
# tar: /home/annamorozova/.cache/ibus/dbus-UnrFjAlB: socket ignored
# tar: /home/annamorozova/.cache/ibus/dbus-cKiEWku6: socket ignored
# tar: /home/annamorozova/.cache/ibus/dbus-C1M1YWt0: socket ignored
# tar: /home/annamorozova/.cache/ibus/dbus-cregxV5N: socket ignored
# tar: /home/annamorozova/.cache/ibus/dbus-N3ciSbsP: socket ignored
# tar: /home/annamorozova/.cache/ibus/dbus-r7gW5byD: socket ignored
# tar: /home/annamorozova/.cache/ibus/dbus-nXpgg51x: socket ignored
# tar: /home/annamorozova/.cache/ibus/dbus-WylEGHDO: socket ignored
# tar: /home/annamorozova/.cache/ibus/dbus-73H2C8jp: socket ignored
# tar: /home/annamorozova/.cache/ibus/dbus-r0K6gvfv: socket ignored
# tar: /home/annamorozova/.cache/ibus/dbus-BJN2xuX6: socket ignored
# Backup created: /var/backups/home_backup_Feb_18_2026_20_42_48.tar.gz
