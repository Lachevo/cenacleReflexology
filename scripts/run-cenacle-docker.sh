#!/usr/bin/env bash
set -e

echo "=========================================================="
echo " Starting Cenacle Reflexology Reservation System (Docker)"
echo "=========================================================="

cd "$(dirname "$0")/.."

# 1. Prepare config/config.php for Docker environment
if [ ! -f "config/config.php" ]; then
    echo "Creating config/config.php from cenacle.config.php..."
    cp config/cenacle.config.php config/config.php

    # Adjust DB host and script.url for containerized environment
    sed -i "s/'hostspec' => 'localhost'/'hostspec' => 'db'/g" config/config.php
    sed -i "s/'cenacle_db_user'/'cenacle_user'/g" config/config.php
    sed -i "s/'password' => ''/'password' => 'cenacle_password'/g" config/config.php
    sed -i "s/'name' => 'cenacle_booking'/'name' => 'cenacle_booking'/g" config/config.php
    sed -i "s/'script.url' => ''/'script.url' => 'http:\/\/localhost:8080\/Web'/g" config/config.php
fi

# Ensure writable cache directory
mkdir -p tpl_c uploads
chmod -R 777 tpl_c uploads

# 2. Build and start containers
echo "Starting containers with Docker Compose..."
docker compose up -d --build

# 3. Ensure Composer dependencies are installed
if [ ! -d "vendor" ] || [ ! -f "vendor/autoload.php" ]; then
    echo "Installing Composer dependencies..."
    docker compose exec -T app composer install --no-dev --prefer-dist --optimize-autoloader || true
fi

# 4. Wait for Database readiness
echo "Waiting for MariaDB to be ready..."
until docker compose exec -T db mariadb-admin ping -u cenacle_user -pcenacle_password --silent; do
    sleep 2
done

# 4. Initialize Database if empty
TABLE_COUNT=$(docker compose exec -T db mariadb -u cenacle_user -pcenacle_password -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'cenacle_booking';" -sN)

if [ "$TABLE_COUNT" -eq "0" ]; then
    echo "Initializing database tables and Cenacle configuration..."
    docker compose exec -T db mariadb -u cenacle_user -pcenacle_password cenacle_booking < database_schema/create-schema.sql
    
    # Run upgrades to bring schema up to 4.0
    for file in $(ls -v database_schema/upgrades/*/*.sql 2>/dev/null); do
        docker compose exec -T db mariadb -u cenacle_user -pcenacle_password cenacle_booking < "$file" 2>/dev/null || true
    done

    # Apply Cenacle seed (7 units, hours, treatments, pricing, colors)
    echo "Applying Cenacle custom seed..."
    docker compose exec -T db mariadb -u cenacle_user -pcenacle_password cenacle_booking < database_schema/cenacle-setup.sql
    echo "Database initialized successfully!"
else
    echo "Database already initialized ($TABLE_COUNT tables found)."
fi

echo ""
echo "=========================================================="
echo " Cenacle Reflexology System is LIVE!"
echo " URL:      http://localhost:8080"
echo " Username: cenacle.admin"
echo " Password: cenacle123"
echo "=========================================================="

