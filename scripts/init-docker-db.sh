#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "=========================================================="
echo " Initializing Cenacle Database inside Docker Container"
echo "=========================================================="

# Check if db container is running
if ! docker compose ps db | grep -q "Up"; then
    echo "Starting db container..."
    docker compose up -d db
    sleep 3
fi

echo "1/3. Resetting and applying base schema (create-schema.sql)..."
docker compose exec -T db mariadb -u cenacle_user -pcenacle_password -e "DROP DATABASE IF EXISTS cenacle_booking; CREATE DATABASE cenacle_booking CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
docker compose exec -T db mariadb -u cenacle_user -pcenacle_password cenacle_booking < database_schema/create-schema.sql

echo "2/3. Applying version upgrades (2.1 to 4.0 in proper schema -> data order)..."
VERSIONS=$(find database_schema/upgrades/ -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort -V)
for v in $VERSIONS; do
    for f in schema.sql data.sql; do
        UPGRADE_FILE="database_schema/upgrades/${v}/${f}"
        if [ -f "${UPGRADE_FILE}" ]; then
            echo "  -> Applying ${v}/${f}..."
            docker compose exec -T db mariadb -u cenacle_user -pcenacle_password cenacle_booking < "${UPGRADE_FILE}"
        fi
    done
done

echo "3/3. Seeding Cenacle layout, 6 chairs + 1 bed, hours, and pricing..."
docker compose exec -T db mariadb -u cenacle_user -pcenacle_password cenacle_booking < database_schema/cenacle-setup.sql

echo ""
echo "=========================================================="
echo " Database initialization complete!"
echo " Refresh http://localhost:8080/ in your browser now."
echo " Login: cenacle.admin / cenacle123"
echo "=========================================================="

