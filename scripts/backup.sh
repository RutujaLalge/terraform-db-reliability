#!/usr/bin/env bash
set -euo pipefail

# Config — matches docker-compose.yml
CONTAINER_NAME="hotel_bookings_db"
DB_USER="hotel_admin"
DB_NAME="hotel_bookings_db"
BACKUP_DIR="$(dirname "$0")/../backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/backup_${TIMESTAMP}.sql"

mkdir -p "$BACKUP_DIR"

echo "Checking if container '${CONTAINER_NAME}' is running..."
if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}\$"; then
  echo "ERROR: Container '${CONTAINER_NAME}' is not running. Start it with: docker compose up -d"
  exit 1
fi

echo "Creating backup at ${BACKUP_FILE} ..."
docker exec -t "$CONTAINER_NAME" pg_dump -U "$DB_USER" -d "$DB_NAME" > "$BACKUP_FILE"

echo "Backup complete: ${BACKUP_FILE}"
ls -lh "$BACKUP_FILE"
