#!/usr/bin/env bash
set -euo pipefail

# Config — matches docker-compose.yml
CONTAINER_NAME="hotel_bookings_db"
DB_USER="hotel_admin"
DB_NAME="hotel_bookings_db"
BACKUP_DIR="$(dirname "$0")/../backups"

# Use the backup file passed as $1, otherwise default to the most recent backup
BACKUP_FILE="${1:-}"
if [ -z "$BACKUP_FILE" ]; then
  BACKUP_FILE=$(ls -t "${BACKUP_DIR}"/backup_*.sql 2>/dev/null | head -n 1)
fi

if [ -z "$BACKUP_FILE" ] || [ ! -f "$BACKUP_FILE" ]; then
  echo "ERROR: No backup file found. Usage: ./scripts/restore.sh [path-to-backup.sql]"
  exit 1
fi

echo "Checking if container '${CONTAINER_NAME}' is running..."
if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}\$"; then
  echo "ERROR: Container '${CONTAINER_NAME}' is not running. Start it with: docker compose up -d"
  exit 1
fi

echo "Restoring from: ${BACKUP_FILE}"
echo "Dropping and recreating database '${DB_NAME}' for a clean restore..."

docker exec -t "$CONTAINER_NAME" psql -U "$DB_USER" -d postgres -c "DROP DATABASE IF EXISTS ${DB_NAME};"
docker exec -t "$CONTAINER_NAME" psql -U "$DB_USER" -d postgres -c "CREATE DATABASE ${DB_NAME};"

echo "Loading backup into fresh database..."
cat "$BACKUP_FILE" | docker exec -i "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME" > /dev/null

echo "Restore complete. Verifying row count..."
docker exec -t "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME" -c "SELECT COUNT(*) AS hotel_bookings_count FROM hotel_bookings;"
docker exec -t "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME" -c "SELECT COUNT(*) AS booking_events_count FROM booking_events;"

echo "If both counts look correct (150 bookings, ~70 events), the restore was successful."
