#!/bin/sh

<<<<<<< HEAD:municipal-services/property-services/src/main/resources/db/migrate.sh
flyway -url=$DB_URL -table=$SCHEMA_TABLE -user=$FLYWAY_USER -password=$FLYWAY_PASSWORD -locations=$FLYWAY_LOCATIONS -baselineOnMigrate=true -outOfOrder=true -ignoreMissingMigrations=true migrate
=======
flyway -url=$DB_URL -table=$SCHEMA_TABLE -user=$FLYWAY_USER -password=$FLYWAY_PASSWORD -locations=$FLYWAY_LOCATIONS -baselineOnMigrate=true -outOfOrder=true migrate
>>>>>>> master:core-services/egov-pg-service/src/main/resources/db/migrate.sh
