#!/bin/bash

echo "Username: $USER"
echo "Home Directory: $HOME"
echo "Shell: $SHELL"
echo "Hostname: $(hostname)"
echo "IP address: $(hostname -I | awk '{print $1}')"

exit 0
