#!/bin/bash

# disk_cleanup.sh - Simple Disk Cleanup Utility
# Usage: sudo ./disk_cleanup.sh

echo "=== Starting Disk Cleanup ==="

# Confirm running as root
if [[ $EUID -ne 0 ]]; then
   echo "❌ Please run as root (sudo)." 
   exit 1
fi

# Clean apt cache
echo "🧹 Cleaning APT cache..."
apt-get clean

# Remove old kernels (Debian/Ubuntu)
echo "🧹 Removing old kernels..."
dpkg -l 'linux-image-*' | grep ^ii | awk '{print $2}' | grep -v $(uname -r) | xargs apt-get -y purge

# Clean journal logs (systemd)
echo "🧹 Cleaning systemd journal logs..."
journalctl --vacuum-time=7d

# Clean thumbnail cache (for desktop environments)
echo "🧹 Cleaning user thumbnail cache..."
rm -rf /home/*/.cache/thumbnails/*

# Remove orphaned packages
echo "🧹 Removing orphaned packages..."
apt-get -y autoremove

# Empty trash
echo "🧹 Emptying user trash folders..."
for user in /home/*; do
    rm -rf "$user/.local/share/Trash/files/"*
done

# Display disk usage after cleanup
echo "✅ Cleanup complete. Disk usage:"
df -h