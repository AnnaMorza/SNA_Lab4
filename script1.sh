#!/bin/bash

echo "Username: $USER"
echo "Home Directory: $HOME"
echo "Shell: $SHELL"
echo "Hostname: $(hostname)"
echo "IP address: $(hostname -I | awk '{print $1}')"

exit 0

# Output
# Username: annamorozova
# Home Directory: /home/annamorozova
# Shell: /bin/bash
# Hostname: Asus
# IP address: 10.181.6.45
