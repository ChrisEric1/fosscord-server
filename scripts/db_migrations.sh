#!/bin/sh

if [ ! -z "$1" ]
then
    FILENAME="$1"
    echo "Using filename: $FILENAME"
else
    read -p "Enter migration filename: " FILENAME
fi

[ -f ".env" ] && (
    mv .env .env.tmp 2>/dev/null
    source .env.tmp 2>/dev/null
)
npm run build clean logerrors pretty-errors

make_migration() {
    echo "Creating migrations for $2"
    mkdir "src/util/migrations/$2" 2>/dev/null
#    npm run build clean logerrors pretty-errors
    THREADS=1 DATABASE="$1" DB_MIGRATE=a npm run start:bundle
    THREADS=1 DATABASE="$1" DB_MIGRATE=a npx typeorm-ts-node-commonjs migration:generate "src/util/migrations/$2/$FILENAME" -d src/util/util/Database.ts -p
    #npm run build clean logerrors pretty-errors
    #THREADS=1 DATABASE="$1" DB_MIGRATE=a npm run start:bundle
}

npm i sqlite3
make_migration "database.db" "sqlite"

[ -z "$FC_DB_POSTGRES" ] || (
    npm i pg
    make_migration "$FC_DB_POSTGRES" "postgres"
)

[ -z "$FC_DB_MARIADB" ] || (
    npm i mysql2
    make_migration "$FC_DB_MARIADB" "mariadb"
)

[ -f ".env.tmp" ] && mv .env.tmp .env 2>/dev/null

