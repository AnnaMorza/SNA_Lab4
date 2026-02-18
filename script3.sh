#!/bin/bash

# COLORS
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' #No color

#FUNCTION FOR HEADER
print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════${NC}"
    echo -e "${GREEN}► $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
}

#FUNCTION FOR PRINTING INFORMATION
print_info() {
    echo -e "${CYAN}$1:${NC} $2"
}

#FUNCTION FOR PRINTING WARNINGS
print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

#FUNCTION 1: INFORMATION ABOUT KERNEL AND ARCHITECTURE
kernel_info() {
    print_header "KERNEL INFORMATION"
    
    KERNEL_NAME=$(uname -s)
    KERNEL_VERSION=$(uname -r)
    ARCH=$(uname -m)
    
    print_info "Kernel name" "$KERNEL_NAME"
    print_info "Kernel version" "$KERNEL_VERSION"
    print_info "System architecture" "$ARCH"
}

#FUNCTION 2: USERS INFORMATION
user_info() {
    print_header "LOGGED IN USERS"
    
    if [ -z "$(who -u)" ]; then
        print_warning "No users currently logged in"
    else
        who -u | while read user line time pid idle comment; do
            PROCESS=$(ps -p $pid -o comm= 2>/dev/null || echo "unknown")
            echo -e "${GREEN}$user${NC} logged in at ${YELLOW}$time${NC} (PID: $pid)"
        done
    fi
}

#FUNCTION 3: UEFI CHECKING
efi_check() {
    print_header "EFI STATUS"
    
    if [ -d /sys/firmware/efi ]; then
        echo -e "${GREEN}✓ EFI is enabled (UEFI mode)${NC}"
        

        if [ -f /sys/firmware/efi/fw_platform_size ]; then
            EFI_BITS=$(cat /sys/firmware/efi/fw_platform_size)
            print_info "EFI architecture" "${EFI_BITS}-bit"
        fi
    else
        echo -e "${YELLOW}✗ EFI is NOT enabled (Legacy BIOS mode)${NC}"
    fi
}

#FUNCTION 4: BLOCK DEVICE
block_devices() {
    print_header "BLOCK DEVICES"
    
    echo -e "${CYAN}Device       Size  Type  Mountpoint${NC}"
    echo "----------------------------------------"
    
    lsblk -o NAME,SIZE,TYPE,MOUNTPOINT | grep -v "loop" | while read line; do
        if [[ $line == *"disk"* ]] || [[ $line == *"part"* ]]; then

            DEVICE=$(echo $line | awk '{print $1}')
            if [ -d /sys/block/$DEVICE/partition ]; then
                if gdisk -l /dev/$DEVICE 2>/dev/null | grep -q "GPT"; then
                    echo -e "$line ${GREEN}*${NC} (GPT)"
                else
                    echo "$line"
                fi
            else
                echo "$line"
            fi
        fi
    done
}

#FUNCTION 5 BOOT DEVICE
boot_device() {
    print_header "FIRST BOOT DEVICE"
    
    if command -v efibootmgr &> /dev/null; then

        BOOTORDER=$(efibootmgr 2>/dev/null | grep "BootOrder" | cut -d: -f2 | tr -d ' ')
        FIRST_BOOT=$(efibootmgr 2>/dev/null | grep "Boot${BOOTORDER:0:4}" | cut -d* -f2-)
        
        if [ ! -z "$FIRST_BOOT" ]; then
            print_info "First boot device (UEFI)" "$FIRST_BOOT"
        else

            BOOT_DEVICE=$(df / | tail -1 | awk '{print $1}')
            print_info "Root filesystem device" "$BOOT_DEVICE"
            print_warning "Could not determine UEFI boot order"
        fi
    else

        if [ -f /boot/grub/grub.cfg ]; then
            DEFAULT_GRUB=$(grep "set default=" /boot/grub/grub.cfg | head -1)
            print_info "GRUB default entry" "$DEFAULT_GRUB"
        fi
        BOOT_DEVICE=$(df / | tail -1 | awk '{print $1}')
        print_info "Root filesystem device" "$BOOT_DEVICE"
        print_warning "efibootmgr not available (Legacy BIOS or missing package)"
    fi
}

#MAIN FUNCTION
main() {
    echo -e "${GREEN}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║             SYSTEM INFORMATION               ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════╝${NC}"
    
    kernel_info
    user_info
    efi_check
    block_devices
    boot_device
    
    echo -e "\n${GREEN}✓ System check completed at $(date)${NC}"
}

#MAIN FUNCTION RUN
main

exit 0

