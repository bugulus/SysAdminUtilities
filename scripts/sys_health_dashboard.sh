#!/bin/bash

# Simple System Health Dashboard
# Make executable with chmod +x sys_health_dashboard.sh

clear
echo "======================="
echo "  System Health Report "
echo "======================="

# Uptime
echo -e "\n Uptime:"
uptime -p

# CPU average load
echo -e "\n CPU Load:"
uptime | awk -F'load average:' '{ print "Load Averages: " $2 }'

# Memory usage
echo -e "\n Memory Usage:"
free -h

# Disk memory usage
echo -e "\n Disk Usage:"
df -hT --total | grep -E 'Filesystem|total'

# Top 5 processes by memory
echo -e "\n Top 5 Memory-Using Processes:"
ps -eo pid,comm,%mem,%cpu --sort=-%mem | head -n 6

# Network info
echo -e "\n IP Addresses:"
ip -brief address show | grep -v "lo"

# Open the ports
echo -e "\n Listening Ports:"
ss -tuln | grep LISTEN

echo -e "\n Health check complete."