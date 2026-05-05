#!/bin/bash
# Script #2 — service_restart.sh
# Checks if a service is running. Restarts it if not. Logs every action.
# Usage: ./service_restart.sh nginx

SERVICE="${1:-nginx}"           // use arg $1 if given, else default to nginx
LOG_FILE="/var/log/service_monitor.log"
NOW=$(date '+%Y-%m-%d %H:%M:%S')

# Check if service is running using pgrep
pgrep -x "$SERVICE" > /dev/null 2>&1

if [ $? -eq 0 ]; then
  # Exit code 0 = process found = service is running
  echo "[$NOW] OK: $SERVICE is running" | tee -a "$LOG_FILE"
else
  # Process not found = service is down — restart it
  echo "[$NOW] ALERT: $SERVICE is DOWN — attempting restart..." | tee -a "$LOG_FILE"

  systemctl restart "$SERVICE"

  if [ $? -eq 0 ]; then
    echo "[$NOW] SUCCESS: $SERVICE restarted successfully" | tee -a "$LOG_FILE"
  else
    echo "[$NOW] FAILURE: $SERVICE restart FAILED — manual intervention needed" | tee -a "$LOG_FILE"
    exit 1       // non-zero exit = failure (cron/pipelines detect this)
  fi
fi 
