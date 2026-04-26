#!/bin/bash
# ec2_health_check.sh — monitors CPU, Memory, Disk

# Thresholds — change these as needed
CPU_LIMIT=80
MEM_LIMIT=80
DISK_LIMIT=85

# Get current usage values
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2)}')
MEM=$(free | awk '/Mem/{printf("%.0f"),$3/$2*100}')
DISK=$(df / | awk 'NR==2{print int($5)}')
NOW=$(date '+%Y-%m-%d %H:%M:%S')

# Print current status
echo "[$NOW] EC2 Health Check"
echo "CPU: ${CPU}%  |  Memory: ${MEM}%  |  Disk: ${DISK}%"

# Alert if any threshold breached
if [ $CPU -gt $CPU_LIMIT ]; then
  echo "ALERT: CPU ${CPU}% exceeds limit of ${CPU_LIMIT}%"
fi

if [ $MEM -gt $MEM_LIMIT ]; then
  echo "ALERT: Memory ${MEM}% exceeds limit of ${MEM_LIMIT}%"
fi

if [ $DISK -gt $DISK_LIMIT ]; then
  echo "ALERT: Disk ${DISK}% exceeds limit of ${DISK_LIMIT}%"
fi

echo "--- Done ---"

