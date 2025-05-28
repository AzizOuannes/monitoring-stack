#!/bin/bash
set -e

# Set backup directory with date
BACKUP_DIR="$HOME/monitoring-backups/$(date +%F)"
mkdir -p "$BACKUP_DIR"

echo "Backing up Grafana data volume..."
docker run --rm -v monitoring-stack_grafana-storage:/data -v "$BACKUP_DIR":/backup busybox tar czf /backup/grafana-data.tar.gz -C /data .

echo "Backing up Prometheus config..."
tar czf "$BACKUP_DIR/prometheus-config.tar.gz" -C ./prometheus .

echo "Backing up Alertmanager config..."
tar czf "$BACKUP_DIR/alertmanager-config.tar.gz" -C ./alertmanager .


echo "Backing up Prometheus data volume..."
docker run --rm -v monitoring-stack_prometheus-data:/data -v "$BACKUP_DIR":/backup busybox tar czf /backup/prometheus-data.tar.gz -C /data .


echo "Backup completed in $BACKUP_DIR"

# Delete backup folders older than 7 days
find $HOME/monitoring-backups/ -maxdepth 1 -type d -mtime +7 -exec rm -rf {} \;
