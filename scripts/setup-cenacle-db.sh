#!/usr/bin/env bash
# ==============================================================================
# Cenacle Reflexology – Automated Database Setup Script
# ==============================================================================
# Usage:
#   ./scripts/setup-cenacle-db.sh [db_name] [db_user] [db_password] [db_host]
#
# Defaults:
#   db_name:     cenacle_booking
#   db_user:     root
#   db_password: (empty or prompted)
#   db_host:     localhost
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
SCHEMA_DIR="${ROOT_DIR}/database_schema"

DB_NAME="${1:-cenacle_booking}"
DB_USER="${2:-root}"
DB_PASS="${3:-}"
DB_HOST="${4:-localhost}"

# Check whether mysql or mariadb client is installed
if command -v mariadb >/dev/null 2>&1; then
    CLIENT_BIN="mariadb"
elif command -v mysql >/dev/null 2>&1; then
    CLIENT_BIN="mysql"
else
    echo "Error: Neither 'mariadb' nor 'mysql' client command is installed on your system."
    echo "On Arch Linux, run: sudo pacman -S mariadb-clients"
    echo "Or run with Docker: sudo systemctl start docker && ./scripts/run-cenacle-docker.sh"
    exit 1
fi

MYSQL_CMD="${CLIENT_BIN} -h ${DB_HOST} -u ${DB_USER}"
if [ -n "${DB_PASS}" ]; then
    MYSQL_CMD="${MYSQL_CMD} -p${DB_PASS}"
fi

echo "=========================================================="
echo " Initializing Cenacle Reflexology Database"
echo " Target Database: ${DB_NAME}"
echo " Host:            ${DB_HOST}"
echo " User:            ${DB_USER}"
echo "=========================================================="

# 1. Create database if it does not exist
echo "Step 1/4: Ensuring database exists..."
${MYSQL_CMD} -e "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# 2. Apply Base Schema
echo "Step 2/4: Applying base schema (create-schema.sql)..."
${MYSQL_CMD} "${DB_NAME}" < "${SCHEMA_DIR}/create-schema.sql"

# 3. Apply all version upgrades in order (2.1 through 4.0)
echo "Step 3/4: Applying version upgrades (2.1 through 4.0 in proper schema -> data order)..."
VERSIONS=$(find "${SCHEMA_DIR}/upgrades/" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort -V)
for v in $VERSIONS; do
    for f in schema.sql data.sql; do
        UPGRADE_FILE="${SCHEMA_DIR}/upgrades/${v}/${f}"
        if [ -f "${UPGRADE_FILE}" ]; then
            echo "  -> Applying ${v}/${f}..."
            ${MYSQL_CMD} "${DB_NAME}" < "${UPGRADE_FILE}"
        fi
    done
done

# 4. Apply Cenacle Configuration and Seed Data
echo "Step 4/4: Seeding Cenacle configuration, units, and treatments..."
${MYSQL_CMD} "${DB_NAME}" < "${SCHEMA_DIR}/cenacle-setup.sql"

echo ""
echo "=========================================================="
echo " Cenacle Database Setup Complete!"
echo " - 6 Chairs & 1 Massage Bed provisioned"
echo " - Hours set to 14:30–02:30 (Mon–Sat) & 16:00–02:30 (Sun)"
echo " - Admin User: cenacle.admin / cenacle123"
echo "=========================================================="

